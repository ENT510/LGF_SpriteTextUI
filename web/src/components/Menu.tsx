import React from "react";
import { Text, Flex, RingProgress } from "@mantine/core";
import { motion } from "framer-motion";

interface InteractionProps {
  visible: boolean;
  message: string;
  bind: string;
  useOnlyBind: boolean;
  circleColor: string;
  progress: number; 
}

const Interaction: React.FC<InteractionProps> = ({
  visible,
  message,
  bind,
  useOnlyBind,
  circleColor,
  progress
}) => {
  return (
    <motion.div
      className={`textUi ${visible ? "slide-in" : "slide-out"}`}
      style={{
        display: "flex",
        position: "fixed",
        left: "50%",
        top: "50%",
        transform: "translate(-50%, -50%)",
        zIndex: 9999,
        backgroundColor: "hsl(222.2 47.4% 11.2%)",
        width: "auto",
        border: "1px solid rgba(55, 65, 81, 0.8)",
        maxWidth: "250px",
        color: "#fff",
        borderRadius: "7px",
        padding: "6px",
      }}
      initial={{ opacity: 0 }}
      animate={{ opacity: visible ? 1 : 0 }}
      transition={{ duration: 0.7 }}
    >
      <Flex
        gap="xs"
        justify="flex-start"
        align="center"
        direction="row"
        wrap="nowrap"
        style={{ width: "100%" }}
      >
        <RingProgress
          size={40}
          thickness={3}
          sections={[{ value: progress || 100, color: circleColor }]}
          label={
            <Text size="xs" align="center" color="white">
              {bind}
            </Text>
          }
        />

        {!useOnlyBind && (
          <Text tt="uppercase" size={12} weight={650} style={{ flexGrow: 1 }}>
            {message}
          </Text>
        )}
      </Flex>
    </motion.div>
  );
};

export default Interaction;
