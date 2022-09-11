import React from 'react'
import styled from "styled-components"
import { useState } from 'react';

const StyledAccordionList = styled.div`
  width: 50%;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  padding-right: 75px;
  position: relative;
  z-index: 10;

  h1 {
    text-align: left;
    width: 100%;
    margin-bottom: 30px;
  }
`

const SharingList = () => {
  return (
    <StyledAccordionList>
      <h1>Sharing</h1>
      <ul>
      <li>Security is everyone&apos;s responsibility</li>
      <li>Autonomous ability to identify and implement Security</li>
      <li>Security Drills</li>
      </ul>
    </StyledAccordionList>
  )
}

export default SharingList
