import React, { useEffect, useState } from "react";
import { Button } from "@mantine/core";
import Menu from "./Menu";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { isEnvBrowser } from "../utils/misc";
import "./index.scss";

const App: React.FC = () => {
  const [textuiVisible, setTextUIvisible] = useState(false);
  const [message, setMessage] = useState("");
  const [bind, setBind] = useState("");
  const [circleColor, setCircleColor] = useState("");
  const [progress, setProgress] = useState(0);
  const [useOnlyBind, setOnlyBind] = useState(false);
  const [bgColor, setBgColor] = useState("");
  useNuiEvent<any>("manageTextUI", (data) => {
    setTextUIvisible(data.Visible);
    setMessage(data.Message);
    setBind(data.Bind);
    setOnlyBind(data.UseOnlyBind);
    setCircleColor(data.CircleColor);
    setBgColor(data.BgColor);
  });

  useNuiEvent<any>("updateProgress", (data) => {
    setProgress(data.Progress);
  });

  return (
    <>
      <Menu
        visible={textuiVisible}
        message={message}
        bind={bind}
        useOnlyBind={useOnlyBind}
        circleColor={circleColor}
        progress={progress}
        bgColor={bgColor}
      />

      {isEnvBrowser() && (
        <div style={{ position: "fixed", top: 10, right: 10, zIndex: 1000 }}>
          <Button
            onClick={() => setTextUIvisible((prev) => !prev)}
            variant="default"
            color="orange"
          >
            Toggle Interact
          </Button>
        </div>
      )}
    </>
  );
};

export default App;
