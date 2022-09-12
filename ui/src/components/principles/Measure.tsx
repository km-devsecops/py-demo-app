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

const MeasureList = () => {
  return (
    <StyledAccordionList>
      <h1>Measure</h1>
      <ul>
      <li>Measurements of both Production and Non-Production</li>
      <li>Definition of Security as part of business value and success critieria</li>
      <li>Security Scorecards</li>
      </ul>
    </StyledAccordionList>
  )
}

export default MeasureList
