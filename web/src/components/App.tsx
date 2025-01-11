import React, { useEffect, useState } from "react";
import { Button } from "@mantine/core";
import TextUi from "./Menu";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { isEnvBrowser } from "../utils/misc";
import "./index.scss";

import { fetchNui } from "../utils/fetchNui";

const App: React.FC = () => {
  const [textuiVisible, setTextUIvisible] = useState(false);
  const [message, setMessage] = useState("");
  const [bind, setBind] = useState("");
  const [CircleColor, setCircleColor] = useState("");

  const [useOnlyBind, setOnlyBind] = useState(false);
  useNuiEvent<any>("manageTextUI", (data) => {
    setTextUIvisible(data.Visible);
    setMessage(data.Message);
    setBind(data.Bind);
    setOnlyBind(data.useOnlyBind);
    setCircleColor(data.CircleColor);
  });

  return (
    <>
      <TextUi
        visible={textuiVisible}
        message={message}
        bind={bind}
        useOnlyBind={useOnlyBind}
        circleColor={CircleColor}
      />

      {isEnvBrowser() && (
        <div style={{ position: "fixed", top: 10, right: 10, zIndex: 1000 }}>
          <Button
            onClick={() => setTextUIvisible((prev) => !prev)}
            variant="default"
            color="orange"
          >
            Toggle Shop
          </Button>
        </div>
      )}
    </>
  );
};

export default App;
