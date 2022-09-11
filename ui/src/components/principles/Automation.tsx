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

const AutomationList = () => {
  return (
    <StyledAccordionList>
      <h1>Automation</h1>
      <ul>
      <li>Inclusion of Security in CI/CD Pipeline</li>
      <li>SAST and DAST checks</li>
      <li>Penetration Tests</li>
      </ul>
    </StyledAccordionList>
  )
}

export default AutomationList
