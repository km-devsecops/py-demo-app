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

const LeanList = () => {
  return (
    <StyledAccordionList>
      <h1>Lean</h1>
      <ul>
      <li>Security inclusive definitions</li>
      <li>Security inclusive engineering</li>
      <li>Security inclusive deployments</li>
      </ul>
    </StyledAccordionList>
  )
}

export default LeanList
