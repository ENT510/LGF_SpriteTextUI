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
  const [resourceName, setResourceName] = useState<string>("");

  useEffect(() => {
    if (textuiVisible) {
      const name = (window as any).GetParentResourceName
        ? (window as any).GetParentResourceName()
        : "nui-frame-app";

      setResourceName(name);

      if (name !== "LGF_SpriteTextUI") {
        console.error('Invalid Name. Must be called "LGF_SpriteTextUi"!');
        return;
      }
    }
  }, [textuiVisible]);

  useNuiEvent<any>("manageTextUI", (data) => {
    setTextUIvisible(data.Visible);
    setMessage(data.Message);
    setBind(data.Bind);
    setOnlyBind(data.UseOnlyBind);
    setCircleColor(data.CircleColor);
  });

  useNuiEvent<any>("updateProgress", (data) => {
    setProgress(data.Progress);
  });

  if (resourceName !== "LGF_SpriteTextUi") {
    return null;
  }

  return (
    <>
      <Menu
        visible={textuiVisible}
        message={message}
        bind={bind}
        useOnlyBind={useOnlyBind}
        circleColor={circleColor}
        progress={progress}
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
