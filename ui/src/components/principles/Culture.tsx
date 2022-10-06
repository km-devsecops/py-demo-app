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

const CultureList = () => {
  return (
    <StyledAccordionList>
      <h1>CULTURE</h1>
      <ul>
      <li>Security is included as part of requirements </li>
      <li>Included as part of everyone&apos;s objectives </li>
      </ul>
    </StyledAccordionList>
  )
}

export default CultureList
