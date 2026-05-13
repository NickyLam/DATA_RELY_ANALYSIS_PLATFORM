CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_704_ZCZRGXB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_EAST5_704_ZCZRGXB
  *  功能描述：资产转让关系表
  *  创建日期：20220713
  *  开发人员：王锐
  *  来源表： M_LOAN_TRF_REL_INFO  资产转让关系信息
              M_PUM_ORG_INFO_EAST   机构表
              M_LOAN_TRF_INFO  信贷资产转让信息
              CONFIG_ORG_REL  机构级次关系表
              CONFIG_TABLE_LIST   分行报送报表配置表
  *  目标表： EAST5_704_ZCZRGXB 资产转让关系表
  *
  *  配置表：
  *  修改日期  修改人     修改原因
  *  20221207  LHQ        根据业务口径 剔除历史已转让的数据
  *
  ***************************************************************************/
AS
  --定义变量
  V_P_DATE         VARCHAR2(8);      --跑批数据日期
  V_STEP_DESC      VARCHAR2(100);    --处理步骤描述
  V_STARTTIME      DATE := SYSDATE;  --处理开始时间
  V_ENDTIME        DATE := SYSDATE;  --处理结束时间
  V_STEP           INTEGER := 0;     --处理步骤
  V_SQLCOUNT       INTEGER := 0;     --更新或删除影响的记录数
  V_COUNT          INTEGER := 0;     --数据记录条数
  V_SQLMSG         VARCHAR2(300);    --SQL执行描述信息
  V_LAST_DAT       VARCHAR2(8);      --当月月末
  V_FREQ_FLAG      VARCHAR2(10);     --跑批频度
  V_PARTITION_NAME VARCHAR2(100);    --分区名
  V_TABLE_NAME     VARCHAR2(100) := 'EAST5_704_ZCZRGXB'; --表名称
  V_PROC_NAME      VARCHAR2(30) := 'ETL_EAST5_704_ZCZRGXB'; --程序名称
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := I_P_DATE; --获取跑批日期
  O_ERRCODE := '0';
  V_LAST_DAT := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD'); --当月月底
  V_PARTITION_NAME := 'PARTITION_'||V_P_DATE;
  V_FREQ_FLAG := RRP_EAST.FUN_FREQ(I_P_DATE,V_PROC_NAME); --跑批频度判断

  --判断跑批频度
  IF V_FREQ_FLAG = '1' THEN

    --支持重跑
    V_STEP := 1;
    V_STEP_DESC := '程序跑批开始';
    V_STARTTIME := SYSDATE;
    RRP_EAST.ETL_PARTITION_ADD(V_LAST_DAT, V_TABLE_NAME, 1, O_ERRCODE); --新建分区
    RRP_EAST.ETL_PARTITION_TRUNCATE(V_LAST_DAT, V_TABLE_NAME, O_ERRCODE); --清空当日分区以便重跑

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '插入目标表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_704_ZCZRGXB(
      RID,         --数据主键
      JRXKZH,      --金融许可证号
      NBJGH,       --内部机构号
      ZRHTH,       --转让合同号
      XDZCLX,      --信贷资产类型
      XDJJH,       --信贷借据号
      ZRDKBJ,      --转让贷款本金
      ZRDKLX,      --转让贷款利息
      BBZ,         --备注
      CJRQ,        --采集日期
      DEPT_NO,     --部门编号
      SRC_SYS_ID,  --来源系统ID
      ISSUED_NO,   --填报机构
      ORG_NO,      --报送机构
      ADDRESS,     --归属地
      GSFZJG,      --归属分支机构
      ZCZRFX       --资产转让方向 --ADD BY LIP 20240204
      )
    SELECT SYS_GUID()                                                   AS RID,         --数据主键
           REPLACE(REPLACE(B.FIN_PERMIT_NO,CHR(10),''),CHR(13),'')      AS JRXKZH,      --金融许可证号
           REPLACE(REPLACE(B.ORG_ID,CHR(10),''),CHR(13),'')             AS NBJGH,       --内部机构号
           REPLACE(REPLACE(A.TRF_CONT_ID,CHR(10),''),CHR(13),'')        AS ZRHTH,       --转让合同号
           CASE WHEN A.LOAN_BIZ_TYP = '001' THEN '个人贷款'
                WHEN A.LOAN_BIZ_TYP = '002' THEN '对公贷款'
            END                                                         AS XDZCLX,      --信贷资产类型
           REPLACE(REPLACE(A.RCPT_ID,CHR(10),''),CHR(13),'')            AS XDJJH,       --信贷借据号
           A.TRF_LOAN_PRIN                                              AS ZRDKBJ,      --转让贷款本金
           A.TRF_LOAN_INT                                               AS ZRDKLX,      --转让贷款利息
           ''                                                           AS BBZ,         --备注
           V_LAST_DAT                                                   AS CJRQ,        --采集日期
           '000'                                                        AS DEPT_NO,     --部门编号
           '01'                                                         AS SRC_SYS_ID,  --来源系统ID
           '000000'                                                     AS ISSUED_NO,   --填报机构
           CASE WHEN ORG.ORG_ID_LEL_0 IS NOT NULL THEN ORG.ORG_ID_LEL_0
                ELSE '000000'
            END                                                         AS ORG_NO,      --报送机构 --XIEYUGENG
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                         AS ADDRESS,     --归属地
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                                         AS GSFZJG,      --归属分支机构
           CASE WHEN A.TRF_CONT_ID LIKE '%网商贷债权直转%' THEN '转入'
                ELSE CODE.TAR_VALUE_NAME
            END                                                         AS ZCZRFX       --资产转让方向 --ADD BY LIP 20240204
      FROM RRP_MDL.M_LOAN_TRF_REL_INFO A --资产转让关系信息
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(M.ORG_ID1,'800')
       AND B.DATA_DT = V_P_DATE
      --LEFT JOIN RRP_MDL.M_LOAN_TRF_INFO C --信贷资产转让信息
      LEFT JOIN RRP_MDL.M_LOAN_TRF_INFO_CT C --信贷资产转让信息_合同汇总维度 --MOD BY LIP 20251211
        ON C.TRF_CONT_ID = A.TRF_CONT_ID
       --AND NVL(C.PROP_ID,' ') = NVL(A.PROP_ID,' ') --ADD BY LIP 20251205 因对公资产转让和零售单笔单批转让合同号会有相同，增加方案编号关联逻辑
       AND C.TRF_CONT_ID NOT IN ('GYDY08（信托）2021第001号—01','YCXTJG-HX-XT01','YCXT-HXPH1H-XTHT')
       --AND C.CNTPR_TRF_END_DT >= SUBSTR(V_P_DATE,1,6)||'01'
       AND (NVL(C.CNTPR_TRF_END_DT,'99991231') >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD')
           OR NVL(C.ASSET_TRAN_DT,'99991231') >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD')) --MOD BY LIP 20251216 当月内转让的也需要报送
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = C.TRF_DRC
       AND CODE.SRC_CLASS_CODE = 'D0132' --资产转让方向
       AND CODE.TAR_CLASS_CODE = 'D0132' --资产转让方向
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = B.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE (C.TRF_CONT_ID IS NOT NULL
           OR (A.DATA_SRC = '网商贷债权直转' AND A.ASSET_TRAN_DT >= SUBSTR(V_P_DATE,1,6)||'01'))--根据转让日期过滤历史已转让数据
       AND A.DATA_DT = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --判断数据是否重复
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '判断数据是否重复';
    V_STARTTIME := SYSDATE;
      WITH TMP1 AS (
    SELECT CJRQ,XDJJH,COUNT(1)
      FROM RRP_EAST.EAST5_704_ZCZRGXB T
     WHERE CJRQ = V_P_DATE
     GROUP BY CJRQ,XDJJH
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_SQLMSG  := 'EAST5_704_ZCZRGXB(CJRQ,XDJJH)数据重复';
       ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_COUNT,O_ERRCODE,V_SQLMSG);
       RETURN;
    END IF;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_COUNT,O_ERRCODE,'');

    --表分析
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '表分析开始';
    V_STARTTIME := SYSDATE;
    RRP_EAST.ETL_DBMS_STATS(V_P_DATE,V_TABLE_NAME,V_PARTITION_NAME,O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
  END IF;

  --在过程跑批完成记录表中插入记录，调度查询该表判断过程是是否跑批完成
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '跑批结束';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

EXCEPTION
  WHEN OTHERS THEN
    O_ERRCODE := '1';
    V_SQLMSG  := '跑批错误：['||SQLCODE||'],描述信息：'||SQLERRM;
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_EAST5_704_ZCZRGXB;
/

