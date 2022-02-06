      *=========================================================================
      *
      * PVFMONUSR
      * File monitoring tool.
      *
      * Version 1 Release 2 Modification 0
      *
      *  Compile as module. Then issue CRTPGM and bind with PVFMONUSU.
      *  E.g. CRTPGM PGM(PVFMONUSR) MODULE(PVFMONUSR PVFMONUSU) ACTGRP(*CALLER)
      *
      *=========================================================================
      * Maintenance Log
      * ---------------
      * Trace  Date      Pgmr.     Notes
      * ------------------------------------------------------------------------
      *        20030905  SyazwanH  New.
      *=========================================================================
      *-------------------------------------------------------------------------
      * Compile options
      *-------------------------------------------------------------------------
      *
     HAltseq(*None)
      *
      *-------------------------------------------------------------------------
      * Files declaration
      *-------------------------------------------------------------------------
      *
     FPvfmonusd CF   E             WorkStn UsrOpn
     F                                     InfDs(Keys)
      *
      *-------------------------------------------------------------------------
      * External procedures
      *-------------------------------------------------------------------------
      *
     D OpenFile        Pr                  ExtProc('pvOpenFile')
     D  FilNamPtr                      *   Const
     D  LibNamPtr                      *   Const
     D  MbrNamPtr                      *   Const
     D  NRec                         10I 0
     D  RecSz                        10I 0
     D  RsnCode                      10I 0
      *
     D ReadRrn         Pr                  ExtProc('pvReadRrn')
     D  MsgBuffPtr                     *
     D  MsgBuffSz                    10I 0
     D  RtnSz                        10I 0
     D  Rrn                          10I 0
     D  RsnCode                      10I 0
      *
     D ReadNext        Pr                  ExtProc('pvReadNext')
     D  MsgBuffPtr                     *
     D  MsgBuffSz                    10I 0
     D  RtnSz                        10I 0
     D  Rrn                          10I 0
     D  RsnCode                      10I 0
      *
     D ReadFirst       Pr                  ExtProc('pvReadFirst')
     D  MsgBuffPtr                     *
     D  MsgBuffSz                    10I 0
     D  RtnSz                        10I 0
     D  Rrn                          10I 0
     D  RsnCode                      10I 0
      *
     D CloseFile       Pr                  ExtProc('pvCloseFile')
     D  RsnCode                      10I 0
      *
     D RcvDtaq         Pr                  ExtPgm('QRCVDTAQ')
     D  DqNam                        10A   Const
     D  DqLib                        10A   Const
     D  DqLen                         5P 0
     D  DqMsg                       640A
     D  DqWait                        5P 0
      *
     D RetrDataArea    Pr                  ExtPgm('QWCRDTAA')
     D  RcvVar                      512A
     D  RcvVarLen                    10I 0 Const
     D  DataArea                     20A   Const
     D  StartPos                     10I 0 Const
     D  LenRead                      10I 0 Const
     D  ErrorCode                          Like(Qusec)
      *
     D RetrObjDesc     Pr                  ExtPgm('QUSROBJD')
     D  ObjDetl                            Like(Qusd0100)
     D  ObjDetlLen                   10I 0
     D  FmtName                       8A
     D  ObjectPath                   20A
     D  ObjType                      10A
     D  ErrorCode                          Like(Qusec)
      *
     D RetrMbrDesc     Pr                  ExtPgm('QUSRMBRD')
     D  MbrDetl                            Like(Qusm0100)
     D  MbrDetlLen                   10I 0
     D  FmtName_2                     8A
     D  FilePath                     20A
     D  FileMbr                      10A
     D  OvrProc                       1A
     D  ErrorCode                          Like(Qusec)
      *
     D System          Pr                  ExtPgm('QCMDEXC')
     D  ExtCmd                      512A   Options(*Varsize) Const
     D  ExtCmdLen                    15P 5 Const
      *
      *-------------------------------------------------------------------------
      * Copybooks
      *-------------------------------------------------------------------------
      *
      * Retrieve data area
     D/Copy Qsysinc/Qrpglesrc,Qwcrdtaa
      * Retrieve object description
     D/Copy Qsysinc/Qrpglesrc,Qusrobjd
      * Retrieve member description
     D/Copy Qsysinc/Qrpglesrc,Qusrmbrd
      * Error information
     D/Copy Qsysinc/Qrpglesrc,Qusec
      *
      *-------------------------------------------------------------------------
      * System data structure
      *-------------------------------------------------------------------------
      *
     D                SDs
     D  QMsgTyp               40     42A
     D  QMsgNbr               43     46A
      *
      *-------------------------------------------------------------------------
      * Local data structure
      *-------------------------------------------------------------------------
      *
     D Keys            Ds
     D  FncKey               369    369A
      *
     D Screen01        Ds
     D  WRec1
     D  WRec2
     D  WRec3
     D  WRec4
     D  WRec5
     D  WRec6
     D  WRec7
     D  WRec8
     D  WRec9
     D  WRec10
     D  WRec11
     D  WRec12
     D  WRec13
     D  WRec14
     D  WRec15
     D  WRec16
     D  WRec17
     D  WRec18
     D  ArrRec                       70A   Dim(18) Overlay(Screen01)
     D                                     Inz(*Blanks)
      *
     D Screen02        Ds
     D  WRrn1
     D  WRrn2
     D  WRrn3
     D  WRrn4
     D  WRrn5
     D  WRrn6
     D  WRrn7
     D  WRrn8
     D  WRrn9
     D  WRrn10
     D  WRrn11
     D  WRrn12
     D  WRrn13
     D  WRrn14
     D  WRrn15
     D  WRrn16
     D  WRrn17
     D  WRrn18
     D  ArrRrn                        7S 0 Dim(18) Overlay(Screen02)
     D                                     Inz(*Zeros)
      *
     D Screen03        Ds
     D  WIn81                         1N
     D  WIn82                         1N
     D  WIn83                         1N
     D  WIn84                         1N
     D  WIn85                         1N
     D  WIn86                         1N
     D  WIn87                         1N
     D  WIn88                         1N
     D  WIn89                         1N
     D  WIn90                         1N
     D  WIn91                         1N
     D  WIn92                         1N
     D  WIn93                         1N
     D  WIn94                         1N
     D  WIn95                         1N
     D  WIn96                         1N
     D  WIn97                         1N
     D  WIn98                         1N
     D  ArrInd                        1S 0 Dim(18) Overlay(Screen03)
     D                                     Inz(*Zeros)
      *
     D Screen04        Ds
     D  WDisplayBuff                 70A
     D  WDisplayArr                   1A   Dim(70) Overlay(Screen04)
     D                                     Inz(*Blanks)
      *
     D Position        Ds
     D  PosInZone                     5S 0 Inz(*Zeros)
     D  PosInChar                     5A   Overlay(Position)
      *
     D CvtChar2Num     Ds
     D  CvtChar                       2A   Inz(*All'0')
     D  CvtZone                       2S 0 Overlay(CvtChar2Num)
      *
     D                 Ds
     D  IntNum                        5I 0 Inz(*Zeros)
     D  IntChar                       1A   Overlay(IntNum:2)
      *
     D                 Ds
     D  ValueChar1                    1A   Inz(*Blanks)
     D  ValueChar2                    1A   Inz(*Blanks)
      *
     D CvtTimStm       Ds                  Qualified
     D  Time                           Z   Inz
     D  Char                         26A   Overlay(CvtTimStm:1)
      *
     D ObjectPath      Ds            20    Qualified
     D  Name                   1     10A   Inz(*Blanks)
     D  Library               11     20A   Inz(*Blanks)
      *
     D FilePath        Ds            20    Qualified
     D  Name                   1     10A   Inz(*Blanks)
     D  Library               11     20A   Inz(*Blanks)
      *
      *-------------------------------------------------------------------------
      * Local variables
      *-------------------------------------------------------------------------
      *
     D MsgBuffPtr      S               *   Inz(%Addr(MsgBuff))
     D MsgBuff         S          32767A   Inz(*Blanks)
     D MsgBuffSz       S             10I 0 Inz(%Size(MsgBuff))
     D ArrHst          S          32767A   Dim(18) Inz(*Blanks)
     D RtnSz           S             10I 0 Inz(*Zeros)
     D Rrn             S             10I 0 Inz(*Zeros)
     D NRec            S             10I 0 Inz(*Zeros)
     D RecSz           S             10I 0 Inz(*Zeros)
     D RsnCode         S             10I 0 Inz(*Zeros)
      *
     D DqNam           S             10A   Inz('PVFMONUS')
     D DqLib           S             10A   Inz('QTEMP')
     D DqLen           S              5P 0 Inz(*Zeros)
     D DqMsg           S            640A   Inz(*Blanks)
     D DqWait          S              5P 0 Inz(1)
      *
     D ExtCmd          S            512A   Inz(*Blanks)
     D ExtCmdLen       S             15P 5 Inz(%Size(ExtCmd))
     D RcvVar          S            512A   Inz(*Blanks)
     D RcvVarLen       S             10I 0 Inz(%Size(RcvVar))
     D DataArea        S             20A   Inz('PVFMONUS  QTEMP     ')
     D StartPos        S             10I 0 Inz(1)
     D LenRead         S             10I 0 Inz(512)
     D ErrorCode       S                   Like(Qusec) Inz(*Blanks)
      *
     D HexInt          S             10I 0 Inz(*Zeros)
     D HexChar         S              1A   Inz(*Blanks)
     D OffSetA         S             10I 0 Inz(*Zeros)
     D OffSetB         S             10I 0 Inz(*Zeros)
     D XByte           S              1A   Inz(*Blanks)
      *
     D ObjDetl         S                   Like(Qusd0100)
     D ObjDetlLen      S             10I 0 Inz(%Size(ObjDetl))
     D FmtName         S              8A   Inz('OBJD0100')
     D ObjType         S             10A   Inz(*Blanks)
     D MbrDetl         S                   Like(Qusm0100)
     D MbrDetlLen      S             10I 0 Inz(%Size(MbrDetl))
     D FormatName      S              8A   Inz('MBRD0100')
     D FileMbr         S             10A   Inz(*Blanks)
     D OvrProc         S              1A   Inz('0')
      *
     D BytesLeft       S             10I 0 Inz(*Zeros)
     D StrPos          S             10I 0 Inz(1)
     D RuleLen         S             10I 0 Inz(*Zeros)
     D RulePos         S             10I 0 Inz(*Zeros)
     D RuleRmn         S             10I 0 Inz(*Zeros)
     D Len             S             10I 0 Inz(70)
     D ArrN            S             10I 0 Inz(*Zeros)
     D X               S             10I 0 Inz(*Zeros)
     D Y               S             10I 0 Inz(*Zeros)
     D XNumber         S             10I 0 Inz(*Zeros)
     D XNumber1        S             10I 0 Inz(*Zeros)
     D XNumber2        S             10I 0 Inz(*Zeros)
     D PrvClock        S               Z   Inz
     D CurClock        S               Z   Inz
     D CmpClock        S               Z   Inz
      *
     D QEnd            S              1N   Inz(*Off)
     D QSkip           S              1N   Inz(*Off)
     D QFirst          S              1N   Inz(*On)
     D QRefresh        S              1N   Inz(*On)
     D QActivity       S              1N   Inz(*On)
     D QIdleClock      S              1N   Inz(*Off)
     D QExtended       S              1N   Inz(*Off)
      *
      *-------------------------------------------------------------------------
      * Local constants
      *-------------------------------------------------------------------------
      *
     D HexDigits       C                   Const('0123456789ABCDEF')
     D Rule            C                   Const('....+....1....+....2....+....-
     D                                     3....+....4....+....5....+....6....+-
     D                                     ....7....+....8....+....9....+....0')
      *
      *-------------------------------------------------------------------------
      * Main logic
      *-------------------------------------------------------------------------
      *
      /Free

          // Create data queue to override display file.
          // Then override display file.

          ExSr CreateDataQueue;
          ExSr CreateOverride;
          Open Pvfmonusd;

          // Get program parameters input from user.

          ExSr PgmInit;
          ExSr GetParameter;

          // We have the file path, now open the file via C interface.

          If (QEnd = *Off);
             OpenFile (%Addr(WFil) : %Addr(WLib) : %Addr(WMbr) :
                       NRec : RecSz : RsnCode);

             WPath = (%TrimR(WLib) + '/' + %TrimR(WFil) +
                      '(' + %TrimR(WMbr) + ')');

             If (NRec > *Zeros);
                ExSr InitDisplay;
             EndIf;
          EndIf;

          DoW (QEnd = *Off);

             If (QRefresh = *On);
                QRefresh = *Off;

                CvtTimStm.Time = (%TimeStamp);
                WTimStm = (CvtTimStm.Char);
                CurClock = CvtTimStm.Time;

                // Keep track of how long have time passes since the last
                // record entry on file.

                If (QFirst = *Off);
                   If (QActivity = *Off);
                      If (PrvClock = CmpClock);
                         PrvClock = CurClock;
                      EndIf;
                      X = (%Diff(CurClock:PrvClock:*H));
                      WHour = X;
                      X = (%Diff(CurClock:PrvClock:*Mn));
                      If (X > 59);
                         DoU (X < 60);
                            X -= 60;
                         EndDo;
                      EndIf;
                      WMins = X;
                      X = (%Diff(CurClock:PrvClock:*S));
                      If (X > 59);
                         DoU (X < 60);
                            X -= 60;
                         EndDo;
                      EndIf;
                      WSecs = X;
                      QActivity = *On;
                   Else;
                      WHour = *Zeros;
                      WMins = *Zeros;
                      WSecs = *Zeros;
                   EndIf;
                Else;
                   QFirst = *Off;
                EndIf;

                // Build measurement rule, then write display to screen.
                // We do not wait on display, therefore we wait on data queue.

                ExSr GetRule;

                Write(E) D01;

                // If terminal and server session not in sync, then problem
                // would occur. In such event, force read on display before
                // re-writing the display.

                If (QMsgTyp = 'CPF' And QMsgNbr = '4737');
                   Read D01;
                   QSkip = *On;
                EndIf;
             EndIf;

             If (QSkip = *Off);
                RcvDtaq (DqNam : DqLib : DqLen : DqMsg : DqWait);
                If (DqLen > *Zeros);
                   Read D01;
                Else;
                   ExSr GetNewData;
                EndIf;
             Else;
                QSkip = *Off;
             EndIf;

             Select;

                // User requested exit.

                When (*In03 = *On) Or (*In12 = *On);
                   QEnd = *On;
                   Iter;

                // Move screen to the left.

                When (*In19 = *On);
                   If (QExtended = *On);
                      QExtended = *Off;
                   EndIf;
                   If (StrPos > 70);
                      StrPos -= 70;
                      For X = 1 By 1 To Arrn;
                         WDisplayBuff = (%Subst(ArrHst(X):StrPos:Len));
                         For Y = 1 By 1 To 70;
                            HexChar = WDisplayArr(Y);
                            ExSr StringToHex;
                            If (HexInt < 64);
                               WDisplayArr(Y) = ('?');
                            EndIf;
                         EndFor;
                         ArrRec(X) = WDisplayBuff;
                      EndFor;
                   EndIf;
                   QRefresh = *On;
                   QActivity = *Off;
                   *In19 = *Off;

                // Move screen to the right.

                When (*In20 = *On);
                   If ((StrPos + 70) <= RecSz);
                      StrPos += 70;
                      For X = 1 By 1 To Arrn;
                         WDisplayBuff = (%Subst(ArrHst(X):StrPos:Len));
                         For Y = 1 By 1 To 70;
                            HexChar = WDisplayArr(Y);
                            ExSr StringToHex;
                            If (HexInt < 64);
                               WDisplayArr(Y) = ('?');
                            EndIf;
                         EndFor;
                         ArrRec(X) = WDisplayBuff;
                      EndFor;
                      BytesLeft = ((RecSz - StrPos) + 1);
                      If (BytesLeft > *Zeros) And (BytesLeft < 70);
                         QExtended = *On;
                      EndIf;
                   EndIf;
                   QRefresh = *On;
                   QActivity = *Off;
                   *In20 = *Off;

                // Display physical file member.

                When (*In23 = *On);
                   ExSr RunDsppfm;
                   *In23 = *Off;

                // Enter key was pressed.

                When (FncKey = X'F1');
                   QRefresh= *On;
                   QActivity = *Off;

             EndSl;

          EndDo;

          // Close the file via C interface before exiting.
          // Delete display file override, and delete data queue.

          CloseFile (RsnCode);

          Close Pvfmonusd;
          ExSr DeleteOverride;
          ExSr DeleteDataQueue;

          *Inlr = *On;

        //-----------------------------------------------------------------------
        // Sub Routine GetParameter
        //   Get parameters for processing
        //-----------------------------------------------------------------------

          BegSr GetParameter;

             DoW (QEnd = *Off);

                Exfmt D02;

                *In51 = *Off;
                *In52 = *Off;
                *In53 = *Off;
                WMsg = *Blanks;

                If (*In03 = *On) Or (*In12 = *On);
                   QEnd = *On;
                   Iter;
                EndIf;

                If (WFil = *Blanks);
                   WMsg = ('File name cannot be blanks!');
                   *In51 = *On;
                   Iter;
                EndIf;
                If (WLib = *Blanks);
                   WMsg = ('Library name cannot be blanks!');
                   *In52 = *On;
                   Iter;
                EndIf;
                If (WMbr = *Blanks);
                   WMsg = ('Member name cannot be blanks!');
                   *In53 = *On;
                   Iter;
                EndIf;

                // Check whether library exists

                If (WLib <> '*LIBL');

                   Reset Qusec;
                   Qusbprv = (%Size(Qusec));
                   Qusbavl = *Zeros;
                   ErrorCode = Qusec;

                   ObjectPath.Name = WLib;
                   ObjectPath.Library = 'QSYS';
                   ObjType = '*LIB';

                   CallP(E) RetrObjDesc (ObjDetl : ObjDetlLen : FmtName :
                                         ObjectPath : ObjType : ErrorCode);

                   Qusec = Errorcode;

                   If (Qusei <> *Blanks);
                      WMsg = ('Error ' + (%TrimR(Qusei)) +
                              ' when searching for library.');
                      Iter;
                   EndIf;

                EndIf;

                // Check whether file exists

                Reset Qusec;
                Qusbprv = (%Size(Qusec));
                Qusbavl = *Zeros;
                ErrorCode = Qusec;

                ObjectPath.Name = WFil;
                ObjectPath.Library = WLib;
                ObjType = '*FILE';

                CallP(E) RetrObjDesc (ObjDetl : ObjDetlLen : FmtName :
                                      ObjectPath : ObjType : ErrorCode);


                Qusec = Errorcode;

                If (Qusei <> *Blanks);
                   WMsg = ('Error ' + (%TrimR(Qusei)) +
                           ' when searching for file.');
                   Iter;
                EndIf;

                If (WLib = '*LIBL');
                   Qusd0100 = ObjDetl;
                   WLib = Qusrl01;
                EndIf;

                // Check whether member exists

                Reset Qusec;
                Qusbprv = (%Size(Qusec));
                Qusbavl = *Zeros;
                ErrorCode = Qusec;

                FilePath.Name = WFil;
                FilePath.Library = WLib;
                FileMbr = WMbr;

                CallP(E) RetrMbrDesc (MbrDetl : MbrDetlLen : FormatName :
                                      FilePath : FileMbr : OvrProc :
                                      ErrorCode);

                Qusec = Errorcode;

                If (Qusei <> *Blanks);
                   WMsg = ('Error ' + (%TrimR(Qusei)) +
                           ' when searching for member.');
                   Iter;
                EndIf;

                If (%Subst(WMbr:1:1) = '*');
                   Qusm0100 = MbrDetl;
                   WMbr = Qusmn02;
                EndIf;

                ExSr UpdateDataArea;

                QEnd = *On;

             EndDo;

             If ((*In03 = *Off) And (*In12 = *Off));
                QEnd = *Off;
             EndIf;

          EndSr;

         //-----------------------------------------------------------------------
         // Sub Routine InitDisplay
         //   Build initial display
         //-----------------------------------------------------------------------

          BegSr InitDisplay;

             Reset ArrRec;
             Reset ArrRrn;
             Reset ArrInd;
             Reset ArrHst;
             ArrN = *Zeros;
             WNMsg = *Zeros;

             MsgBuffSz = RecSz;
             If (NRec > 18);
                Rrn = (NRec - 18);
                Rrn += 1;

                ReadRrn (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : RsnCode);

                If (RtnSz > *Zeros);
                   ArrN += 1;
                   ArrHst(ArrN) = (%Subst(MsgBuff:1:RecSz));
                   WDisplayBuff = (%Subst(MsgBuff:StrPos:Len));
                   For X = 1 By 1 To 70;
                      HexChar = WDisplayArr(X);
                      ExSr StringToHex;
                      If (HexInt < 64);
                         WDisplayArr(X) = ('?');
                      EndIf;
                   EndFor;
                   ArrRec(ArrN) = WDisplayBuff;
                   ArrRrn(ArrN) = Rrn;

                   For X = 1 By 1 To 17;
                      ReadNext (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : RsnCode);
                      If (RtnSz > *Zeros);
                         ArrN += 1;
                         ArrHst(ArrN) = (%Subst(MsgBuff:1:RecSz));
                         WDisplayBuff = (%Subst(MsgBuff:StrPos:Len));
                         For Y = 1 By 1 To 70;
                            HexChar = WDisplayArr(Y);
                            ExSr StringToHex;
                            If (HexInt < 64);
                               WDisplayArr(Y) = ('?');
                            EndIf;
                         EndFor;
                         ArrRec(ArrN) = WDisplayBuff;
                         ArrRrn(ArrN) = Rrn;
                      Else;
                         Leave;
                      EndIf;
                   EndFor;
                EndIf;

             Else;
                For X = 1 By 1 To 18;
                   ReadNext (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : RsnCode);
                   If (RtnSz > *Zeros);
                      ArrN += 1;
                      ArrHst(ArrN) = (%Subst(MsgBuff:1:RecSz));
                      WDisplayBuff = (%Subst(MsgBuff:StrPos:Len));
                      For Y = 1 By 1 To 70;
                         HexChar = WDisplayArr(Y);
                         ExSr StringToHex;
                         If (HexInt < 64);
                            WDisplayArr(Y) = ('?');
                         EndIf;
                      EndFor;
                      ArrRec(ArrN) = WDisplayBuff;
                      ArrRrn(ArrN) = Rrn;
                   Else;
                      Leave;
                   EndIf;
                EndFor;
             EndIf;

          EndSr;

         //-----------------------------------------------------------------------
         // Sub Routine GetNewData
         //   Get new records from file
         //-----------------------------------------------------------------------

           BegSr GetNewData;

              If (ArrN <= *Zeros);
                 ReadFirst (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : RsnCode);
              Else;
                 ReadNext (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : RsnCode);
              EndIf;
              If (RtnSz > *Zeros);
                 WNMsg += 1;
                 If (ArrN < 18);
                    ArrN += 1;
                    ArrHst(ArrN) = (%Subst(MsgBuff:1:RecSz));
                    WDisplayBuff = (%Subst(MsgBuff:StrPos:Len));
                    For X = 1 By 1 To 70;
                       HexChar = WDisplayArr(X);
                       ExSr StringToHex;
                       If (HexInt < 64);
                          WDisplayArr(X) = ('?');
                       EndIf;
                    EndFor;
                    ArrRec(ArrN) = WDisplayBuff;
                    ArrRrn(ArrN) = Rrn;
                    ArrInd(ArrN) = 1;
                 Else;
                    For X = 1 By 1 To 17;
                       ArrRec(X) = ArrRec(X+1);
                       ArrRrn(X) = ArrRrn(X+1);
                       ArrInd(X) = ArrInd(X+1);
                       ArrHst(X) = ArrHst(X+1);
                    EndFor;
                    X = 18;
                   ArrHst(X) = (%Subst(MsgBuff:1:RecSz));
                   WDisplayBuff = (%Subst(MsgBuff:StrPos:Len));
                   For Y = 1 By 1 to 70;
                      HexChar = WDisplayArr(Y);
                      ExSr StringToHex;
                      If (HexInt < 64);
                         WDisplayArr(Y) = ('?');
                      EndIf;
                   EndFor;
                   ArrRec(X) = WDisplayBuff;
                   ArrRrn(X) = Rrn;
                   ArrInd(X) = 1;
                EndIf;

                DoW (1 = 1);
                   ReadNext (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : RsnCode);
                   If (RtnSz > *Zeros);
                   WNMsg += 1;
                      If (ArrN < 18);
                         ArrN += 1;
                         ArrHst(ArrN) = (%Subst(MsgBuff:1:RecSz));
                         WDisplayBuff = (%Subst(MsgBuff:StrPos:Len));
                         For X = 1 By 1 To 70;
                            HexChar = WDisplayArr(X);
                            ExSr StringToHex;
                            If (HexInt < 64);
                               WDisplayArr(X) = ('?');
                            EndIf;
                         EndFor;
                         ArrRec(ArrN) = WDisplayBuff;
                         ArrRrn(ArrN) = Rrn;
                         ArrInd(ArrN) = 1;
                      Else;
                         For X = 1 By 1 To 17;
                            ArrRec(X) = ArrRec(X+1);
                            ArrRrn(X) = ArrRrn(X+1);
                            ArrInd(X) = ArrInd(X+1);
                            ArrHst(X) = ArrHst(X+1);
                         EndFor;
                         X = 18;
                         ArrHst(X) = (%Subst(MsgBuff:1:RecSz));
                         WDisplayBuff = (%Subst(MsgBuff:StrPos:Len));
                         For Y = 1 By 1 To 70;
                            HexChar = WDisplayArr(Y);
                            ExSr StringToHex;
                            If (HexInt < 64);
                               WDisplayArr(Y) = ('?');
                            EndIf;
                         EndFor;
                         ArrRec(X) = WDisplayBuff;
                         ArrRrn(X) = Rrn;
                         ArrInd(X) = 1;
                      EndIf;
                   Else;
                      Leave;
                   EndIf;
                EndDo;

                QRefresh = *On;
                If (QIdleClock = *On);
                   QIdleClock = *Off;
                EndIf;
                ExSr SetHighlight;
             Else;
                WNMsg = *Zeros;
                If (ArrN > *Zeros);
                   Rrn = (ArrRrn(ArrN));
                   ReadRrn (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : RsnCode);
                EndIf;
                If (QIdleClock = *Off);
                   QIdleClock = *On;
                   PrvClock = CurClock;
                EndIf;
                QRefresh = *On;
                QActivity = *Off;
                Reset ArrInd;
                ExSr SetHighlight;
             EndIf;

          EndSr;

        //-----------------------------------------------------------------------
        // Sub Routine SetHighlight
        //   Highlight new records on display
        //-----------------------------------------------------------------------

          BegSr SetHighlight;

             *In81 = WIn81;
             *In82 = WIn82;
             *In83 = WIn83;
             *In84 = WIn84;
             *In85 = WIn85;
             *In86 = WIn86;
             *In87 = WIn87;
             *In88 = WIn88;
             *In89 = WIn89;
             *In90 = WIn90;
             *In91 = WIn91;
             *In92 = WIn92;
             *In93 = WIn93;
             *In94 = WIn94;
             *In95 = WIn95;
             *In96 = WIn96;
             *In97 = WIn97;
             *In98 = WIn98;

          EndSr;

        //-----------------------------------------------------------------------
        // Sub Routine CreateDataQueue
        //   Create data queue
        //-----------------------------------------------------------------------

          BegSr CreateDataQueue;

             ExtCmd = ('CRTDTAQ DTAQ(QTEMP/PVFMONUS) MAXLEN(640) ' +
                       'SENDERID(*YES) AUTORCL(*YES) AUT(*ALL)');

             CallP(E) System (ExtCmd : ExtCmdLen);

          EndSr;

        //-----------------------------------------------------------------------
        // Sub Routine DeleteDataQueue
        //   Delete data queue
          //-----------------------------------------------------------------------

            BegSr DeleteDataQueue;

               ExtCmd = ('DLTDTAQ DTAQ(QTEMP/PVFMONUS)');

               CallP(E) System (ExtCmd : ExtCmdLen);

            EndSr;

          //-----------------------------------------------------------------------
          // Sub Routine CreateOverride
          //   Override display file
          //-----------------------------------------------------------------------

            BegSr CreateOverride;

               ExtCmd = ('OVRDSPF FILE(PVFMONUSD) DTAQ(QTEMP/PVFMONUS) ' +
                         'SHARE(*YES) SECURE(*YES)');

               CallP(E) System (ExtCmd : ExtCmdLen);

            EndSr;

          //-----------------------------------------------------------------------
          // Sub Routine DeleteOverride
          //   Delete display file override
          //-----------------------------------------------------------------------

            BegSr DeleteOverride;

               ExtCmd = ('DLTOVR FILE(*ALL)');

               CallP(E) System (ExtCmd : ExtCmdLen);

            EndSr;

          //-----------------------------------------------------------------------
          // Sub Routine CreateDataArea
          //   Creates a data area to store temporary parameters
          //-----------------------------------------------------------------------

            BegSr CreateDataArea;

               ExtCmd = ('CRTDTAARA DTAARA(QTEMP/PVFMONUS) ' +
                         'TYPE(*CHAR) LEN(512)');

               CallP(E) System (ExtCmd : ExtCmdLen);

            EndSr;

          //-----------------------------------------------------------------------
          // Sub Routine UpdateDataArea
          //   Updates the data area to store temporary parameters
          //-----------------------------------------------------------------------

            BegSr UpdateDataArea;

               // Update file name

               ExtCmd = ('CHGDTAARA DTAARA(QTEMP/PVFMONUS  ' +
                         '(1 10)) VALUE(' + %TrimR(WFil)) + ')';

               CallP(E) System (ExtCmd : ExtCmdLen);

               // Update library name

               ExtCmd = ('CHGDTAARA DTAARA(QTEMP/PVFMONUS  ' +
                         '(11 10)) VALUE(' + %TrimR(WLib)) + ')';

               CallP(E) System (ExtCmd : ExtCmdLen);

               // Update member name

               ExtCmd = ('CHGDTAARA DTAARA(QTEMP/PVFMONUS  ' +
                         '(21 10)) VALUE(' + %TrimR(WMbr)) + ')';

               CallP(E) System (ExtCmd : ExtCmdLen);

            EndSr;

          //-----------------------------------------------------------------------
          // Sub Routine StringToHex
          //   Convert string to hex to integer
          //-----------------------------------------------------------------------

            BegSr StringToHex;

               IntChar = (HexChar);
               OffSetA = (%Div(IntNum:16));
               OffSetB = (%Rem(IntNum:16));
               ValueChar1 = (%Subst(HexDigits:OffSetA+1:1));
               ValueChar2 = (%Subst(HexDigits:OffSetB+1:1));

               XByte = ValueChar1;
               ExSr GetNumber;
               XNumber1 = XNumber;

               XByte = ValueChar2;
               ExSr GetNumber;
               XNumber2 = XNumber;

               XNumber1 = (XNumber1 * 16);
               XNumber = (XNumber1 + XNumber2);

               HexInt = XNumber;

            EndSr;

          //-----------------------------------------------------------------------
          // Sub Routine GetNumber
          //   Convert number from hex values
          //-----------------------------------------------------------------------

            BegSr GetNumber;

               Select;

                  When XByte = '0';
                     XNumber = 0;

                  When XByte = '1';
                     XNumber = 1;

                  When XByte = '2';
                     XNumber = 2;

                  When XByte = '3';
                     XNumber = 3;

                  When XByte = '4';
                     XNumber = 4;

                  When XByte = '5';
                     XNumber = 5;

                  When XByte = '6';
                     XNumber = 6;

                  When XByte = '7';
                     XNumber = 7;

                  When XByte = '8';
                     XNumber = 8;

                  When XByte = '9';
                     XNumber = 9;

                  When XByte = 'A';
                     XNumber = 10;

                  When XByte = 'B';
                     XNumber = 11;

                  When XByte = 'C';
                     XNumber = 12;

                  When XByte = 'D';
                     XNumber = 13;

                  When XByte = 'E';
                     XNumber = 14;

                  When XByte = 'F';
                     XNumber = 15;

               EndSl;

            EndSr;

          //-----------------------------------------------------------------------
          // Sub Routine GetRule
          //   Get measurement rule
          //-----------------------------------------------------------------------

            BegSr GetRule;

               PosInZone = StrPos;
               %Subst(CvtChar:2:1) = (%Subst(PosInChar:5:1));
               %Subst(CvtChar:1:1) = (%Subst(PosInChar:4:1));

               If (CvtZone = *Zeros) And (%Subst(PosInChar:1:3) = '000');
                  WRule = *Blanks;
               Else;
                  If (CvtZone = *Zeros);
                     CvtZone += 1;
                  EndIf;
                  RuleLen = ((100 - CvtZone) + 1);
                  WRule = (%Subst(Rule:CvtZone:RuleLen));
                  RuleRmn = (70 - RuleLen);
                  If (RuleRmn > *Zeros);
                     RulePos = (RuleLen + 1);
                     %Subst(WRule:RulePos) = (%Subst(Rule:1:RuleRmn));
                  EndIf;
               EndIf;

               If (QExtended = *On);
                  %Subst(WRule:BytesLeft+1) = *Blanks;
               EndIf;

            EndSr;

          //-----------------------------------------------------------------------
          // Sub Routine RunDsppfm
          //   Execute Dsppfm Command
          //-----------------------------------------------------------------------

            BegSr RunDsppfm;

               ExtCmd = ('DSPPFM FILE(' + %TrimR(WLib) + '/' +
                         %TrimR(WFil) + ') MBR(' + %TrimR(WMbr) +
                         ') FROMRCD(' + %TrimR(%Char(WRrn1)) + ')');

               CallP(E) System (ExtCmd : ExtCmdLen);

            EndSr;

          //-----------------------------------------------------------------------
          // Sub Routine PgmInit
          //   Program initialization
          //-----------------------------------------------------------------------

            BegSr PgmInit;

               // We do not know at this point whether data area exists or not,
               // but it doesn't hurt to try and create one.

               ExSr CreateDataArea;

               // If data area had been existing since before this program was call
               // there would be stored parameters. Try to retrieve those.

               Reset Qusec;
               Qusbprv = (%Size(Qusec));
               Qusbavl = *Zeros;
               ErrorCode = Qusec;
               RcvVar = *Blanks;

               CallP(E) RetrDataArea (RcvVar : RcvVarLen : DataArea :
                                      StartPos : LenRead : ErrorCode);

               Qwcrdrtn = (%Subst(RcvVar:1));
               If (%Subst(RcvVar:(%Size(Qwcrdrtn)+1)) <> *Blanks);
                  WFil = (%Subst(RcvVar:(%Size(Qwcrdrtn)+1):10));
                  WLib = (%Subst(RcvVar:(%Size(Qwcrdrtn)+11):10));
                  WMbr = (%Subst(RcvVar:(%Size(Qwcrdrtn)+21):10));
               Elseif
                  WFil = *Blanks;
                  WLib = *Blanks;
                  WMbr = '*FIRST';
               Else;
                  WFil = *Blanks;
                  WLib = *Blanks;
                  WMbr = '*FIRST';
               EndIf;

            EndSr;

      /End-Free
