CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_1002_JRGJXXB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /***********************************************************************
  **  存储过程详细说明：金融工具信息表
  **  存储过程名称:  ETL_EAST5_1002_JRGJXXB
  **  存储过程创建日期:2022-03-07
  **  存储过程创建人:蔡正伟
  **  调用方法:
       DECLARE
         I_P_DATE INTEGER := '20220101';
         O_ERRCODE VARCHAR2(5);
       BEGIN
         ETL_EAST5_1002_JRGJXXB(I_P_DATE, O_ERRCODE);
       END;
  **  输入参数:   I_P_DATE
  **  输出参数:   O_ERRCODE
  **  返回值:     O_ERRCODE
  **  修改日期      修改人       修改原因
  **  20220714      LHQ          根据源系统口径修改逻辑
  **  20220805      LIP          核对逻辑，调整过程格式
  **  20220819      LIP          增加数据来源描述
  **  20220909      LIP          增加委托同业代付数据
  ************************************************************************/
IS
  V_P_DATE             VARCHAR2(8);              --数据日期
  V_PARTITION_NAME     VARCHAR2(100);            --分区名称
  V_FREQ_FLAG          VARCHAR2(10);             --跑批频度
  V_STEP_DESC          VARCHAR2(2000);           --分步日志ID
  V_STEP               INTEGER := 0;             --处理步骤
  V_SQLCOUNT           INTEGER := 0;             --数据记录条数
  V_STARTTIME          DATE := SYSDATE;          --处理开始时间
  V_ENDTIME            DATE := SYSDATE;          --处理结束时间
  V_SQLMSG             VARCHAR2(300);            --SQL执行描述信息
  V_MONTH_START_DATEID VARCHAR2(10);             --本月初日期
  V_MONTH_END_DATEID   VARCHAR2(8);              --本月月底日期
  V_PROC_NAME          VARCHAR2(100):= UPPER('ETL_EAST5_1002_JRGJXXB'); --存储过程名称
  V_TABLE_NAME         VARCHAR2(100):= UPPER('EAST5_1002_JRGJXXB'); --表名称
BEGIN
  V_P_DATE := TO_CHAR(I_P_DATE);
  O_ERRCODE := '0';
  V_MONTH_END_DATEID   := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD');
  V_PARTITION_NAME     := 'PARTITION_' || V_P_DATE;
  V_FREQ_FLAG          := RRP_EAST.FUN_FREQ(I_P_DATE,V_PROC_NAME);
  V_MONTH_START_DATEID := TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD');

  --判断跑批频度
  IF V_FREQ_FLAG = '1' THEN

    V_STEP      := 1;
    V_STEP_DESC := '程序加工开始';
    V_STARTTIME := SYSDATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP      := V_STEP + 1;
    V_STEP_DESC := '删除当日数据';
    V_STARTTIME := SYSDATE;
    --删除当日分区数据
    RRP_EAST.ETL_PARTITION_ADD(V_MONTH_END_DATEID, V_TABLE_NAME, 1, O_ERRCODE);
    RRP_EAST.ETL_PARTITION_TRUNCATE(V_MONTH_END_DATEID, V_TABLE_NAME, O_ERRCODE);
    EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_EAST.EAST5_1002_JRGJXXB_ZJ';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_EAST.EAST5_1002_JRGJXXB_TY';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_EAST.EAST5_1002_JRGJXXB_ZJ_R';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_EAST.EAST5_1002_JRGJXXB_TY_R';

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP      := V_STEP + 1;
    V_STEP_DESC := '金融工具信息表_本币买断式回购';
    V_STARTTIME := SYSDATE;
    --金融工具信息表_本币买断式回购 --现有逻辑
    INSERT INTO RRP_EAST.EAST5_1002_JRGJXXB_ZJ
      (JRXKZH --金融许可证号
      ,NBJGH --内部机构号
      ,YHJGMC --银行机构名称
      ,JRGJBH --金融工具编号
      ,JRGJMC --金融工具名称
      ,ZCLX --资产类型
      ,BZ --币种
      ,FXJG --发行价格
      ,FXZGM --发行总规模
      ,FXJGMC --发行机构名称
      ,ECIF_CODE --ECIF客户号
      ,FXJGDM --发行机构代码
      ,FXGB --发行国别
      ,FXRQ --发行日期
      ,DQRQ --到期日期
      ,LLLX --利率类型
      ,SJLL --实际利率
      ,HQBS --含权标识
      ,ZJPGJG --最近评估价格
      ,PGJGRQ --最近评估日期
      ,JCZCBH --基础资产编号
      ,JCZCMC --基础资产名称
      ,JCZCGM --基础资产规模
      ,JCZCZB --基础资产占比
      ,JCZCPJ --基础资产评级
      ,JCZCPJJG --基础资产评级机构
      ,JCZCKHMC --基础资产客户名称
      ,JCZCKHGJ --基础资产客户国家
      ,JCZCKHPJ --基础资产客户评级
      ,JCKHPJJG --基础资产客户评级机构
      ,JCZCHKHHY --基础资产客户行业
      ,ZZTXLX --最终投向类型
      ,ZZTXHY --最终投向行业
      ,BZH --备注
      ,CJRQ --采集日期
      ,DATA_SRC_DESC --数据来源中文
       )
      WITH DATA_BASE AS (
    SELECT BA.*, KF.CONTROLFACTOR
      FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_KEEPFOLDER KF
        ON KF.KEEPFOLDER_ID = BA.KEEPFOLDER_ID
     WHERE BA.BALANCE_ID IN
           (SELECT MAX(BA1.BALANCE_ID)
              FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA1
             WHERE BA1.SETTLEDATE <= V_MONTH_END_DATEID
               AND BA1.ASSETTYPE = '买断式回购'
               AND BA1.MINORASSETCODE = BA1.MAJORASSETCODE
               AND NVL(BA1.BARETRADENAME,'-') <> 'CARRYOVERDEALS'
             GROUP BY BA1.ASPCLIENT_ID,
                      BA1.KEEPFOLDER_ID,
                      BA1.ASSETTYPE,
                      BA1.BUZTYPE,
                      BA1.MINORASSETCODE,
                      BA1.MAJORASSETCODE)
       AND (BA.HOLDPOSITION <> 0 OR BA.SETTLEDATE >= V_MONTH_START_DATEID)),
      LAST_BALANCE AS (
    SELECT BA.*
      FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA
     WHERE BA.BALANCE_ID IN
           (SELECT MAX(BA1.BALANCE_ID)
              FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA1
             WHERE BA1.SETTLEDATE <= TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH_END_DATEID,'YYYYMMDD'), -1),'YYYYMMDD')
               AND BA1.ASSETTYPE = '买断式回购'
               AND BA1.MINORASSETCODE = BA1.MAJORASSETCODE
             GROUP BY BA1.ASPCLIENT_ID,
                      BA1.KEEPFOLDER_ID,
                      BA1.ASSETTYPE,
                      BA1.BUZTYPE,
                      BA1.MINORASSETCODE,
                      BA1.MAJORASSETCODE))
    SELECT 'B1194H244050001'                                         AS JRXKZH --金融许可证号
          ,M.DEPARTMENTID                                            AS NBJGH --内部机构号
          ,'广东华兴银行股份有限公司总行'                            AS YXJGMC --银行机构名称
          ,T2.CPTYS_ID || '_' || T2.SERIAL_NUMBER                    AS JRGJBH --金融工具编号
          ,T2.CPTYS_SHORT_NAME || '_' || DECODE(T2.BUYORSELL,'B','买断式正回购','买断式逆回购') AS JRGJMC --金融工具名称
          ,'其他-' || DECODE(T2.BUYORSELL,'B','买断式正回购','买断式逆回购') AS ZCLX --资产类型
          ,'CNY'                                                     AS BZ --币种
          ,0                                                         AS FXJG --发行价格
          ,NVL(T4.HOLDPOSITION, 0)                                   AS FXZGM --发行总规模
          ,T3.CPTYS_NAME                                             AS FXJGMC --发行机构名称
          ,T3.LABEL                                                  AS ECIF_CODE --ECIF客户号
          ,NULL                                                      AS FXJGDM --发行机构代码
          ,'CHN'                                                     AS FXGB --发行国别
          ,TRIM(T2.TRADE_DATE)                                       AS FXRQ --发行日期
          ,TRIM(T2.MATURITY_DATE)                                    AS DQRQ --到期日期
          ,'非LPR'                                                   AS LLLX --利率类型
          ,T2.REPO_RATE                                              AS SJLL --实际利率
          ,'否'                                                      AS HQBS --含权标识
          ,T1.HOLDPOSITION                                           AS ZJPGJG --最近评估价格
          ,'99991231'                                                AS PGJGRQ --最近评估日期
          ,NULL                                                      AS JCZCBH --基础资产编号
          ,NULL                                                      AS JCZCMC --基础资产名称
          ,NULL                                                      AS JCZCGM --基础资产规模
          ,NULL                                                      AS JCZCZB --基础资产占比
          ,NULL                                                      AS JCZCPJ --基础资产评级
          ,NULL                                                      AS JCZCPJJG --基础资产评级机构
          ,NULL                                                      AS JCZCKHMC --基础资产客户名称
          ,NULL                                                      AS JCZCKHGJ --基础资产客户国家
          ,NULL                                                      AS JCZCKHPJ --基础资产客户评级
          ,NULL                                                      AS JCZCKHPJJG --基础资产客户评级机构
          ,NULL                                                      AS JCZCHKHHY --基础资产客户行业
          ,NULL                                                      AS ZZTXLX --最终投向类型
          ,NULL                                                      AS ZZTXHY --最终投向行业
          ,NULL                                                      AS BBZ --备注
          ,V_MONTH_END_DATEID                                        AS CJRQ --采集日期
          ,'本币买断式回购'                                          AS DATA_SRC_DESC --数据来源中文
      FROM DATA_BASE T1
      --FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE T1
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_V_REPODEALS T2
        ON T2.DEAL_ID = SUBSTR(T1.MINORASSETCODE,4)
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_CPTYS T3
        ON T3.KEY_SRC = T2.CPTYS_ID
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_INTERFACE_PORTF_DEPART_MAPPING M
        ON M.KEEPFOLDER_ID = T2.KEEPFOLDER_ID
      LEFT JOIN LAST_BALANCE T4
        ON T4.ASSETTYPE = T1.ASSETTYPE
       AND T4.BUZTYPE = T1.BUZTYPE
       AND T4.MINORASSETCODE = T1.MINORASSETCODE
       AND T4.MAJORASSETCODE = T1.MAJORASSETCODE
       AND T4.KEEPFOLDER_ID = T1.KEEPFOLDER_ID
     WHERE T1.ASSETTYPE = '买断式回购';

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP      := V_STEP + 1;
    V_STEP_DESC := '金融工具信息表_本币同业拆借';
    V_STARTTIME := SYSDATE;
    --金融工具信息表_本币同业拆借  --B层逻辑
    INSERT INTO RRP_EAST.EAST5_1002_JRGJXXB_ZJ
      (JRXKZH --金融许可证号
      ,NBJGH --内部机构号
      ,YHJGMC --银行机构名称
      ,JRGJBH --金融工具编号
      ,JRGJMC --金融工具名称
      ,ZCLX --资产类型
      ,BZ --币种
      ,FXJG --发行价格
      ,FXZGM --发行总规模
      ,FXJGMC --发行机构名称
      ,ECIF_CODE --ECIF客户号
      ,FXJGDM --发行机构代码
      ,FXGB --发行国别
      ,FXRQ --发行日期
      ,DQRQ --到期日期
      ,LLLX --利率类型
      ,SJLL --实际利率
      ,HQBS --含权标识
      ,ZJPGJG --最近评估价格
      ,PGJGRQ --最近评估日期
      ,JCZCBH --基础资产编号
      ,JCZCMC --基础资产名称
      ,JCZCGM --基础资产规模
      ,JCZCZB --基础资产占比
      ,JCZCPJ --基础资产评级
      ,JCZCPJJG --基础资产评级机构
      ,JCZCKHMC --基础资产客户名称
      ,JCZCKHGJ --基础资产客户国家
      ,JCZCKHPJ --基础资产客户评级
      ,JCKHPJJG --基础资产客户评级机构
      ,JCZCHKHHY --基础资产客户行业
      ,ZZTXLX --最终投向类型
      ,ZZTXHY --最终投向行业
      ,BZH --备注
      ,CJRQ --采集日期
      ,DATA_SRC_DESC --数据来源中文
       )
      WITH DATA_BASE AS (
    SELECT BA.*, KF.CONTROLFACTOR
      FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_KEEPFOLDER KF
        ON KF.KEEPFOLDER_ID = BA.KEEPFOLDER_ID
     WHERE BA.BALANCE_ID IN
           (SELECT MAX(BA1.BALANCE_ID)
              FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA1
             WHERE BA1.SETTLEDATE <= V_MONTH_END_DATEID
               AND BA1.ASSETTYPE = '拆借'
               AND BA1.MINORASSETCODE = BA1.MAJORASSETCODE
               AND NVL(BA1.BARETRADENAME,'-') <> 'CARRYOVERDEALS'
             GROUP BY BA1.ASPCLIENT_ID,
                      BA1.KEEPFOLDER_ID,
                      BA1.ASSETTYPE,
                      BA1.BUZTYPE,
                      BA1.MINORASSETCODE,
                      BA1.MAJORASSETCODE)
       AND (BA.HOLDPOSITION <> 0 OR BA.SETTLEDATE >= V_MONTH_START_DATEID)),
      LAST_BALANCE AS (
    SELECT BA.*
      FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA
     WHERE BA.BALANCE_ID IN
           (SELECT MAX(BA1.BALANCE_ID)
              FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA1
             WHERE BA1.SETTLEDATE <= TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH_END_DATEID,'YYYYMMDD'),-1),'YYYYMMDD')
               AND BA1.ASSETTYPE = '拆借'
               AND BA1.MINORASSETCODE = BA1.MAJORASSETCODE
             GROUP BY BA1.ASPCLIENT_ID,
                      BA1.KEEPFOLDER_ID,
                      BA1.ASSETTYPE,
                      BA1.BUZTYPE,
                      BA1.MINORASSETCODE,
                      BA1.MAJORASSETCODE))
    SELECT 'B1194H244050001'                                          AS JRXKZH --金融许可证号
           ,M.DEPARTMENTID                                            AS NBJGH --内部机构号
           ,'广东华兴银行股份有限公司总行'                            AS YXJGMC --银行机构名称
           ,T2.CPTYS_ID || '_' || T2.SERIAL_NUMBER                    AS JRGJBH --金融工具编号
           ,T2.CPTYS_SHORT_NAME || '_' ||DECODE(T2.BUYORSELL,'B','同业拆入','拆放同业') AS JRGJMC --金融工具名称
           ,'其他-' || DECODE(T2.BUYORSELL,'B','同业拆入','同业拆出') AS ZCLX --资产类型
           ,'CNY'                                                     AS BZ --币种
           ,0                                                         AS FXJG --发行价格
           ,NVL(T4.HOLDPOSITION, 0)                                   AS FXZGM --发行总规模
           ,T3.CPTYS_NAME                                             AS FXJGMC --发行机构名称
           ,T3.LABEL                                                  AS ECIF_CODE --ecif客户号
           ,NULL                                                      AS FXJGDM --发行机构代码
           ,'CHN'                                                     AS FXGB --发行国别
           ,TRIM(T2.TRADE_DATE)                                       AS FXRQ --发行日期
           ,TRIM(T2.MATURITY_DATE)                                    AS DQRQ --到期日期
           ,'非LPR'                                                   AS LLLX --利率类型
           ,T2.REPO_RATE                                              AS SJLL --实际利率
           ,'否'                                                      AS HQBS --含权标识
           ,T1.HOLDPOSITION                                           AS ZJPGJG --最近评估价格
           ,'99991231'                                                AS PGJGRQ --最近评估日期
           ,NULL                                                      AS JCZCBH --基础资产编号
           ,NULL                                                      AS JCZCMC --基础资产名称
           ,NULL                                                      AS JCZCGM --基础资产规模
           ,NULL                                                      AS JCZCZB --基础资产占比
           ,NULL                                                      AS JCZCPJ --基础资产评级
           ,NULL                                                      AS JCZCPJJG --基础资产评级机构
           ,NULL                                                      AS JCZCKHMC --基础资产客户名称
           ,NULL                                                      AS JCZCKHGJ --基础资产客户国家
           ,NULL                                                      AS JCZCKHPJ --基础资产客户评级
           ,NULL                                                      AS JCZCKHPJJG --基础资产客户评级机构
           ,NULL                                                      AS JCZCHKHHY --基础资产客户行业
           ,NULL                                                      AS ZZTXLX --最终投向类型
           ,NULL                                                      AS ZZTXHY --最终投向行业
           ,NULL                                                      AS BBZ --备注
           ,V_MONTH_END_DATEID                                        AS CJRQ --采集日期
           ,'本币同业拆借'                                            AS DATA_SRC_DESC --数据来源中文
      FROM DATA_BASE T1
      --FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE T1
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_V_IAMDEALS T2
        ON T2.DEAL_ID = SUBSTR(T1.MINORASSETCODE,4)
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_CPTYS T3
        ON T3.KEY_SRC = T2.CPTYS_ID
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_INTERFACE_PORTF_DEPART_MAPPING M
        ON M.KEEPFOLDER_ID = T2.KEEPFOLDER_ID
      LEFT JOIN LAST_BALANCE T4
        ON T4.ASSETTYPE = T1.ASSETTYPE
       AND T4.BUZTYPE = T1.BUZTYPE
       AND T4.MINORASSETCODE = T1.MINORASSETCODE
       AND T4.MAJORASSETCODE = T1.MAJORASSETCODE
       AND T4.KEEPFOLDER_ID = T1.KEEPFOLDER_ID
     WHERE T1.ASSETTYPE = '拆借';

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP      := V_STEP + 1;
    V_STEP_DESC := '金融工具信息表_本币债券发行';
    V_STARTTIME := SYSDATE;
    --金融工具信息表_本币债券发行 --B层逻辑
    INSERT INTO RRP_EAST.EAST5_1002_JRGJXXB_ZJ
      (JRXKZH --金融许可证号
      ,NBJGH --内部机构号
      ,YHJGMC --银行机构名称
      ,JRGJBH --金融工具编号
      ,JRGJMC --金融工具名称
      ,ZCLX --资产类型
      ,BZ --币种
      ,FXJG --发行价格
      ,FXZGM --发行总规模
      ,FXJGMC --发行机构名称
      ,ECIF_CODE --ECIF客户号
      ,FXJGDM --发行机构代码
      ,FXGB --发行国别
      ,FXRQ --发行日期
      ,DQRQ --到期日期
      ,LLLX --利率类型
      ,SJLL --实际利率
      ,HQBS --含权标识
      ,ZJPGJG --最近评估价格
      ,PGJGRQ --最近评估日期
      ,JCZCBH --基础资产编号
      ,JCZCMC --基础资产名称
      ,JCZCGM --基础资产规模
      ,JCZCZB --基础资产占比
      ,JCZCPJ --基础资产评级
      ,JCZCPJJG --基础资产评级机构
      ,JCZCKHMC --基础资产客户名称
      ,JCZCKHGJ --基础资产客户国家
      ,JCZCKHPJ --基础资产客户评级
      ,JCKHPJJG --基础资产客户评级机构
      ,JCZCHKHHY --基础资产客户行业
      ,ZZTXLX --最终投向类型
      ,ZZTXHY --最终投向行业
      ,BZH --备注
      ,CJRQ --采集日期
      ,DATA_SRC_DESC --数据来源中文
       )
      WITH DATA_BASE AS (
    SELECT BA.*, KF.CONTROLFACTOR
      FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_KEEPFOLDER KF
        ON KF.KEEPFOLDER_ID = BA.KEEPFOLDER_ID
     WHERE BA.BALANCE_ID IN
           (SELECT MAX(BA1.BALANCE_ID)
              FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA1
             WHERE BA1.SETTLEDATE <= V_MONTH_END_DATEID
               AND BA1.ASSETTYPE = '债券发行'
               AND BA1.MAJORASSETCODE = BA1.MINORASSETCODE
               AND NVL(BA1.BARETRADENAME,'-') <> 'CARRYOVERDEALS'
             GROUP BY BA1.ASPCLIENT_ID,
                      BA1.KEEPFOLDER_ID,
                      BA1.ASSETTYPE,
                      BA1.BUZTYPE,
                      BA1.MINORASSETCODE,
                      BA1.MAJORASSETCODE)
       AND (BA.HOLDPOSITION <> 0 OR BA.SETTLEDATE >= V_MONTH_START_DATEID)),
      ISSUER_RATING_BASE AS (
    SELECT ISSUER_ID,
           MAX(RATING_DATE) AS RATING_DATE,
           MAX(FIRM_ID) KEEP(DENSE_RANK FIRST ORDER BY RATING_DATE DESC) AS FIRM_ID
      FROM RRP_MDL.O_IOL_CTMS_TBS_V_ISSUER_RATING
     GROUP BY ISSUER_ID),
      DS_ISSUER_RATING AS (
    SELECT DISTINCT T.ISSUER_ID,
           T.FIRM_ID,
           T.RATING,
           T.RATING_DATE,
           T.ISSUER_NAME_ZH,
           T.ISSUER_NAME_EN,
           T.RATING_CATEGORY,
           TRIM(FR.FIRM_NAME_ZH) AS FIRM_NAME_ZH
      FROM RRP_MDL.O_IOL_CTMS_TBS_V_ISSUER_RATING T,
           ISSUER_RATING_BASE                     B,
           RRP_MDL.O_IOL_CTMS_TBS_V_RATING_FIRM   FR
     WHERE T.ISSUER_ID = B.ISSUER_ID
       AND T.RATING_DATE = B.RATING_DATE
       AND T.FIRM_ID = B.FIRM_ID
       AND T.FIRM_ID = FR.FIRM_ID),
      SECURITY_RATING_BASE AS (
    SELECT SECURITY_CODE,
           MAX(RATING_DATE) AS RATING_DATE,
           MAX(FIRM_ID) KEEP(DENSE_RANK FIRST ORDER BY RATING_DATE DESC) AS FIRM_ID
      FROM RRP_MDL.O_IOL_CTMS_TBS_V_SECURITY_RATING
     GROUP BY SECURITY_CODE),
      DS_SECURITY_RATING AS (
    SELECT DISTINCT TRIM(T.SECURITY_CODE) AS SECURITY_CODE,
           TRIM(T.FIRM_ID) AS FIRM_ID,
           TRIM(T.RATING) AS RATING,
           T.RATING_DATE,
           TRIM(FR.FIRM_NAME_ZH) AS FIRM_NAME_ZH
      FROM RRP_MDL.O_IOL_CTMS_TBS_V_SECURITY_RATING T,
           SECURITY_RATING_BASE                     B,
           RRP_MDL.O_IOL_CTMS_TBS_V_RATING_FIRM     FR
     WHERE T.SECURITY_CODE = B.SECURITY_CODE
       AND T.RATING_DATE = B.RATING_DATE
       AND T.FIRM_ID = B.FIRM_ID
       AND T.FIRM_ID = FR.FIRM_NAME_ZH)
    SELECT 'B1194H244050001'                                        AS JRXKZH --金融许可证号
           ,M.DEPARTMENTID                                           AS NBJGH --内部机构号
           ,'广东华兴银行股份有限公司总行'                           AS YXJGMC --银行机构名称
           ,NVL(T5.EXTRA_CODE, T2.SECURITY_CODE)                     AS JRGJBH --金融工具编号
           ,T2.SECURITY_NAME                                         AS JRGJMC --金融工具名称
           ,'其他-债券发行'                                          AS ZCLX --资产类型
           ,T2.CCY                                                   AS BZ --币种
           ,T2.AUTION_PRICE                                          AS FXJG --发行价格
           ,T2.NUMBER_ISSUED * 100000000                             AS FXZGM --发行总规模
           ,T2.ISSUER                                                AS FXJGMC --发行机构名称
           ,''                                                       AS ECIF_CODE--ECIF客户号
           ,'91440500279832882U'                                     AS FXJGDM --发行机构代码
           ,'CHN'                                                    AS FXGB --发行国别
           ,TRIM(T2.ISSUE_DATE)                                      AS FXRQ --发行日期
           ,TRIM(T2.MATURITY_DATE)                                   AS DQRQ --到期日期
           ,'非LPR'                                                  AS LLLX --利率类型
           ,NVL(T2.FIXED_RATE, T2.AUTION_RATE)                       AS SJLL --实际利率
           ,DECODE(T2.OPTION_TYPE,'0','否','是')                  AS HQBS --含权标识
           ,T1.HOLDFACEAMOUNT + T1.INTERESTADJUST                    AS ZJPGJG --最近评估价格
           ,T1.SETTLEDATE                                            AS PGJGRQ --最近评估日期
           ,NVL(T5.EXTRA_CODE, T1.MAJORASSETCODE)                    AS JCZCBH --基础资产编号
           ,T2.SECURITY_NAME                                         AS JCZCMC --基础资产名称
           ,T1.HOLDPOSITION                                          AS JCZCGM --基础资产规模
           ,T1.HOLDPOSITION / T2.NUMBER_ISSUED / 1000000             AS JCZCZB --基础资产占比
           ,SR.RATING                                                AS JCZCPJ --基础资产评级
           ,TRIM(SR.FIRM_NAME_ZH)                                    AS JCZCPJJG --基础资产评级机构
           ,T2.ISSUER                                                AS JCZCKHMC --基础资产客户名称
           ,'CHN'                                                    AS JCZCKHGJ --基础资产客户国家
           ,DIR.RATING                                               AS JCZCKHPJ --基础资产客户评级
           ,TRIM(DIR.FIRM_NAME_ZH)                                   AS JCZCKHPJJG --基础资产客户评级机构
           ,NULL                                                     AS JCZCHKHHY --基础资产客户行业
           ,NULL                                                     AS ZZTXLX --最终投向类型
           ,NULL                                                     AS ZZTXHY --最终投向行业
           ,NULL                                                     AS BBZ --备注
           ,V_MONTH_END_DATEID                                       AS CJRQ --采集日期
           ,'本币债券发行'                                           AS DATA_SRC_DESC --数据来源中文
      FROM DATA_BASE T1
      --FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE T1
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_V_SECURITY T2
        ON T2.SECURITY_CODE = T1.MAJORASSETCODE
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_ISSUER IR
        ON IR.ISSUER_NAME_ZH = T2.ISSUER
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_INTERFACE_PORTF_DEPART_MAPPING M
        ON M.KEEPFOLDER_ID = T1.KEEPFOLDER_ID
      LEFT JOIN RRP_MDL.O_IOL_CTMS_TBS_SECURITY_EXTRA_CODE T5
        ON T5.SECURITY_CODE = T1.MAJORASSETCODE
      LEFT JOIN DS_SECURITY_RATING SR
        ON SR.SECURITY_CODE = T2.SECURITY_CODE
      LEFT JOIN DS_ISSUER_RATING DIR
        ON DIR.ISSUER_ID = IR.ISSUER_ID
     WHERE T1.BUZTYPE = '债券发行';

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP      := V_STEP + 1;
    V_STEP_DESC := '金融工具信息表_本币债券借贷';
    V_STARTTIME := SYSDATE;
    --金融工具信息表_本币债券借贷
    INSERT INTO RRP_EAST.EAST5_1002_JRGJXXB_ZJ
      (JRXKZH --金融许可证号
      ,NBJGH --内部机构号
      ,YHJGMC --银行机构名称
      ,JRGJBH --金融工具编号
      ,JRGJMC --金融工具名称
      ,ZCLX --资产类型
      ,BZ --币种
      ,FXJG --发行价格
      ,FXZGM --发行总规模
      ,FXJGMC --发行机构名称
      ,ECIF_CODE --ECIF客户号
      ,FXJGDM --发行机构代码
      ,FXGB --发行国别
      ,FXRQ --发行日期
      ,DQRQ --到期日期
      ,LLLX --利率类型
      ,SJLL --实际利率
      ,HQBS --含权标识
      ,ZJPGJG --最近评估价格
      ,PGJGRQ --最近评估日期
      ,JCZCBH --基础资产编号
      ,JCZCMC --基础资产名称
      ,JCZCGM --基础资产规模
      ,JCZCZB --基础资产占比
      ,JCZCPJ --基础资产评级
      ,JCZCPJJG --基础资产评级机构
      ,JCZCKHMC --基础资产客户名称
      ,JCZCKHGJ --基础资产客户国家
      ,JCZCKHPJ --基础资产客户评级
      ,JCKHPJJG --基础资产客户评级机构
      ,JCZCHKHHY --基础资产客户行业
      ,ZZTXLX --最终投向类型
      ,ZZTXHY --最终投向行业
      ,BZH --备注
      ,CJRQ --采集日期
      ,DATA_SRC_DESC --数据来源中文
       )
      WITH DATA_BASE AS (
    SELECT BA.*, KF.CONTROLFACTOR
      FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_KEEPFOLDER KF
        ON KF.KEEPFOLDER_ID = BA.KEEPFOLDER_ID
     WHERE BA.BALANCE_ID IN
           (SELECT MAX(BA1.BALANCE_ID)
              FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA1
             WHERE BA1.SETTLEDATE <= V_MONTH_END_DATEID
               AND BA1.ASSETTYPE = '债券借贷'
               AND NVL(BA1.BARETRADENAME,'-') <> 'CARRYOVERDEALS'
             GROUP BY BA1.ASPCLIENT_ID,
                      BA1.KEEPFOLDER_ID,
                      BA1.ASSETTYPE,
                      BA1.BUZTYPE,
                      BA1.MINORASSETCODE,
                      BA1.MAJORASSETCODE)
       AND (BA.HOLDPOSITION <> 0 OR BA.SETTLEDATE >= V_MONTH_START_DATEID)),
      LAST_BALANCE AS (
    SELECT BA.*
      FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA
     WHERE BA.BALANCE_ID IN
           (SELECT MAX(BA1.BALANCE_ID)
              FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA1
             WHERE BA1.SETTLEDATE <= TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH_END_DATEID,'YYYYMMDD'), -1),'YYYYMMDD')
               AND BA1.ASSETTYPE = '债券借贷'
             GROUP BY BA1.ASPCLIENT_ID,
                      BA1.KEEPFOLDER_ID,
                      BA1.ASSETTYPE,
                      BA1.BUZTYPE,
                      BA1.MINORASSETCODE,
                      BA1.MAJORASSETCODE))
    SELECT 'B1194H244050001'                                          AS JRXKZH --金融许可证号
           ,M.DEPARTMENTID                                            AS NBJGH --内部机构号
           ,'广东华兴银行股份有限公司总行'                            AS YXJGMC --银行机构名称
           ,T2.CPTYS_ID || '_' || T2.SERIAL_NUMBER                    AS JRGJBH --金融工具编号
           ,T2.CPTYS_SHORT_NAME || '_' || DECODE(T2.BUYORSELL,'B','债券借入','债券借出') AS JRGJMC --金融工具名称
           ,'其他-' || DECODE(T2.BUYORSELL,'B','债券借入','债券借出') AS ZCLX --资产类型
           ,'CNY'                                                     AS BZ --币种
           ,0                                                         AS FXJG --发行价格
           ,NVL(T4.HOLDPOSITION, 0)                                   AS FXZGM --发行总规模
           ,T3.CPTYS_NAME                                             AS FXJGMC --发行机构名称
           ,T3.LABEL                                                  AS ECIF_CODE --ECIF客户号
           ,NULL                                                      AS FXJGDM --发行机构代码
           ,'CHN'                                                     AS FXGB --发行国别
           ,TRIM(T2.TRADE_DATE)                                       AS FXRQ --发行日期
           ,TRIM(T2.MATURITY_DATE)                                    AS DQRQ --到期日期
           ,'非LPR'                                                   AS LLLX --利率类型
           ,T2.TRADE_RATE                                             AS SJLL --实际利率
           ,'否'                                                      AS HQBS --含权标识
           ,T1.HOLDPOSITION                                           AS ZJPGJG --最近评估价格
           ,'99991231'                                                AS PGJGRQ --最近评估日期
           ,NULL                                                      AS JCZCBH --基础资产编号
           ,NULL                                                      AS JCZCMC --基础资产名称
           ,NULL                                                      AS JCZCGM --基础资产规模
           ,NULL                                                      AS JCZCZB --基础资产占比
           ,NULL                                                      AS JCZCPJ --基础资产评级
           ,NULL                                                      AS JCZCPJJG --基础资产评级机构
           ,NULL                                                      AS JCZCKHMC --基础资产客户名称
           ,NULL                                                      AS JCZCKHGJ --基础资产客户国家
           ,NULL                                                      AS JCZCKHPJ --基础资产客户评级
           ,NULL                                                      AS JCZCKHPJJG --基础资产客户评级机构
           ,NULL                                                      AS JCZCHKHHY --基础资产客户行业
           ,NULL                                                      AS ZZTXLX --最终投向类型
           ,NULL                                                      AS ZZTXHY --最终投向行业
           ,NULL                                                      AS BBZ --备注
           ,V_MONTH_END_DATEID                                        AS CJRQ --采集日期
           ,'本币债券借贷'                                            AS DATA_SRC_DESC --数据来源中文
      FROM DATA_BASE T1
      --FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE T1
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_V_WTRADE_LEND T2
        --ON T2.DEAL_ID = SUBSTR(T1.MINORASSETCODE,4)
        --MOD BY LIP 20240415 根据资金反馈的逻辑调整关联条件
        ON (T2.DEAL_ID = SUBSTR(T1.MINORASSETCODE,4) OR (T2.WTRADE_LEND_ID_GRAND = SUBSTR(T1.MINORASSETCODE,4) AND T2.STATUS = 'A'))
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_CPTYS T3
        ON T3.KEY_SRC = T2.CPTYS_ID
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_INTERFACE_PORTF_DEPART_MAPPING M
        ON M.KEEPFOLDER_ID = T2.KEEPFOLDER_ID
      LEFT JOIN LAST_BALANCE T4
        ON T4.ASSETTYPE = T1.ASSETTYPE
       AND T4.BUZTYPE = T1.BUZTYPE
       AND T4.MINORASSETCODE = T1.MINORASSETCODE
       AND T4.MAJORASSETCODE = T1.MAJORASSETCODE
       AND T4.KEEPFOLDER_ID = T1.KEEPFOLDER_ID
     WHERE T1.ASSETTYPE = '债券借贷';

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP      := V_STEP + 1;
    V_STEP_DESC := '金融工具信息表_本币质押式回购';
    V_STARTTIME := SYSDATE;
    --金融工具信息表_本币质押式回购
    INSERT INTO RRP_EAST.EAST5_1002_JRGJXXB_ZJ
      (JRXKZH --金融许可证号
      ,NBJGH --内部机构号
      ,YHJGMC --银行机构名称
      ,JRGJBH --金融工具编号
      ,JRGJMC --金融工具名称
      ,ZCLX --资产类型
      ,BZ --币种
      ,FXJG --发行价格
      ,FXZGM --发行总规模
      ,FXJGMC --发行机构名称
      ,ECIF_CODE --ECIF客户号
      ,FXJGDM --发行机构代码
      ,FXGB --发行国别
      ,FXRQ --发行日期
      ,DQRQ --到期日期
      ,LLLX --利率类型
      ,SJLL --实际利率
      ,HQBS --含权标识
      ,ZJPGJG --最近评估价格
      ,PGJGRQ --最近评估日期
      ,JCZCBH --基础资产编号
      ,JCZCMC --基础资产名称
      ,JCZCGM --基础资产规模
      ,JCZCZB --基础资产占比
      ,JCZCPJ --基础资产评级
      ,JCZCPJJG --基础资产评级机构
      ,JCZCKHMC --基础资产客户名称
      ,JCZCKHGJ --基础资产客户国家
      ,JCZCKHPJ --基础资产客户评级
      ,JCKHPJJG --基础资产客户评级机构
      ,JCZCHKHHY --基础资产客户行业
      ,ZZTXLX --最终投向类型
      ,ZZTXHY --最终投向行业
      ,BZH --备注
      ,CJRQ --采集日期
      ,DATA_SRC_DESC --数据来源中文
       )
      WITH DATA_BASE AS (
    SELECT BA.*, KF.CONTROLFACTOR
      FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_KEEPFOLDER KF
        ON KF.KEEPFOLDER_ID = BA.KEEPFOLDER_ID
     WHERE BA.BALANCE_ID IN
           (SELECT MAX(BA1.BALANCE_ID)
              FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA1
             WHERE BA1.SETTLEDATE <= V_MONTH_END_DATEID
               AND BA1.ASSETTYPE = '质押式回购'
               AND BA1.MINORASSETCODE = BA1.MAJORASSETCODE
               AND NVL(BA1.BARETRADENAME,'-') <> 'CARRYOVERDEALS'
             GROUP BY BA1.ASPCLIENT_ID,
                      BA1.KEEPFOLDER_ID,
                      BA1.ASSETTYPE,
                      BA1.BUZTYPE,
                      BA1.MINORASSETCODE,
                      BA1.MAJORASSETCODE)
       AND (BA.HOLDPOSITION <> 0 OR BA.SETTLEDATE >= V_MONTH_START_DATEID)),
      LAST_BALANCE AS (
      SELECT BA.*
        FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA
       WHERE BA.BALANCE_ID IN
             (SELECT MAX(BA1.BALANCE_ID)
                FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA1
               WHERE BA1.SETTLEDATE <= TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH_END_DATEID,'YYYYMMDD'),-1),'YYYYMMDD')
                 AND BA1.ASSETTYPE = '质押式回购'
                 AND BA1.MINORASSETCODE = BA1.MAJORASSETCODE
               GROUP BY BA1.ASPCLIENT_ID,
                        BA1.KEEPFOLDER_ID,
                        BA1.ASSETTYPE,
                        BA1.BUZTYPE,
                        BA1.MINORASSETCODE,
                        BA1.MAJORASSETCODE))
    SELECT 'B1194H244050001'                                          AS JRXKZH -- 金融许可证号
           ,M.DEPARTMENTID                                            AS NBJGH --内部机构号
           ,'广东华兴银行股份有限公司总行'                            AS YXJGMC --银行机构名称
           ,T2.CPTYS_ID || '_' || T2.SERIAL_NUMBER                    AS JRGJBH --金融工具编号
           ,T2.CPTYS_SHORT_NAME || '_' || DECODE(T2.BUYORSELL,'B','质押式正回购','质押式逆回购') AS JRGJMC --金融工具名称
           ,'其他-' || DECODE(T2.BUYORSELL,'B','质押式正回购','质押式逆回购') AS ZCLX --资产类型
           ,'CNY'                                                     AS BZ --币种
           ,0                                                         AS FXJG --发行价格
           ,NVL(T4.HOLDPOSITION, 0)                                   AS FXZGM --发行总规模
           ,T3.CPTYS_NAME                                             AS FXJGMC --发行机构名称
           ,T3.LABEL                                                  AS ECIF_CODE --ECIF客户号
           ,NULL                                                      AS FXJGDM --发行机构代码
           ,'CHN'                                                     AS FXGB --发行国别
           ,TRIM(T2.TRADE_DATE)                                       AS FXRQ --发行日期
           ,TRIM(T2.MATURITY_DATE)                                    AS DQRQ --到期日期
           ,'非LPR'                                                   AS LLLX --利率类型
           ,T2.TRADE_RATE                                             AS SJLL --实际利率
           ,'否'                                                      AS HQBS --含权标识
           ,T1.HOLDPOSITION                                           AS ZJPGJG --最近评估价格
           ,'99991231'                                                AS PGJGRQ --最近评估日期
           ,NULL                                                      AS JCZCBH --基础资产编号
           ,NULL                                                      AS JCZCMC --基础资产名称
           ,NULL                                                      AS JCZCGM --基础资产规模
           ,NULL                                                      AS JCZCZB --基础资产占比
           ,NULL                                                      AS JCZCPJ --基础资产评级
           ,NULL                                                      AS JCZCPJJG --基础资产评级机构
           ,NULL                                                      AS JCZCKHMC --基础资产客户名称
           ,NULL                                                      AS JCZCKHGJ --基础资产客户国家
           ,NULL                                                      AS JCZCKHPJ --基础资产客户评级
           ,NULL                                                      AS JCZCKHPJJG --基础资产客户评级机构
           ,NULL                                                      AS JCZCHKHHY --基础资产客户行业
           ,NULL                                                      AS ZZTXLX --最终投向类型
           ,NULL                                                      AS ZZTXHY --最终投向行业
           ,NULL                                                      AS BBZ --备注
           ,V_MONTH_END_DATEID                                        AS CJRQ --采集日期
           ,'本币质押式回购'                                          AS DATA_SRC_DESC --数据来源中文
      FROM DATA_BASE T1
      --FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE T1
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_V_LDREPODEALS T2
        ON T2.DEAL_ID = SUBSTR(T1.MINORASSETCODE,4)
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_CPTYS T3
        ON T3.KEY_SRC = T2.CPTYS_ID
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_INTERFACE_PORTF_DEPART_MAPPING M
        ON M.KEEPFOLDER_ID = T2.KEEPFOLDER_ID
      LEFT JOIN LAST_BALANCE T4
        ON T4.ASSETTYPE = T1.ASSETTYPE
       AND T4.BUZTYPE = T1.BUZTYPE
       AND T4.MINORASSETCODE = T1.MINORASSETCODE
       AND T4.MAJORASSETCODE = T1.MAJORASSETCODE
       AND T4.KEEPFOLDER_ID = T1.KEEPFOLDER_ID
     WHERE T1.ASSETTYPE = '质押式回购';

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP      := V_STEP + 1;
    V_STEP_DESC := '金融工具信息表_外币拆借/外币回购1';
    V_STARTTIME := SYSDATE;
    --金融工具信息表_外币拆借/外币回购
    INSERT INTO RRP_EAST.EAST5_1002_JRGJXXB_ZJ
      (JRXKZH --金融许可证号
      ,NBJGH --内部机构号
      ,YHJGMC --银行机构名称
      ,JRGJBH --金融工具编号
      ,JRGJMC --金融工具名称
      ,ZCLX --资产类型
      ,BZ --币种
      ,FXJG --发行价格
      ,FXZGM --发行总规模
      ,FXJGMC --发行机构名称
      ,ECIF_CODE --ECIF客户号
      ,FXJGDM --发行机构代码
      ,FXGB --发行国别
      ,FXRQ --发行日期
      ,DQRQ --到期日期
      ,LLLX --利率类型
      ,SJLL --实际利率
      ,HQBS --含权标识
      ,ZJPGJG --最近评估价格
      ,PGJGRQ --最近评估日期
      ,JCZCBH --基础资产编号
      ,JCZCMC --基础资产名称
      ,JCZCGM --基础资产规模
      ,JCZCZB --基础资产占比
      ,JCZCPJ --基础资产评级
      ,JCZCPJJG --基础资产评级机构
      ,JCZCKHMC --基础资产客户名称
      ,JCZCKHGJ --基础资产客户国家
      ,JCZCKHPJ --基础资产客户评级
      ,JCKHPJJG --基础资产客户评级机构
      ,JCZCHKHHY --基础资产客户行业
      ,ZZTXLX --最终投向类型
      ,ZZTXHY --最终投向行业
      ,BZH --备注
      ,CJRQ --采集日期
      ,DATA_SRC_DESC --数据来源中文
       )
      WITH DATA_DATE_RANG AS (
    SELECT V_MONTH_START_DATEID AS BEGIN_DATE,
           V_MONTH_END_DATEID   AS END_DATE,
           V_MONTH_END_DATEID   AS DATA_DATE
      FROM DUAL),
      DATA_BASE AS (
    SELECT BA.*
      FROM RRP_MDL.O_IOL_CTMS_FBS_V_BALANCE BA,DATA_DATE_RANG DDB
     WHERE BA.BALANCE_ID IN
           (SELECT MAX(BA1.BALANCE_ID)
              FROM RRP_MDL.O_IOL_CTMS_FBS_V_BALANCE BA1
             WHERE BA1.SETTLEDATE <= V_MONTH_END_DATEID
               AND BA1.BUZTYPE = '外币拆借/同存'
             GROUP BY BA1.KEEPFOLDER_ID,BA1.ASSETTYPE,BA1.BUZTYPE,BA1.MINORASSETCODE,BA1.MAJORASSETCODE)
       AND (BA.SETTLEDATE >= V_MONTH_START_DATEID)),
      ASSET_LAST_PROFIT AS (
    SELECT BA.*
      FROM RRP_MDL.O_IOL_CTMS_FBS_V_BALANCE BA, DATA_DATE_RANG DDB
     WHERE BA.BALANCE_ID IN
           (SELECT MAX(BA1.BALANCE_ID)
              FROM RRP_MDL.O_IOL_CTMS_FBS_V_BALANCE BA1,
                   DATA_DATE_RANG                   DDB1
             WHERE BA1.SETTLEDATE <= TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH_END_DATEID,'YYYYMMDD'), -1),'YYYYMMDD')
               AND BA1.BUZTYPE = '外币拆借/同存'
             GROUP BY BA1.KEEPFOLDER_ID,BA1.ASSETTYPE,BA1.BUZTYPE,BA1.MINORASSETCODE,BA1.MAJORASSETCODE))
    SELECT 'B1194H244050001'                                          AS JRXKZH -- 金融许可证号
           ,'896821'                                                  AS NBJGH --内部机构号
           ,'广东华兴银行股份有限公司总行'                            AS YXJGMC --银行机构名称
            --金融工具编号,可取 T2.CLIENT_DEAL_SQNO的字段
           ,T2.COUNTER_PARTY_ID || '_' || T2.DEAL_SQNO                AS JRGJBH --金融工具编号
           ,T2.COUNTER_PARTY_SCNAME || '_' ||
            CASE WHEN T2.IBO_TYPE = '0' THEN DECODE(T2.DEAL_DIR,'1','同业拆入','拆放同业')
                 WHEN T2.IBO_TYPE = '4' AND T2.COLLATERAL_METHOD = '质押'
                 THEN DECODE(T2.DEAL_DIR,'1','质押式正回购','质押式逆回购')
                 WHEN T2.IBO_TYPE = '4' AND T2.COLLATERAL_METHOD = '买断'
                 THEN DECODE(T2.DEAL_DIR,'1','买断式正回购','买断式逆回购')
             END                                                      AS JRGJMC --金融工具名称
           ,'其他-' ||
             CASE WHEN T2.IBO_TYPE = '0' THEN DECODE(T2.DEAL_DIR,'1','同业拆入','拆放同业')
                  WHEN T2.IBO_TYPE = '4' AND T2.COLLATERAL_METHOD = '质押'
                  THEN DECODE(T2.DEAL_DIR,'1','质押式正回购','质押式逆回购')
                  WHEN T2.IBO_TYPE = '4' AND T2.COLLATERAL_METHOD = '买断'
                  THEN DECODE(T2.DEAL_DIR,'1','买断式正回购','买断式逆回购')
             END                                                      AS ZCLX --资产类型
           ,T2.CRNCY_CODE                                             AS BZ --币种
           ,0                                                         AS FXJG --发行价格
           ,CASE WHEN T4.SETTLEDATE >= TO_CHAR(T2.MATURITY_DATE,'YYYYMMDD') THEN 0
                 ELSE ABS(NVL(T4.HOLDPOSITION, 0))
             END                                                      AS FXZGM --发行总规模
           ,T3.COUNTERPARTY_CNAME                                     AS FXJGMC --发行机构名称
           ,TRIM(T3.LABEL)                                            AS ECIF_CODE --ECIF客户号
           ,NULL                                                      AS FXJGDM --发行机构代码
           ,'CHN'                                                     AS FXGB --发行国别
           ,TO_CHAR(T2.DEAL_DATE,'YYYYMMDD')                         AS FXRQ --发行日期
           ,TO_CHAR(T2.MATURITY_DATE,'YYYYMMDD')                     AS DQRQ --到期日期
           ,'非LPR'                                                   AS LLLX --利率类型
           ,T2.RATE                                                   AS SJLL --实际利率
           ,'否'                                                      AS HQBS --含权标识
           ,CASE WHEN T1.SETTLEDATE >= TO_CHAR(T2.MATURITY_DATE,'YYYYMMDD') THEN 0
                 ELSE ABS(T1.HOLDPOSITION)
             END                                                      AS ZJPGJG --最近评估价格
           ,'99991231'                                                AS PGJGRQ --最近评估日期
           ,NULL                                                      AS JCZCBH --基础资产编号
           ,NULL                                                      AS JCZCMC --基础资产名称
           ,NULL                                                      AS JCZCGM --基础资产规模
           ,NULL                                                      AS JCZCZB --基础资产占比
           ,NULL                                                      AS JCZCPJ --基础资产评级
           ,NULL                                                      AS JCZCPJJG --基础资产评级机构
           ,NULL                                                      AS JCZCKHMC --基础资产客户名称
           ,NULL                                                      AS JCZCKHGJ --基础资产客户国家
           ,NULL                                                      AS JCZCKHPJ --基础资产客户评级
           ,NULL                                                      AS JCZCKHPJJG --基础资产客户评级机构
           ,NULL                                                      AS JCZCHKHHY --基础资产客户行业
           ,NULL                                                      AS ZZTXLX --最终投向类型
           ,NULL                                                      AS ZZTXHY --最终投向行业
           ,NULL                                                      AS BBZ --备注
           ,DR.DATA_DATE                                              AS CJRQ --采集日期
           ,'外币拆借/外币回购'                                        AS DATA_SRC_DESC --数据来源中文
      FROM DATA_BASE T1
      --FROM RRP_MDL.O_IOL_CTMS_FBS_V_BALANCE T1
     INNER JOIN RRP_MDL.O_IOL_CTMS_FBS_V_IBO_DEAL T2
        ON T2.DEAL_SQNO = T1.MAJORASSETCODE
     INNER JOIN RRP_MDL.O_IOL_CTMS_FBS_V_COUNTERPARTY T3
        ON T3.COUNTERPARTY_SEQ = T2.COUNTER_PARTY_ID
      LEFT JOIN ASSET_LAST_PROFIT T4
        ON T4.ASSETTYPE = T1.ASSETTYPE
       AND T4.BUZTYPE = T1.BUZTYPE
       AND T4.MINORASSETCODE = T1.MINORASSETCODE
       AND T4.MAJORASSETCODE = T1.MAJORASSETCODE
       AND T4.KEEPFOLDER_ID = T1.KEEPFOLDER_ID, DATA_DATE_RANG DR
     WHERE 1 = 1;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP      := V_STEP + 1;
    V_STEP_DESC := '金融工具信息表_债券及同业存单投资';
    V_STARTTIME := SYSDATE;
    --金融工具信息表_债券及同业存单投资
    INSERT INTO RRP_EAST.EAST5_1002_JRGJXXB_ZJ
      (JRXKZH --金融许可证号
      ,NBJGH --内部机构号
      ,YHJGMC --银行机构名称
      ,JRGJBH --金融工具编号
      ,JRGJMC --金融工具名称
      ,ZCLX --资产类型
      ,BZ --币种
      ,FXJG --发行价格
      ,FXZGM --发行总规模
      ,FXJGMC --发行机构名称
      ,ECIF_CODE --ECIF客户号
      ,FXJGDM --发行机构代码
      ,FXGB --发行国别
      ,FXRQ --发行日期
      ,DQRQ --到期日期
      ,LLLX --利率类型
      ,SJLL --实际利率
      ,HQBS --含权标识
      ,ZJPGJG --最近评估价格
      ,PGJGRQ --最近评估日期
      ,JCZCBH --基础资产编号
      ,JCZCMC --基础资产名称
      ,JCZCGM --基础资产规模
      ,JCZCZB --基础资产占比
      ,JCZCPJ --基础资产评级
      ,JCZCPJJG --基础资产评级机构
      ,JCZCKHMC --基础资产客户名称
      ,JCZCKHGJ --基础资产客户国家
      ,JCZCKHPJ --基础资产客户评级
      ,JCKHPJJG --基础资产客户评级机构
      ,JCZCHKHHY --基础资产客户行业
      ,ZZTXLX --最终投向类型
      ,ZZTXHY --最终投向行业
      ,BZH --备注
      ,CJRQ --采集日期
      ,DATA_SRC_DESC --数据来源中文
      )
    WITH DATA_DATE_RANG AS (
    SELECT V_MONTH_START_DATEID AS BEGIN_DATE,
           V_MONTH_END_DATEID   AS END_DATE,
           V_MONTH_END_DATEID   AS DATA_DATE
      FROM DUAL),
    DATA_BASE AS (
    SELECT SUM(BA.HOLDPOSITION) AS HOLDPOSITION,
           SUBSTR(KF.CONTROLFACTOR, 2, 2) AS FOLDERATTS,
           BA.MAJORASSETCODE,
           M.DEPARTMENTID,
           SUM(DECODE(BA.BUZTYPE,'债券负债', -1, 1) *
               (DECODE(BA.ASSETTYPE,'交易性金融资产',BA.CLEANPRICECOST,BA.HOLDFACEAMOUNT)
                + BA.INTERESTADJUST + BA.FAIRVALUEALTER
                + (CASE WHEN T2.DISCOUNT_RATE = '0' AND T2.RATE_TYPE != '3' AND
                             (T2.PAYMENT_FREQ != '1Y' OR (T2.PAYMENT_FREQ = '1Y' AND
                             TO_DATE(T2.MATURITY_DATE,'YYYYMMDD') - TO_DATE(T2.START_COUPON_DATE,'YYYYMMDD') > 366))
                        THEN 0
                        ELSE BA.INTERESTCOST
                    END))) AS ZM_BALANCE
      --FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE2 BA
      FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA --MOD BY LIP 20250313 根据与徐银鹏沟通，改成不带2的表
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_V_SECURITY T2
        ON BA.MAJORASSETCODE = T2.SECURITY_CODE
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_KEEPFOLDER KF
        ON BA.KEEPFOLDER_ID = KF.KEEPFOLDER_ID
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_INTERFACE_PORTF_DEPART_MAPPING M
        ON KF.KEEPFOLDER_ID = M.KEEPFOLDER_ID, DATA_DATE_RANG DDB
     WHERE BA.BALANCE_ID IN
           (SELECT MAX(BA1.BALANCE_ID)
              --FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE2 BA1,
              FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA1, --MOD BY LIP 20250313 根据与徐银鹏沟通，改成不带2的表
                   DATA_DATE_RANG                    DDB1
             WHERE BA1.SETTLEDATE <= /*DDB1.END_DATE*/V_MONTH_END_DATEID
               AND BA1.BUZTYPE IN ('现券','债券负债')
               AND BA1.MAJORASSETCODE = BA1.MINORASSETCODE
               AND NVL(BA1.BARETRADENAME,'-') <> 'CARRYOVERDEALS' --ADD BY LIP 20250117 过滤年决数据
             GROUP BY BA1.ASPCLIENT_ID,BA1.MINORASSETCODE,BA1.MAJORASSETCODE,BA1.KEEPFOLDER_ID,BA1.ASPCLIENT_ID)
       AND (BA.HOLDPOSITION <> 0 OR BA.SETTLEDATE >= /*DDB.BEGIN_DATE*/V_MONTH_START_DATEID)
     GROUP BY SUBSTR(KF.CONTROLFACTOR, 2, 2),BA.MAJORASSETCODE,M.DEPARTMENTID), --基础视图，将持仓得债券，按交易账户、债券代码，进行仓位汇总
    ISSUER_RATING_BASE AS (
    SELECT ISSUER_ID,
           MAX(RATING_DATE) AS RATING_DATE,
           MAX(FIRM_ID) KEEP(DENSE_RANK FIRST ORDER BY RATING_DATE DESC) AS FIRM_ID
      FROM RRP_MDL.O_IOL_CTMS_TBS_V_ISSUER_RATING
     GROUP BY ISSUER_ID),
    DS_ISSUER_RATING AS (
    SELECT DISTINCT T.ISSUER_ID,
           T.FIRM_ID,
           T.RATING,
           T.RATING_DATE,
           T.ISSUER_NAME_ZH,
           T.ISSUER_NAME_EN,
           T.RATING_CATEGORY,
           TRIM(FR.FIRM_NAME_ZH) AS FIRM_NAME_ZH
      FROM RRP_MDL.O_IOL_CTMS_TBS_V_ISSUER_RATING T,
           ISSUER_RATING_BASE B,
           RRP_MDL.O_IOL_CTMS_TBS_V_RATING_FIRM FR
     WHERE T.ISSUER_ID = B.ISSUER_ID
       AND T.RATING_DATE = B.RATING_DATE
       AND T.FIRM_ID = B.FIRM_ID
       AND T.FIRM_ID = FR.FIRM_ID),
    SECURITY_RATING_BASE AS (
    SELECT SECURITY_CODE,
           MAX(RATING_DATE) AS RATING_DATE,
           MAX(FIRM_ID) KEEP(DENSE_RANK FIRST ORDER BY RATING_DATE DESC) AS FIRM_ID
      FROM RRP_MDL.O_IOL_CTMS_TBS_V_SECURITY_RATING
     GROUP BY SECURITY_CODE),
    DS_SECURITY_RATING AS (
    SELECT DISTINCT TRIM(T.SECURITY_CODE) AS SECURITY_CODE,
           TRIM(T.FIRM_ID) AS FIRM_ID,
           TRIM(T.RATING) AS RATING,
           T.RATING_DATE,
           TRIM(FR.FIRM_NAME_ZH) AS FIRM_NAME_ZH
      FROM RRP_MDL.O_IOL_CTMS_TBS_V_SECURITY_RATING T,
           SECURITY_RATING_BASE B,
           RRP_MDL.O_IOL_CTMS_TBS_V_RATING_FIRM FR
     WHERE T.SECURITY_CODE = B.SECURITY_CODE
       AND T.RATING_DATE = B.RATING_DATE
       AND T.FIRM_ID = B.FIRM_ID
       AND T.FIRM_ID = FR.FIRM_ID),
    --公开债券最新的公允价值
    LAST_CDC AS (
    SELECT V.SECURITY_CODE,
           --MAX(V.PRICING_DATE) AS PRICING_DATE,
           MAX(DECODE(TRIM(V.PRICING_DATE),0,'',TO_CHAR(V.PRICING_DATE))) AS PRICING_DATE, --MOD BY LIP 20250722
           MAX(V.CP) KEEP(DENSE_RANK FIRST ORDER BY V.PRICING_DATE) AS CP
      FROM RRP_MDL.O_IOL_CTMS_TBS_V_CDC_FP V,DATA_DATE_RANG DR
     WHERE V.PRICING_DATE >= DR.BEGIN_DATE
       AND V.PRICING_DATE <= DR.END_DATE
     GROUP BY V.SECURITY_CODE), --自定义债券的最新维护价格
    LAST_CDC1 AS ( --ADD BY LIP 20250722 根据徐银鹏提供的脚本，取外国债券的估值和评估日期
    SELECT MAJORASSETCODE,
           MAX(DECODE(TRIM(T1.PRICEDATE),0,'',TO_CHAR(T1.PRICEDATE))) AS PRICEDATE,
           MAX(T1.FAIRPRICE) KEEP(DENSE_RANK FIRST ORDER BY T1.PRICEDATE DESC) AS FAIRPRICE
      FROM RRP_MDL.O_IOL_CTMS_TBS_V_ESTIMATIONDEALS T1 --估值
     WHERE MAJORASSETCODE LIKE 'X%'
     GROUP BY MAJORASSETCODE)
    SELECT 'B1194H244050001'                                          AS JRXKZH -- 金融许可证号
           ,T1.DEPARTMENTID                                           AS NBJGH --内部机构号
           ,'广东华兴银行股份有限公司总行'                            AS YXJGMC --银行机构名称
           ,NVL(T5.EXTRA_CODE, T1.MAJORASSETCODE)                     AS JRGJBH --金融工具编号
           ,T4.SECURITY_NAME                                          AS JRGJMC --金融工具名称
           ,'标准化债券'                                              AS ZCLX --资产类型
           ,T4.CCY                                                    AS BZ --币种
           ,ROUND(T4.AUTION_PRICE, 2)                                 AS FXJG --发行金额
           ,T4.NUMBER_ISSUED * 100000000                              AS FXZGM --发行总规模
           ,T4.ISSUER                                                 AS FXJGMC --发行机构名称
           ,IRCP.LABEL                                                AS ECIF_CODE --ECIF客户号
           ,NULL                                                      AS FXJGDM --发行机构代码
           ,DECODE(T4.CCY,'CNY','CHN', T6.ISSUER_COUNTRY_NAME)        AS FXGB --发行国别
           ,TRIM(T4.ISSUE_DATE)                                       AS FXRQ --发行日期
           ,TRIM(T4.MATURITY_DATE)                                    AS DQRQ --到期日期
           ,'非LPR'                                                   AS LLLX --利率类型
           ,DECODE(T4.DISCOUNT_RATE,'1', T4.AUTION_RATE, T4.FIXED_RATE) AS SJLL --实际利率
           ,DECODE(T4.OPTION_TYPE,'0','否','是')                      AS HQBS --含权标识
           /*,T7.CP                                                     AS ZJPGJG --最近评估价格
           ,DECODE(TRIM(T7.PRICING_DATE),0,'',TO_CHAR(PRICING_DATE))  AS PGJGRQ --最近评估日期*/
           --MOD BY LIP 20250722
           ,NVL(T7.CP,T8.FAIRPRICE)                                   AS ZJPGJG --最近评估价格
           ,NVL(T7.PRICING_DATE,T8.PRICEDATE)                         AS PGJGRQ --最近评估日期
           ,NVL(TRIM(T5.EXTRA_CODE),TRIM(T1.MAJORASSETCODE))          AS JCZCBH --基础资产编号
           ,T4.SECURITY_NAME                                          AS JCZCMC --基础资产名称
           ,T1.ZM_BALANCE                                             AS JCZCGM --基础资产规模
           ,ROUND(T1.HOLDPOSITION / T4.NUMBER_ISSUED / 1000000, 2)    AS JCZCZB --基础资产占比
           ,SR.RATING                                                 AS JCZCPJ --基础资产评级
           ,TRIM(SR.FIRM_NAME_ZH)                                     AS JCZCPJJG --基础资产评级机构
           ,T4.ISSUER                                                 AS JCZCKHMC --基础资产客户名称
           ,DECODE(T4.CCY,'CNY','CHN', T6.ISSUER_COUNTRY_NAME)        AS JCZCKHGJ --基础资产客户国家
           ,DIR.RATING                                                AS JCZCKHPJ --基础资产客户评级
           ,TRIM(DIR.FIRM_NAME_ZH)                                    AS JCZCKHPJJG --基础资产客户评级机构
           ,NULL                                                      AS JCZCHKHHY --基础资产客户行业
           ,NULL                                                      AS ZZTXLX --最终投向类型
           ,NULL                                                      AS ZZTXHY --最终投向行业
           ,NULL                                                      AS BBZ --备注
           ,V_MONTH_END_DATEID                                        AS CJRQ --采集日期
           ,'债券及同业存单投资'                                      AS DATA_SRC_DESC --数据来源中文
      FROM DATA_BASE T1
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_V_SECURITY T4
        ON T4.SECURITY_CODE = T1.MAJORASSETCODE
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_ISSUER IR
        ON IR.ISSUER_NAME_ZH = T4.ISSUER
      LEFT JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_CPTYS IRCP
        ON IRCP.REF_ISSUER_ID = IR.ISSUER_ID
      LEFT JOIN RRP_MDL.O_IOL_CTMS_TBS_SECURITY_EXTRA_CODE T5
        ON T5.SECURITY_CODE = T1.MAJORASSETCODE
      LEFT JOIN DS_SECURITY_RATING SR
        ON SR.SECURITY_CODE = T4.SECURITY_CODE
      LEFT JOIN DS_ISSUER_RATING DIR
        ON DIR.ISSUER_ID = IR.ISSUER_ID
      LEFT JOIN RRP_MDL.O_IOL_CTMS_TBS_SECURITY_EXTRA T6
        ON T6.SECURITY_CODE = T4.SECURITY_CODE
      LEFT JOIN LAST_CDC T7
        ON T7.SECURITY_CODE = T4.SECURITY_CODE
      LEFT JOIN LAST_CDC1 T8 --ADD BY LIP 20250722
        ON T8.MAJORASSETCODE = T1.MAJORASSETCODE,DATA_DATE_RANG DDB;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP      := V_STEP + 1;
    V_STEP_DESC := '资金数据-插入中间表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_1002_JRGJXXB_ZJ_R
      (RID --数据主键
      ,JRXKZH --金融许可证号
      ,NBJGH --内部机构号
      ,YHJGMC --银行机构名称
      ,JRGJBH --金融工具编号
      ,JRGJMC --金融工具名称
      ,ZCLX --资产类型
      ,BZ --币种
      ,FXJG --发行价格
      ,FXZGM --发行总规模
      ,FXJGMC --发行机构名称
      ,FXJGDM --发行机构代码
      ,FXGB --发行国别
      ,FXRQ --发行日期
      ,DQRQ --到期日期
      ,LLLX --利率类型
      ,SJLL --实际利率
      ,HQBS --含权标识
      ,ZJPGJG --最近评估价格
      ,PGJGRQ --评估价格日期
      ,JCZCBH --基础资产编号
      ,JCZCMC --基础资产名称
      ,JCZCGM --基础资产规模
      ,JCZCZB --基础资产占比
      ,JCZCPJ --基础资产评级
      ,JCZCPJJG --基础资产评级机构
      ,JCZCKHMC --基础资产客户名称
      ,JCZCKHGJ --基础资产客户国家
      ,JCZCKHPJ --基础资产客户评级
      ,JCZCKHPJJG --基础资产客户评级机构
      ,JCZCHKHHY --基础资产客户行业--取ECIF客户所属行业
      ,ZZTXLX --最终投向类型
      ,ZZTXHY --最终投向行业--取ECIF客户所属行业
      ,BBZ --备注
      ,CJRQ --采集日期
      ,DEPT_NO --部门编号
      ,SRC_SYS_ID --来源系统ID
      ,ISSUED_NO --填报机构
      ,ORG_NO --报送机构
      ,ADDRESS --归属地
      ,GSFZJG --归属分支机构
      ,DATA_SRC_DESC --数据来源中文
       )
    SELECT SYS_GUID()                                  AS RID,       --数据主键
           B.FIN_PERMIT_NO                             AS JRXKZH,    --金融许可证号
           NVL(TRIM(C.ORG_ID1),'896')                  AS NBJGH,     --内部机构号
           B.ORG_NM                                    AS YHJGMC,    --银行机构名称
           A.JRGJBH                                    AS JRGJBH,    --金融工具编号
           A.JRGJMC                                    AS JRGJMC,    --金融工具名称
           A.ZCLX                                      AS ZCLX,      --资产类型
           A.BZ                                        AS BZ,        --币种
           A.FXJG                                      AS FXJG,      --发行价格
           A.FXZGM                                     AS FXZGM,     --发行总规模
           A.FXJGMC                                    AS FXJGMC,    --发行机构名称
           --NVL(TRIM(D.SOCI_CRDT_CD), F.SOCI_CRDT_CD)   AS FXJGDM,    --发行机构代码
           COALESCE(TRIM(D.SOCI_CRDT_CD),TRIM(D.ORGNZ_CD),TRIM(F.SOCI_CRDT_CD),TRIM(F.ORGNZ_CD),TRIM(A.FXJGDM)) AS FXJGDM, --发行机构代码
           A.FXGB                                      AS FXGB,      --发行国别
           TRIM(A.FXRQ)                                AS FXRQ,      --发行日期
           TRIM(A.DQRQ)                                AS DQRQ,      --到期日期
           A.LLLX                                      AS LLLX,      --利率类型
           A.SJLL                                      AS SJLL,      --实际利率
           A.HQBS                                      AS HQBS,      --含权标识
           A.ZJPGJG                                    AS ZJPGJG,    --最近评估价格
           DECODE(NVL(TRIM(A.PGJGRQ),'0'),'0','99991231',TRIM(A.PGJGRQ)) AS PGJGRQ, --评估价格日期
           A.JCZCBH                                    AS JCZCBH,    --基础资产编号
           A.JCZCMC                                    AS JCZCMC,    --基础资产名称
           A.JCZCGM                                    AS JCZCGM,    --基础资产规模
           A.JCZCZB                                    AS JCZCZB,    --基础资产占比
           A.JCZCPJ                                    AS JCZCPJ,    --基础资产评级
           A.JCZCPJJG                                  AS JCZCPJJG,  --基础资产评级机构
           A.JCZCKHMC                                  AS JCZCKHMC,  --基础资产客户名称
           A.JCZCKHGJ                                  AS JCZCKHGJ,  --基础资产客户国家
           A.JCZCKHPJ                                  AS JCZCKHPJ,  --基础资产客户评级
           TRIM(A.JCKHPJJG)                            AS JCZCKHPJJG,--基础资产客户评级机构
           --NVL(TRIM(D.INDUS_TYPE_CD_CRDTC),F.INDUS_TYPE_CD_CRDTC)|| '_' || G.VALUE_NAME AS JCZCHKHHY,
           CASE WHEN REGEXP_LIKE(TRIM(D.INDUS_TYPE_CD_CRDTC),'^[A-Z][0-9]{4}$') THEN TRIM(D.INDUS_TYPE_CD_CRDTC)
                WHEN REGEXP_LIKE(TRIM(D.INDUS_TYPE_CD),'^[A-Z][0-9]{4}$') THEN TRIM(D.INDUS_TYPE_CD)
                WHEN REGEXP_LIKE(TRIM(F.INDUS_TYPE_CD_CRDTC),'^[A-Z][0-9]{4}$') THEN TRIM(F.INDUS_TYPE_CD_CRDTC)
                WHEN REGEXP_LIKE(TRIM(F.INDUS_TYPE_CD),'^[A-Z][0-9]{4}$') THEN TRIM(F.INDUS_TYPE_CD)
            END                                        AS JCZCHKHHY, --基础资产客户行业
           A.ZZTXLX                                    AS ZZTXLX,    --最终投向类型
           --NVL(TRIM(D.INDUS_TYPE_CD_CRDTC),F.INDUS_TYPE_CD_CRDTC)|| '_' || G.VALUE_NAME AS ZZTXHY,
           CASE WHEN REGEXP_LIKE(TRIM(D.INDUS_TYPE_CD_CRDTC),'^[A-Z][0-9]{4}$') THEN TRIM(D.INDUS_TYPE_CD_CRDTC)
                WHEN REGEXP_LIKE(TRIM(D.INDUS_TYPE_CD),'^[A-Z][0-9]{4}$') THEN TRIM(D.INDUS_TYPE_CD)
                WHEN REGEXP_LIKE(TRIM(F.INDUS_TYPE_CD_CRDTC),'^[A-Z][0-9]{4}$') THEN TRIM(F.INDUS_TYPE_CD_CRDTC)
                WHEN REGEXP_LIKE(TRIM(F.INDUS_TYPE_CD),'^[A-Z][0-9]{4}$') THEN TRIM(F.INDUS_TYPE_CD)
            END                                        AS ZZTXHY,    --最终投向行业
           A.BZH                                       AS BBZ,       --备注
           A.CJRQ                                      AS CJRQ,      --采集日期
           '000'                                       AS DEPT_NO,   --部门编号
           '01'                                        AS SRC_SYS_ID,--来源系统ID
           A.NBJGH                                     AS ISSUED_NO, --填报机构
           '000000'                                    AS ORG_NO,    --报送机构
           ''                                          AS ADDRESS,   --归属地
           B.GSFZJG                                    AS GSFZJG,    --归属分支机构
           A.DATA_SRC_DESC                             AS DATA_SRC_DESC --数据来源中文
      FROM RRP_EAST.EAST5_1002_JRGJXXB_ZJ A
      LEFT JOIN RRP_MDL.ORG_CONFIG C --机构映射表
        ON C.ORG_ID = A.NBJGH
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(TRIM(C.ORG_ID1),'896')
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO D --对公客户基本信息
        ON D.CUST_ID = TRIM(A.ECIF_CODE)
       AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_IML_PTY_SPV_CUST_INFO E --SPV客户信息
        ON E.SPV_CUST_ID = TRIM(A.ECIF_CODE)
       AND E.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
       AND E.END_DT >= TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO F --对公客户基本信息
        ON F.CUST_ID = TRIM(E.PARTY_ID)
       AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      /*LEFT JOIN RRP_MDL.CONFIG_CODE G --码值表
        ON G.VALUE_CODE = NVL(TRIM(D.INDUS_TYPE_CD_CRDTC),F.INDUS_TYPE_CD_CRDTC)
       AND G.CLASS_CODE = 'P0003' --行业类别*/
     WHERE A.CJRQ = V_MONTH_END_DATEID;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP      := V_STEP + 1;
    V_STARTTIME := SYSDATE;
    V_STEP_DESC := '金融工具信息表_同业系统';
    --金融工具信息表_同业系统
    INSERT INTO RRP_EAST.EAST5_1002_JRGJXXB_TY
      (JRXKZH --金融许可证号
      ,NBJGH --内部机构号
      ,YHJGMC --银行机构名称
      ,JRGJBH --金融工具编号
      ,JRGJMC --金融工具名称
      ,ZCLX --资产类型
      ,BZ --币种
      ,FXJG --发行价格
      ,FXZGM --发行总规模
      ,FXJGMC --发行机构名称
      ,FXJGDM --发行机构代码
      ,FXGB --发行国别
      ,FXRQ --发行日期
      ,DQRQ --到期日期
      ,LLLX --利率类型
      ,SJLL --票面利率/实际利率
      ,HQBS --含权标识
      ,ZJPGJG --最近评估价格
      ,PGJGRQ --最近评估日期
      ,JCZCBH --基础资产编号
      ,JCZCMC --基础资产名称
      ,JCZCGM --基础资产规模
      ,JCZCZB --基础资产占比
      ,JCZCPJ --基础资产评级
      ,JCZCPJJG --基础资产评级机构
      ,JCZCKHMC --基础资产客户名称
      ,JCZCKHGJ --基础资产客户国家
      ,JCZCKHPJ --基础资产客户评级
      ,JCKHPJJG --基础资产客户评级机构
      ,JCZCHKHHY --基础资产或客户行业
      ,ZZTXLX --最终投向类型
      ,ZZTXHY --最终投向行业
      ,BZH --备注
      ,CJRQ --采集日期
      ,CORE_SYS_CUSTOMER_CODE --客户号
      ,DATA_SRC_DESC --数据来源中文
       )
      WITH INPUTPARAMS AS
       (SELECT TO_CHAR(TO_DATE(V_MONTH_START_DATEID,'YYYYMMDD'),'YYYY-MM-DD') FIRSTDATE,
               TO_CHAR(TO_DATE(V_MONTH_END_DATEID,'YYYYMMDD'),'YYYY-MM-DD') BEGDATE
          FROM DUAL),
      PARAMS AS
       (SELECT BEGDATE,
               TO_CHAR(TO_DATE(FIRSTDATE,'YYYY-MM-DD') - 1,'YYYY-MM-DD') FIRSTLASTDATE,
               TO_CHAR(TRUNC(TO_DATE(BEGDATE,'YYYY-MM-DD'),'MM') - 1,'YYYY-MM-DD') LASTDATE
          FROM INPUTPARAMS),
      ICODE_CHG AS
       (SELECT /*+MATERIALIZE*/DISTINCT ET.U_I_CODE, ET.U_A_TYPE, ET.U_M_TYPE
          FROM (SELECT INST_ID, ERASE_REF_CHG_ID, I_CODE, A_TYPE, M_TYPE
                  FROM RRP_MDL.O_IOL_IBMS_TTRD_ACCOUNTING_SECU_CHG
                 WHERE CHG_DATE <= (SELECT BEGDATE FROM PARAMS)
                UNION ALL
                SELECT INST_ID, ERASE_REF_CHG_ID, I_CODE, A_TYPE, M_TYPE
                  FROM RRP_MDL.O_IOL_IBMS_TTRD_ACCOUNTING_SECU_CHG_HIS
                 WHERE CHG_DATE <= (SELECT BEGDATE FROM PARAMS)) C
          LEFT JOIN RRP_MDL.O_IOL_IBMS_VTRD_SET_INSTRUCTION_SECU SE
            ON C.INST_ID = SE.SECU_INST_ID
          LEFT JOIN RRP_MDL.O_IOL_IBMS_VTRD_SET_INSTRUCTION V
            ON SE.INST_ID = V.INST_ID
          LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_OTC_TRADE TRD
            ON TRD.INTORDID = V.TRADE_ID
          LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_OTC_TRADE_EXTEND ET
            ON ET.TRD_ID = TRD.SYSORDID
         WHERE V.TRD_TYPE = '0000061'
           AND V.STATE = 999
           AND C.ERASE_REF_CHG_ID = -1
           AND C.I_CODE = ET.U_I_CODE
           AND C.A_TYPE = ET.U_A_TYPE
           AND C.M_TYPE = ET.U_M_TYPE),
      SECUO AS
       (SELECT /*+MATERIALIZE*/O.I_CODE,O.A_TYPE,O.M_TYPE,INST.ORG_ID,
               SUM(O.REAL_CP + O.DUE_CP) CP
          FROM (--MODIFY BY LIP 20220829 RRP_MDL.O_IOL_IBMS_TTRD_ACCOUNTING_SECU_OBJ和RRP_MDL.O_IOL_IBMS_TTRD_ACCOUNTING_SECU_OBJ_HIS数据重复
                /*SELECT O.I_CODE,O.A_TYPE,O.M_TYPE,O.REAL_CP,O.DUE_CP,OBJ_ID,PRFT_IR,PRFT_TRD,PRFT_FV,SECU_ACCT_ID
                  FROM RRP_MDL.O_IOL_IBMS_TTRD_ACCOUNTING_SECU_OBJ O
                 WHERE BEG_DATE = (SELECT BEGDATE FROM PARAMS)
                UNION ALL*/
                SELECT O.I_CODE,O.A_TYPE,O.M_TYPE,O.REAL_CP,O.DUE_CP,OBJ_ID,PRFT_IR,PRFT_TRD,PRFT_FV,SECU_ACCT_ID
                  FROM RRP_MDL.O_IOL_IBMS_TTRD_ACCOUNTING_SECU_OBJ_HIS O
                 WHERE BEG_DATE = (SELECT BEGDATE FROM PARAMS)
                UNION ALL
                SELECT O.I_CODE,O.A_TYPE,O.M_TYPE,O.REAL_CP,O.DUE_CP,OBJ_ID,PRFT_IR,PRFT_TRD,PRFT_FV,SECU_ACCT_ID
                  FROM RRP_MDL.O_IOL_IBMS_TTRD_ACCOUNTING_SECU_OBJ_COMP O
                 WHERE BEG_DATE <= (SELECT BEGDATE FROM PARAMS)
                   AND END_DATE > (SELECT BEGDATE FROM PARAMS)) O
          LEFT JOIN (SELECT I_CODE,A_TYPE,M_TYPE,REAL_CP,DUE_CP,OBJ_ID,PRFT_IR,PRFT_TRD,PRFT_FV,SECU_ACCT_ID
                      FROM RRP_MDL.O_IOL_IBMS_TTRD_ACCOUNTING_SECU_OBJ_HIS H
                     WHERE BEG_DATE = (SELECT FIRSTLASTDATE FROM PARAMS)
                    UNION ALL
                    SELECT I_CODE,A_TYPE,M_TYPE,REAL_CP,DUE_CP,OBJ_ID,PRFT_IR,PRFT_TRD,PRFT_FV,SECU_ACCT_ID
                      FROM RRP_MDL.O_IOL_IBMS_TTRD_ACCOUNTING_SECU_OBJ_COMP T
                     WHERE BEG_DATE <= (SELECT FIRSTLASTDATE FROM PARAMS)
                       AND END_DATE > (SELECT FIRSTLASTDATE FROM PARAMS)) F
            ON F.OBJ_ID = O.OBJ_ID
          LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_ACC_SECU ACC
            ON ACC.ACCID = O.SECU_ACCT_ID
          LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_INSTITUTION INST
            ON INST.I_ID = ACC.I_ID
         WHERE (O.REAL_CP + O.DUE_CP <> 0
               OR O.PRFT_IR + O.PRFT_TRD + O.PRFT_FV -COALESCE(F.PRFT_IR + F.PRFT_TRD + F.PRFT_FV, 0) <> 0
               OR COALESCE(F.REAL_CP + F.DUE_CP, 0) <> 0)
         GROUP BY O.I_CODE, O.A_TYPE, O.M_TYPE, INST.ORG_ID),
      TRD AS
       (SELECT /*+MATERIALIZE*/TRD.I_CODE,TRD.A_TYPE,TRD.M_TYPE,
               SUM(CASE WHEN TRD.TRDTYPE = '0170000' THEN TRD.ORDCOUNT
                        ELSE TRD.ORDAMOUNT
                   END) ORDAMOUNT,
               MAX(TRD.FINAL_INVEST) FINAL_INVEST
          FROM RRP_MDL.O_IOL_IBMS_TTRD_OTC_TRADE TRD
         WHERE TRD.ORDSTATUS = 4
           AND TRD.INSSTATUS = 999
           --AND TRD.REF_SYSORDID IS NULL
           --数仓默认值问题 MODIFY BY LIP 20220829
           AND TRIM(TRD.REF_SYSORDID) = 0
           AND TRD.TRDTYPE IN ('0170000')
         GROUP BY TRD.I_CODE, TRD.A_TYPE, TRD.M_TYPE),
      IBMS_TTRD_BLC_SECU_OBJ AS
       (SELECT /*+MATERIALIZE*/BB.I_CODE,BB.A_TYPE,BB.M_TYPE,ABS(SUM(VOLUME)) VOLUME
          FROM RRP_MDL.O_IOL_IBMS_TTRD_BLC_SECU_OBJ BB
         WHERE BEG_DATE = (SELECT BEGDATE FROM PARAMS)
           AND BB.SET_DATE = '1900-01-01'
           AND BB.BLC_TYPE IN (211,212)
           AND BB.P_OBJ_ID = -1
         GROUP BY BB.I_CODE,BB.A_TYPE,BB.M_TYPE)
    SELECT DISTINCT
           NULL                                                       AS JRXKZH, --金融许可证号
           O.ORG_ID                                                   AS NBJGH, --内部机构号
           NULL                                                       AS YHJGMC, --银行机构名称
           COALESCE(TB.I_CODE, T.I_CODE) ||
           COALESCE(TB.A_TYPE, T.A_TYPE) ||
           COALESCE(TB.M_TYPE, T.M_TYPE) || O.ORG_ID ||
           CASE WHEN ND.I_CODE IS NOT NULL THEN TO_CHAR(ND.PARTYID)
                ELSE ''
            END                                                       AS JRGJBH, --金融工具编号
           COALESCE(TB.B_NAME, TTB.B_NAME, TF.F_NAME, T.I_NAME)       AS JRGJMC, --金融工具名称
           CASE WHEN T.P_TYPE IN ('0703','0706') THEN '公募基金'
                WHEN ND.I_CODE IS NOT NULL THEN '其他-同业存单发行'
                WHEN T.P_TYPE IN ('0000','1200','1100','0201','0202') THEN '标准化债券'
                WHEN T.P_TYPE IN ('0170','0700') THEN '非标准化债权类资产'
                ELSE '其他-' || PT.P_TYPE_NAME
            END                                                       AS ZCLX, --资产类型
           T.CURRENCY                                                 AS BZ, --币种
           ROUND(CASE WHEN T.P_TYPE IN ('0000','1100','1200') THEN TTB.B_ISSUE_PRICE
                      WHEN T.P_TYPE IN ('0201','0202') THEN TB.B_ISSUE_PRICE
                      WHEN T.P_TYPE IN ('0703','0706','0700') THEN 1
                      ELSE NULL
                  END, 2)                                             AS FXJG, --发行价格
           ROUND(NVL(CASE WHEN T.P_TYPE IN ('0000','1200') /*THEN TTB.B_ACTUAL_ISSUE_AMOUNT*10000*/
                      THEN NVL(E1.AMOUNT*100000000,TTB.B_ACTUAL_ISSUE_AMOUNT*10000) --MOD BY LIP 20241101
                      WHEN T.P_TYPE IN ('0201','0202') AND TB.P_TYPE <> '1100' /*THEN TB.B_ACTUAL_ISSUE_AMOUNT*10000*/
                      THEN NVL(E1.AMOUNT*100000000,TTB.B_ACTUAL_ISSUE_AMOUNT*10000) --MOD BY LIP 20241101
                      WHEN T.P_TYPE = '1100' THEN TE.HXABS_INVESTAMOUNT*10000
                      WHEN T.P_TYPE IN ('0201','0202') AND TB.P_TYPE = '1100' THEN BTE.HXABS_INVESTAMOUNT*10000
                      --WHEN T.P_TYPE IN ('0170') THEN TRDD.ORDAMOUNT
                      WHEN T.P_TYPE IN ('0170') THEN NVL(TRD.ORDAMOUNT,TRDD.ORDAMOUNT)
                      ELSE COALESCE(BB.VOLUME,0)
                 END,0),2)                                            AS FXZGM, --发行总规模
           CASE WHEN T.P_TYPE IN ('0700','0170') THEN COALESCE(INST.I_FULLNAME, ME.FINAL_USE_COMP)
                ELSE INST.I_FULLNAME
            END                                                       AS FXJGMC, --发行机构
           NULL                                                       AS FXJGDM, --发行机构代码
           NULL                                                       AS FXGB, --发行国别
           CASE WHEN COALESCE(TB.P_TYPE, T.P_TYPE) IN ('0000','1100','1200')
                THEN REPLACE(COALESCE(TRIM(TB.B_ISSUE_DATE), TRIM(TTB.B_ISSUE_DATE)),'-','')
                WHEN T.P_TYPE IN ('0703','0706') THEN REPLACE(TRIM(TF.F_DATE),'-','')
                --MOD BY LIP 20250814 净值型项目对应的发行日期取对应的上市时间
                WHEN T.P_TYPE IN ('0700') AND TRIM(TEQ.LIST_DATE) IS NOT NULL THEN REPLACE(TRIM(TEQ.LIST_DATE),'-','')
                WHEN T.P_TYPE IN ('0700') THEN '99991231'
                ELSE REPLACE(TRIM(T.START_DATE),'-','')
           END                                                        AS FXRQ, --发行日期
           CASE WHEN COALESCE(TB.P_TYPE, T.P_TYPE) IN ('0000','1100','1200')
                THEN REPLACE(COALESCE(TRIM(TB.B_MTR_DATE), TRIM(TTB.B_MTR_DATE)),'-','')
                WHEN T.P_TYPE IN ('0703','0706') THEN '99991231'
                WHEN T.P_TYPE IN ('0700') THEN '99991231'
                ELSE REPLACE(TRIM(T.MTR_DATE),'-','')
            END                                                       AS DQRQ, --到期日期
           '非LPR'                                                    AS LLLX, --利率类型
           ROUND(CASE WHEN ND.I_CODE IS NOT NULL THEN ND.ANNUAL_RATE
                      ELSE DECODE(COALESCE(TB.B_COUPON_TYPE, TTB.B_COUPON_TYPE, TO_CHAR(T.COUPON_TYPE)),'2',
                           AD.AD_ACTUALRATE,COALESCE(TB.B_COUPON, TTB.B_COUPON, T.COUPON)) * 100
                 END,4)                                               AS SJLL, --票面利率
           CASE WHEN E.ECOUNT > 0 THEN '是'
                ELSE '否'
            END                                                       AS HQBS, --含权标识
           ROUND(CASE WHEN T.P_TYPE IN ('0000','1100','1200') THEN BE.NETPRICE
                      WHEN T.P_TYPE IN ('0201','0202') THEN TBE.NETPRICE
                      WHEN T.P_TYPE IN ('0703','0706') THEN TN.F_UNITNAV
                      WHEN T.P_TYPE IN ('0700') THEN COALESCE(TEN.UNIT_NAV, TN.F_UNITNAV)
                      ELSE ABS(O.CP)
                 END, 2)                                              AS ZJPGJG, --最近评估价格
           CASE WHEN T.P_TYPE IN ('0000','1100','1200') THEN REPLACE(TRIM(BE.BEG_DATE),'-','')
                WHEN T.P_TYPE IN ('0201','0202') THEN REPLACE(TRIM(TBE.BEG_DATE),'-','')
                WHEN T.P_TYPE IN ('0703','0706') THEN REPLACE(TRIM(TN.BEG_DATE),'-','')
                WHEN T.P_TYPE IN ('0700') THEN REPLACE(COALESCE(TRIM(TEN.BEG_DATE), TRIM(TN.BEG_DATE)),'-','')
                ELSE REPLACE(TRIM(P.BEGDATE),'-','')
            END                                                       AS PGJGRQ, --评估价格日期
           CASE WHEN T.P_TYPE IN ('0000','1100','1200','0201','0202')
                THEN COALESCE(TB.I_CODE, TTB.I_CODE)
                WHEN T.P_TYPE IN ('0703','0706','0170','0700') THEN T.I_CODE
                ELSE NULL
            END                                                       AS JCZCBH, --基础资产编号
           CASE WHEN T.P_TYPE IN ('0000','1100','1200','0201','0202')
                THEN COALESCE(TB.B_NAME, TTB.B_NAME)
                WHEN T.P_TYPE IN ('0703','0706','0170','0700')
                THEN COALESCE(TF.F_NAME, T.I_NAME)
                ELSE NULL
            END                                                       AS JCZCMC, --基础资产名称
           NULL                                                       AS JCZCGM, --基础资产规模
           NULL                                                       AS JCZCZB, --基础资产占比
           CASE WHEN T.P_TYPE IN ('0000','1100','1200','0201','0202')
                THEN CG.S_GRADE
                ELSE NULL
            END                                                       AS JCZCPJ, --基础资产评级
           CASE WHEN T.P_TYPE IN ('0000','1100','1200','0201','0202')
                THEN TRIM(CG.RATING_INSTITUTION)
                ELSE NULL
            END                                                       AS JCZCPJJG, --基础资产评级机构
           CASE WHEN ND.I_CODE IS NOT NULL THEN ND.PARTYNAME
                WHEN T.P_TYPE IN ('0000','1100','1200','0201','0202') THEN INST.I_FULLNAME
                WHEN T.P_TYPE IN ('0703','0706','0170','0700') THEN INST.I_FULLNAME
                ELSE INST.I_FULLNAME
            END                                                       AS JCZCKHMC, --基础资产客户名称
           NULL                                                       AS JCZCKHGJ, --基础资产客户国家
           CASE WHEN ND.I_CODE IS NOT NULL THEN NCG.S_GRADE
                WHEN T.P_TYPE IN ('0000','1100','1200','0201','0202') THEN CG.S_GRADE
                WHEN T.P_TYPE IN ('0703','0706','0170','0700') THEN CG.S_GRADE
            END                                                       AS JCZCKHPJ, --基础资产客户评级
           CASE WHEN ND.I_CODE IS NOT NULL THEN NCG.RATING_INSTITUTION
                WHEN T.P_TYPE IN ('0000','1100','1200','0201','0202') THEN CG.RATING_INSTITUTION
                WHEN T.P_TYPE IN ('0703','0706','0170','0700') THEN CG.RATING_INSTITUTION
            END                                                       AS JCKHPJJG, --基础客户评级机构
           CASE WHEN T.P_TYPE IN ('0000','1100','1200','0201','0202')
                THEN TNI.NODE_VALUE
                ELSE NULL
            END                                                       AS JCZCHKHHY, --基础资产或客户行业
           CASE WHEN COALESCE(TB.P_TYPE, T.P_TYPE) IN ('0000','1100','1200')
                THEN COALESCE(BTE.HX_UNDATYPE, TE.HX_UNDATYPE)
                WHEN T.P_TYPE = '0703' THEN '债券及债券公募基金'
                WHEN T.P_TYPE = '0706' THEN '货币市场工具及货币市场公募基金'
                WHEN T.P_TYPE = '0700' THEN RRP_EAST.GETDICT_VALUE('FinalInvest', TEQ.FINAL_INVEST)
                WHEN T.P_TYPE = '0170' THEN RRP_EAST.GETDICT_VALUE('FinalInvest', TRD.FINAL_INVEST)
            END                                                       AS ZZTXLX, --最终投向类型
           CASE WHEN COALESCE(TB.P_TYPE, T.P_TYPE) IN ('0000','1100','1200')
                --THEN DI.DICT_VALUE
                THEN COALESCE(BTE.HX_INVESTBROHEADING, TE.HX_INVESTBROHEADING)||'_'||DI.DICT_VALUE
                WHEN T.P_TYPE IN ('0703','0706') THEN /*'公开募集证券投资基金'*/ 'J6720'
                --WHEN T.P_TYPE IN ('0700','0170') THEN RRP_EAST.GETDICT_VALUE('businessCategorySmall',ME.BUSINESS_CATEGORY_SMALL)
                WHEN T.P_TYPE IN ('0700','0170')
                THEN TRIM(ME.BUSINESS_CATEGORY_SMALL)||'_'||RRP_EAST.GETDICT_VALUE('businessCategorySmall',ME.BUSINESS_CATEGORY_SMALL)
            END                                                       AS ZZTXHY, --最终投向行业
           NULL                                                       AS BZH, --备注
           REPLACE(P.BEGDATE,'-','')                                  AS CJRQ, --采集日期
           INST.CORE_SYS_CUSTOMER_CODE                                AS CORE_SYS_CUSTOMER_CODE--客户号
           ,'同业系统'                                                AS DATA_SRC_DESC --数据来源中文
      FROM RRP_MDL.O_IOL_IBMS_TTRD_INSTRUMENT T
      LEFT JOIN PARAMS P
        ON 1 = 1
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TBND TB
        ON TB.I_CODE = T.U_I_CODE
       AND TB.A_TYPE = T.U_A_TYPE
       AND TB.M_TYPE = T.U_M_TYPE
       AND T.P_TYPE IN ('0201','0202')
     INNER JOIN SECUO O
        ON O.I_CODE = COALESCE(TB.I_CODE, T.I_CODE)
       AND O.A_TYPE = COALESCE(TB.A_TYPE, T.A_TYPE)
       AND O.M_TYPE = COALESCE(TB.M_TYPE, T.M_TYPE)
      LEFT JOIN TRD TRD
        ON TRD.I_CODE = T.I_CODE
       AND TRD.A_TYPE = T.A_TYPE
       AND TRD.M_TYPE = T.M_TYPE
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TBND TTB
        ON TTB.I_CODE = T.I_CODE
       AND TTB.A_TYPE = T.A_TYPE
       AND TTB.M_TYPE = T.M_TYPE
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_P_TYPE PT
        ON PT.P_TYPE = COALESCE(TB.P_TYPE, T.P_TYPE)
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_INSTITUTION WIN
        ON WIN.I_ID = COALESCE(TB.WARRANTOR_ID, TTB.WARRANTOR_ID)
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_CASHLB_MANAGE_ELE ME
        ON ME.I_CODE = T.I_CODE
       AND ME.A_TYPE = T.A_TYPE
       AND ME.M_TYPE = T.M_TYPE
       AND ME.START_DT <= TO_DATE(V_MONTH_END_DATEID,'YYYYMMDD') --modify by tangan at 20221224
       AND ME.END_DT > TO_DATE(V_MONTH_END_DATEID,'YYYYMMDD') --modify by tangan at 20221224
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_INSTITUTION INST
        --ON TO_CHAR(INST.I_ID) = COALESCE(ME.FINAL_USE_COMP,TO_CHAR(TB.ISSUER_ID),TO_CHAR(TTB.ISSUER_ID),TO_CHAR(T.PARTY_ID))
        ON TO_CHAR(INST.I_ID) = COALESCE(TRIM(ME.FINAL_USE_COMP),TRIM(TO_CHAR(TB.ISSUER_ID)),TRIM(TO_CHAR(TTB.ISSUER_ID)),TRIM(TO_CHAR(T.PARTY_ID)))
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_INSTITUTION_EXT IE
        ON IE.I_ID = INST.I_ID
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TINSTRUMENT_COMP_GRADE CG
        ON CG.COMP_ID = INST.I_ID
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TREE_NODE_INFO TNI
        ON TO_CHAR(TNI.NODE_ID) = IE.RH_BUSINESSTYPE
       AND TNI.TREE_CODE = 'BELONGBUSINESS'
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TRPT_TBND_EXT TE
        ON TE.I_CODE = T.I_CODE
       AND TE.A_TYPE = T.A_TYPE
       AND TE.M_TYPE = T.M_TYPE
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TRPT_TBND_EXT BTE
        ON BTE.I_CODE = TB.I_CODE
       AND BTE.A_TYPE = TB.A_TYPE
       AND BTE.M_TYPE = TB.M_TYPE
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_EQUITY TEQ
        ON TEQ.I_CODE = T.I_CODE
       AND TEQ.A_TYPE = T.A_TYPE
       AND TEQ.M_TYPE = T.M_TYPE
      /*LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_OTC_TRADE TRD
        ON TRD.I_CODE = T.I_CODE
       AND TRD.A_TYPE = T.A_TYPE
       AND TRD.M_TYPE = T.M_TYPE
       AND TRD.INSSTATUS = 999
       AND TRD.ORDSTATUS = 4
       AND TRD.TRDTYPE = '0170000'*/
      --因过程中有两个相同别名的导致没取到规模，修改别名
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_OTC_TRADE TRDD
        ON TRDD.I_CODE = T.I_CODE
       AND TRDD.A_TYPE = T.A_TYPE
       AND TRDD.M_TYPE = T.M_TYPE
       AND TRDD.INSSTATUS = 999
       AND TRDD.ORDSTATUS = 4
       AND TRDD.TRDTYPE = '0170000'
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_DICT_MULT_LANG DI
        ON DI.DICT_TYPE = 'dict'
       AND DI.DICT_SUB_TYPE = 'Industry4HuaXing_' || COALESCE(BTE.HX_INVESTCATEGORY, TE.HX_INVESTCATEGORY)
       AND DI.DICT_KEY = COALESCE(BTE.HX_INVESTBROHEADING, TE.HX_INVESTBROHEADING)
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TBSI_ACCRUALDETAIL AD
        ON AD.I_CODE = COALESCE(TB.I_CODE, T.I_CODE)
       AND AD.A_TYPE = COALESCE(TB.A_TYPE, T.A_TYPE)
       AND AD.M_TYPE = COALESCE(TB.M_TYPE, T.M_TYPE)
       AND AD.AD_STARTDATE <= P.BEGDATE
       AND AD.AD_ENDDATE > P.BEGDATE
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TFND TF
        ON TF.I_CODE = T.I_CODE
       AND TF.A_TYPE = T.A_TYPE
       AND TF.M_TYPE = T.M_TYPE
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TFND_NAV TN
        ON TN.I_CODE = T.I_CODE
       AND TN.A_TYPE = T.A_TYPE
       AND TN.M_TYPE = T.M_TYPE
       AND TN.BEG_DATE <= P.BEGDATE
       AND TN.END_DATE > P.BEGDATE
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_EQUITY_NAV TEN
        ON TEN.I_CODE = T.I_CODE
       AND TEN.A_TYPE = T.A_TYPE
       AND TEN.M_TYPE = T.M_TYPE
       AND TEN.BEG_DATE <= P.BEGDATE
       AND TEN.END_DATE > P.BEGDATE
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TCB_BOND_EVAL BE
        ON BE.I_CODE = TTB.I_CODE
       AND BE.A_TYPE = TTB.A_TYPE
       AND BE.M_TYPE = TTB.M_TYPE
       AND BE.BEG_DATE <= TO_CHAR(TO_DATE(V_MONTH_END_DATEID,'YYYYMMDD'),'YYYY-MM-DD')
       AND BE.END_DATE > TO_CHAR(TO_DATE(V_MONTH_END_DATEID,'YYYYMMDD'),'YYYY-MM-DD')
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TCB_BOND_EVAL TBE
        ON TBE.I_CODE = TB.I_CODE
       AND TBE.A_TYPE = TB.A_TYPE
       AND TBE.M_TYPE = TB.M_TYPE
       AND TBE.BEG_DATE <= TO_CHAR(TO_DATE(V_MONTH_END_DATEID,'YYYYMMDD'),'YYYY-MM-DD')
       AND TBE.END_DATE > TO_CHAR(TO_DATE(V_MONTH_END_DATEID,'YYYYMMDD'),'YYYY-MM-DD')
      LEFT JOIN (SELECT E.I_CODE, E.A_TYPE, E.M_TYPE, COUNT(1) ECOUNT
                   FROM RRP_MDL.O_IOL_IBMS_TTRD_INSTRUMENT_EXTEND E
                  WHERE E.A_TYPE IN ('SPT_BD','SPT_ABS','SPT_CB')
                    AND E.EXTEND_TYPE = '04'
                  GROUP BY E.I_CODE, E.A_TYPE, E.M_TYPE) E
        ON E.I_CODE = COALESCE(TB.I_CODE, T.I_CODE)
       AND E.A_TYPE = COALESCE(TB.A_TYPE, T.A_TYPE)
       AND E.M_TYPE = COALESCE(TB.M_TYPE, T.M_TYPE)
      LEFT JOIN (SELECT E.I_CODE, E.A_TYPE, E.M_TYPE, SUM(E.VOLUME) AMOUNT --ADD BY LIP 20241101 根据同业提供的脚本调整
                   FROM RRP_MDL.O_IOL_IBMS_TTRD_INSTRUMENT_EXTEND E
                  WHERE E.EXTEND_TYPE = '03'
                    AND E.BEG_DATE <= TO_CHAR(TO_DATE(V_MONTH_END_DATEID,'YYYYMMDD'),'YYYY-MM-DD')
                  GROUP BY E.I_CODE, E.A_TYPE, E.M_TYPE) E1
        ON E1.I_CODE = COALESCE(TB.I_CODE, T.I_CODE)
       AND E1.A_TYPE = COALESCE(TB.A_TYPE, T.A_TYPE)
       AND E1.M_TYPE = COALESCE(TB.M_TYPE, T.M_TYPE)
      LEFT JOIN (SELECT T.I_CODE,
                        T.A_TYPE,
                        T.M_TYPE,
                        T.PARTYNAME,
                        T.PARTYID,
                        MAX(NCD.ANNUAL_RATE) ANNUAL_RATE
                   FROM RRP_MDL.O_IOL_IBMS_TTRD_NCD_RESULT_DETAILS T
                   LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_OTC_TRADE TRD
                     ON T.REF_SYSORDID = TRD.SYSORDID
                   LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_OTC_TRADE PT
                     ON PT.SYSORDID = TRD.REF_SYSORDID
                    AND T.SYSORDID = PT.SYSORDID
                   LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_OTC_NCD NCD
                     ON PT.INTORDID = NCD.INTORDID
                    AND T.I_CODE = NCD.I_CODE
                    AND T.A_TYPE = NCD.A_TYPE
                    AND T.M_TYPE = NCD.M_TYPE
                  WHERE PT.INSSTATUS = 999
                    AND PT.ORDSTATUS = 4
                  GROUP BY T.I_CODE,
                           T.A_TYPE,
                           T.M_TYPE,
                           T.PARTYNAME,
                           T.PARTYID) ND
        ON ND.I_CODE = T.I_CODE
       AND ND.A_TYPE = T.A_TYPE
       AND ND.M_TYPE = T.M_TYPE
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TINSTRUMENT_COMP_GRADE NCG
        ON NCG.COMP_ID = TO_CHAR(ND.PARTYID)
      LEFT JOIN IBMS_TTRD_BLC_SECU_OBJ BB
        ON BB.I_CODE = T.I_CODE
       AND BB.A_TYPE = T.A_TYPE
       AND BB.M_TYPE = T.M_TYPE
     WHERE T.P_TYPE IN ('0000','1100','1200','0201','0202','0158','0150','0700','0703','0706','0170','0125','0121','0179',
                        '2000')--ADD BY LIP 20240219 增加'0179'银团同业借款数据 --MOD BY LIP 20250715 增加2000债权借贷
       AND NOT EXISTS (SELECT 1
              FROM ICODE_CHG IC
             WHERE IC.U_I_CODE = T.I_CODE
               AND IC.U_A_TYPE = T.A_TYPE
               AND IC.U_M_TYPE = T.M_TYPE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --更新同业部分的发行机构的客户号 --MOD BY LIP 20250814
    V_STEP      := V_STEP + 1;
    V_STEP_DESC := '更新同业部分的交易对手客户号';
    V_STARTTIME := SYSDATE;
    MERGE INTO (SELECT * FROM RRP_EAST.EAST5_1002_JRGJXXB_TY WHERE TRIM(CORE_SYS_CUSTOMER_CODE) IS NULL) TA
    USING (SELECT CUST_ID,CUST_NAME,ROW_NUMBER() OVER(PARTITION BY CUST_NAME ORDER BY CUST_STATUS_CD,OPEN_ACCT_DT DESC) RN
             FROM RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO
            WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) TB
       ON (TB.CUST_NAME = TRIM(TA.FXJGMC) AND TB.RN = 1)
     WHEN MATCHED THEN UPDATE SET
       TA.CORE_SYS_CUSTOMER_CODE = TB.CUST_ID;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP      := V_STEP + 1;
    V_STEP_DESC :='同业数据-插入同业中间表';
    V_STARTTIME := SYSDATE;
    --同业
    INSERT INTO RRP_EAST.EAST5_1002_JRGJXXB_TY_R
      (RID --数据主键
      ,JRXKZH --金融许可证号
      ,NBJGH --内部机构号
      ,YHJGMC --银行机构名称
      ,JRGJBH --金融工具编号
      ,JRGJMC --金融工具名称
      ,ZCLX --资产类型
      ,BZ --币种
      ,FXJG --发行价格
      ,FXZGM --发行总规模
      ,FXJGMC --发行机构名称
      ,FXJGDM --发行机构代码
      ,FXGB --发行国别
      ,FXRQ --发行日期
      ,DQRQ --到期日期
      ,LLLX --利率类型
      ,SJLL --实际利率
      ,HQBS --含权标识
      ,ZJPGJG --最近评估价格
      ,PGJGRQ --评估价格日期
      ,JCZCBH --基础资产编号
      ,JCZCMC --基础资产名称
      ,JCZCGM --基础资产规模
      ,JCZCZB --基础资产占比
      ,JCZCPJ --基础资产评级
      ,JCZCPJJG --基础资产评级机构
      ,JCZCKHMC --基础资产客户名称
      ,JCZCKHGJ --基础资产客户国家
      ,JCZCKHPJ --基础资产客户评级
      ,JCZCKHPJJG --基础资产客户评级机构
      ,JCZCHKHHY --基础资产客户行业
      ,ZZTXLX --最终投向类型
      ,ZZTXHY --最终投向行业
      ,BBZ --备注
      ,CJRQ --采集日期
      ,DEPT_NO --部门编号
      ,SRC_SYS_ID --来源系统ID
      ,ISSUED_NO --填报机构
      ,ORG_NO --报送机构
      ,ADDRESS --归属地
      ,GSFZJG --归属分支机构
      ,DATA_SRC_DESC --数据来源中文
       )
    SELECT SYS_GUID()                                  AS RID --数据主键
          ,B.FIN_PERMIT_NO                             AS JRXKZH --金融许可证号
          ,NVL(TRIM(B1.ORG_ID1),'896')                AS NBJGH --内部机构号
          ,B.ORG_NM                                    AS YHJGMC --银行机构名称
          ,A.JRGJBH                                    AS JRGJBH --金融工具编号
          ,A.JRGJMC                                    AS JRGJMC --金融工具名称
          ,A.ZCLX                                      AS ZCLX --资产类型
          ,A.BZ                                        AS BZ --币种
          ,A.FXJG                                      AS FXJG --发行价格
          ,A.FXZGM                                     AS FXZGM --发行总规模
          --,A.FXJGMC                                    AS FXJGMC --发行机构名称
          --,NVL(TRIM(D.SOCI_CRDT_CD), F.SOCI_CRDT_CD)   AS FXJGDM --发行机构代码
          ,COALESCE(TRIM(A.FXJGMC),TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)) AS FXJGMC --发行机构名称
          ,COALESCE(TRIM(D.SOCI_CRDT_CD),TRIM(D.ORGNZ_CD),TRIM(F.SOCI_CRDT_CD),TRIM(F.ORGNZ_CD),TRIM(A.FXJGDM)) AS FXJGDM --发行机构代码
          ,NVL(TRIM(D.CTY_RG_CD), F.CTY_RG_CD)         AS FXGB --发行国别
          ,TRIM(A.FXRQ)                                AS FXRQ --发行日期
          ,TRIM(A.DQRQ)                                AS DQRQ --到期日期
          ,A.LLLX                                      AS LLLX --利率类型
          ,A.SJLL                                      AS SJLL --实际利率
          ,A.HQBS                                      AS HQBS --含权标识
          ,A.ZJPGJG                                    AS ZJPGJG --最近评估价格
          ,TRIM(A.PGJGRQ)                              AS PGJGRQ --评估价格日期
          ,A.JCZCBH                                    AS JCZCBH --基础资产编号
          ,A.JCZCMC                                    AS JCZCMC --基础资产名称
          ,A.JCZCGM                                    AS JCZCGM --基础资产规模
          ,A.JCZCZB                                    AS JCZCZB --基础资产占比
          ,A.JCZCPJ                                    AS JCZCPJ --基础资产评级
          ,A.JCZCPJJG                                  AS JCZCPJJG --基础资产评级机构
          ,A.JCZCKHMC                                  AS JCZCKHMC --基础资产客户名称
          ,A.JCZCKHGJ                                  AS JCZCKHGJ --基础资产客户国家
          ,A.JCZCKHPJ                                  AS JCZCKHPJ --基础资产客户评级
          ,TRIM(A.JCKHPJJG)                            AS JCZCKHPJJG --基础资产客户评级机构
          --,A.JCZCHKHHY || '_' || G.VALUE_NAME /*A.JCZCHKHHY*/ AS JCZCHKHHY --基础资产客户行业
          ,CASE WHEN REGEXP_LIKE(SUBSTR(A.JCZCHKHHY,1,5),'^[A-Z][0-9]{4}$') THEN SUBSTR(A.JCZCHKHHY,1,5)
                WHEN REGEXP_LIKE(TRIM(D.INDUS_TYPE_CD_CRDTC),'^[A-Z][0-9]{4}$') THEN TRIM(D.INDUS_TYPE_CD_CRDTC)
                WHEN REGEXP_LIKE(TRIM(D.INDUS_TYPE_CD),'^[A-Z][0-9]{4}$') THEN TRIM(D.INDUS_TYPE_CD)
                WHEN REGEXP_LIKE(TRIM(F.INDUS_TYPE_CD_CRDTC),'^[A-Z][0-9]{4}$') THEN TRIM(F.INDUS_TYPE_CD_CRDTC)
                WHEN REGEXP_LIKE(TRIM(F.INDUS_TYPE_CD),'^[A-Z][0-9]{4}$') THEN TRIM(F.INDUS_TYPE_CD)
            END                                        AS JCZCHKHHY --基础资产客户行业
          ,A.ZZTXLX                                    AS ZZTXLX --最终投向类型
          --,A.ZZTXHY                                    AS ZZTXHY --最终投向行业
          ,CASE WHEN REGEXP_LIKE(SUBSTR(A.ZZTXHY,1,5),'^[A-Z][0-9]{4}$') THEN SUBSTR(A.ZZTXHY,1,5)
                WHEN REGEXP_LIKE(TRIM(D.INDUS_TYPE_CD_CRDTC),'^[A-Z][0-9]{4}$') THEN TRIM(D.INDUS_TYPE_CD_CRDTC)
                WHEN REGEXP_LIKE(TRIM(D.INDUS_TYPE_CD),'^[A-Z][0-9]{4}$') THEN TRIM(D.INDUS_TYPE_CD)
                WHEN REGEXP_LIKE(TRIM(F.INDUS_TYPE_CD_CRDTC),'^[A-Z][0-9]{4}$') THEN TRIM(F.INDUS_TYPE_CD_CRDTC)
                WHEN REGEXP_LIKE(TRIM(F.INDUS_TYPE_CD),'^[A-Z][0-9]{4}$') THEN TRIM(F.INDUS_TYPE_CD)
            END                                        AS ZZTXHY --最终投向行业
          ,A.BZH                                       AS BBZ --备注
          ,A.CJRQ                                      AS CJRQ --采集日期
          ,'000'                                       AS DEPT_NO --部门编号
          ,'01'                                        AS SRC_SYS_ID --来源系统ID
          ,NVL(TRIM(A.NBJGH),'896')                   AS ISSUED_NO --填报机构
          ,'000000'                                    AS ORG_NO --报送机构
          ,''                                          AS ADDRESS --归属地
          ,B.GSFZJG                                    AS GSFZJG --归属分支机构
          ,A.DATA_SRC_DESC                             AS DATA_SRC_DESC --数据来源中文
      FROM RRP_EAST.EAST5_1002_JRGJXXB_TY A
      LEFT JOIN RRP_MDL.ORG_CONFIG B1 --机构映射表
        ON B1.ORG_ID = A.NBJGH
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(TRIM(B1.ORG_ID1),'896')
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO D --对公客户基本信息
        ON D.CUST_ID = TRIM(A.CORE_SYS_CUSTOMER_CODE)
       AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_IML_PTY_SPV_CUST_INFO E --SPV客户信息
        ON E.SPV_CUST_ID = TRIM(A.CORE_SYS_CUSTOMER_CODE)
       AND E.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
       AND E.END_DT >= TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO F --对公客户基本信息
        ON F.CUST_ID = TRIM(E.PARTY_ID)
       AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.CODE_MAP G --码值表
        ON G.SRC_VALUE_CODE = A.JCZCHKHHY
       AND G.SRC_CLASS_CODE = 'P0003' --行业类别
       AND G.TAR_CLASS_CODE = 'P0003'
       AND G.MOD_FLG = 'EAST'
     WHERE A.CJRQ = V_MONTH_END_DATEID;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP      := V_STEP + 1;
    V_STEP_DESC := '资金中间表数据-插入目标表';
    V_STARTTIME := SYSDATE;
    --资金
    INSERT INTO RRP_EAST.EAST5_1002_JRGJXXB
      (RID, --数据主键
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       YHJGMC, --银行机构名称
       JRGJBH, --金融工具编号
       JRGJMC, --金融工具名称
       ZCLX, --资产类型
       BZ, --币种
       FXJG, --发行价格
       FXZGM, --发行总规模
       FXJGMC, --发行机构名称
       FXJGDM, --发行机构代码
       FXGB, --发行国别
       FXRQ, --发行日期
       DQRQ, --到期日期
       LLLX, --利率类型
       SJLL, --实际利率
       HQBS, --含权标识
       ZJPGJG, --最近评估价格
       PGJGRQ, --评估价格日期
       JCZCBH, --基础资产编号
       JCZCMC, --基础资产名称
       JCZCGM, --基础资产规模
       JCZCZB, --基础资产占比
       JCZCPJ, --基础资产评级
       JCZCPJJG, --基础资产评级机构
       JCZCKHMC, --基础资产客户名称
       JCZCKHGJ, --基础资产客户国家
       JCZCKHPJ, --基础资产客户评级
       JCZCKHPJJG, --基础资产客户评级机构
       JCZCHKHHY, --基础资产客户行业
       ZZTXLX, --最终投向类型
       ZZTXHY, --最终投向行业
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       GSFZJG,--归属分支机构
       TY_ZJ_FLAG --同业资金标志
       )
    SELECT SYS_GUID()                                AS RID,       --数据主键
           MAX(T.JRXKZH)                             AS JRXKZH,    --金融许可证号
           MAX(T.NBJGH)                              AS NBJGH,     --内部机构号
           MAX(T.YHJGMC)                             AS YHJGMC,    --银行机构名称
           T.JRGJBH                                  AS JRGJBH,    --金融工具编号
           T.JRGJMC                                  AS JRGJMC,    --金融工具名称
           T.ZCLX                                    AS ZCLX,      --资产类型
           MAX(T.BZ)                                 AS BZ,        --币种
           --MAX(T.FXJG)                               AS FXJG,      --发行价格
           NVL(MAX(T.FXJG),0)                        AS FXJG,      --发行价格
           MAX(T.FXZGM)                              AS FXZGM,     --发行总规模
           --MAX(T.FXJGMC)                             AS FXJGMC,    --发行机构名称
           --MOD BY LIP 20230506 当对公客户的名称都是中文名时，将其中的()改为（）
           MAX(CASE WHEN REGEXP_REPLACE(TRIM(T.FXJGMC),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(T.FXJGMC),'(','（'),')','）'),' ','')
                ELSE TRIM(T.FXJGMC)
            END)                                     AS FXJGMC,    --发行机构名称
           MAX(T.FXJGDM)                             AS FXJGDM,    --发行机构代码
           MAX(T.FXGB)                               AS FXGB,      --发行国别
           NVL(MAX(T.FXRQ),'99991231')               AS FXRQ,      --发行日期
           NVL(MAX(T.DQRQ),'99991231')               AS DQRQ,      --到期日期
           MAX(T.LLLX)                               AS LLLX,      --利率类型
           --MAX(T.SJLL)                               AS SJLL,      --实际利率
           NVL(MAX(T.SJLL),0)                        AS SJLL,      --实际利率
           MAX(T.HQBS)                               AS HQBS,      --含权标识
           NVL(MAX(T.ZJPGJG),0)                      AS ZJPGJG,    --最近评估价格
           --MAX(T.PGJGRQ)                             AS PGJGRQ,    --评估价格日期
           NVL(MAX(T.PGJGRQ),'99991231')             AS PGJGRQ,    --评估价格日期
           MAX(T.JCZCBH)                             AS JCZCBH,    --基础资产编号
           --MAX(T.JCZCMC)                             AS JCZCMC,    --基础资产名称
           --SUM(T.JCZCGM)                             AS JCZCGM,    --基础资产规模
           --SUM(T.JCZCZB)                             AS JCZCZB,    --基础资产占比
           MAX(CASE WHEN (T.ZCLX LIKE '%回购'
                     OR T.ZCLX LIKE '%拆放同业'
                     OR T.ZCLX LIKE '%同业拆入'
                     OR T.ZCLX LIKE '%债券借出'
                     OR T.ZCLX LIKE '%债券借入'
                     )
                  THEN T.JRGJMC
                ELSE T.JCZCMC
           END)                                       AS JCZCMC,    --基础资产名称  --modify by tangan at 20221227
           NVL(SUM(T.JCZCGM),0)                      AS JCZCGM,    --基础资产规模
           NVL(SUM(T.JCZCZB),0)                      AS JCZCZB,    --基础资产占比
           MAX(T.JCZCPJ)                             AS JCZCPJ,    --基础资产评级
           MAX(T.JCZCPJJG)                           AS JCZCPJJG,  --基础资产评级机构
           --MAX(T.JCZCKHMC)                           AS JCZCKHMC,  --基础资产客户名称
           --MOD BY LIP 20230506 当对公客户的名称都是中文名时，将其中的()改为（）
           MAX(CASE WHEN REGEXP_REPLACE(TRIM(T.JCZCKHMC),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(T.JCZCKHMC),'(','（'),')','）'),' ','')
                ELSE TRIM(T.JCZCKHMC)
            END)                                     AS JCZCKHMC,  --基础资产客户名称
           MAX(T.JCZCKHGJ)                           AS JCZCKHGJ,  --基础资产客户国家
           MAX(T.JCZCKHPJ)                           AS JCZCKHPJ,  --基础资产客户评级
           MAX(TRIM(T.JCZCKHPJJG))                   AS JCZCKHPJJG,--基础资产客户评级机构
           --MAX(T.JCZCHKHHY)                        AS JCZCHKHHY, --基础资产客户行业
           MAX(REPLACE(CASE WHEN INSTR(T.JCZCHKHHY,'_') > 0 THEN
                                 SUBSTR(T.JCZCHKHHY,1,INSTR(T.JCZCHKHHY,'_')-1)
                            ELSE T.JCZCHKHHY
                        END
                       ,'-',''))                     AS JCZCHKHHY, --基础资产客户行业
           MAX(TRIM(T.ZZTXLX))                       AS ZZTXLX,    --最终投向类型
           --MAX(T.ZZTXHY)                           AS ZZTXHY,    --最终投向行业
           MAX(REPLACE(CASE WHEN INSTR(T.ZZTXHY,'_') > 0 THEN
                                 SUBSTR(T.ZZTXHY,1,INSTR(T.ZZTXHY,'_')-1)
                            ELSE T.ZZTXHY
                        END
                       ,'-',''))                     AS ZZTXHY,    --最终投向行业
           MAX(T.BBZ)                                AS BBZ,       --备注
           T.CJRQ                                    AS CJRQ,      --采集日期
           MAX(T.DEPT_NO)                            AS DEPT_NO,   --部门编号
           MAX(T.SRC_SYS_ID)                         AS SRC_SYS_ID,--来源系统ID
           --MAX(T.ISSUED_NO)                          AS ISSUED_NO, --填报机构
           '000000'                                  AS ISSUED_NO, --填报机构
           MAX(T.ORG_NO)                             AS ORG_NO,    --报送机构
           MAX(T.ADDRESS)                            AS ADDRESS,   --归属地
           MAX(T.GSFZJG)                             AS GSFZJG,    --归属分支机构
           --'资金'                                    AS TY_ZJ_FLAG --同业资金标志
           MAX(T.ISSUED_NO)                          AS TY_ZJ_FLAG --同业资金标志
      FROM RRP_EAST.EAST5_1002_JRGJXXB_ZJ_R T
     GROUP BY T.JRGJBH, T.JRGJMC, T.ZCLX, T.CJRQ;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP      := V_STEP + 1;
    V_STEP_DESC := '同业中间数据-插入目标表';
    V_STARTTIME := SYSDATE;
    --同业
    INSERT INTO RRP_EAST.EAST5_1002_JRGJXXB
      (RID, --数据主键
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       YHJGMC, --银行机构名称
       JRGJBH, --金融工具编号
       JRGJMC, --金融工具名称
       ZCLX, --资产类型
       BZ, --币种
       FXJG, --发行价格
       FXZGM, --发行总规模
       FXJGMC, --发行机构名称
       FXJGDM, --发行机构代码
       FXGB, --发行国别
       FXRQ, --发行日期
       DQRQ, --到期日期
       LLLX, --利率类型
       SJLL, --实际利率
       HQBS, --含权标识
       ZJPGJG, --最近评估价格
       PGJGRQ, --评估价格日期
       JCZCBH, --基础资产编号
       JCZCMC, --基础资产名称
       JCZCGM, --基础资产规模
       JCZCZB, --基础资产占比
       JCZCPJ, --基础资产评级
       JCZCPJJG, --基础资产评级机构
       JCZCKHMC, --基础资产客户名称
       JCZCKHGJ, --基础资产客户国家
       JCZCKHPJ, --基础资产客户评级
       JCZCKHPJJG, --基础资产客户评级机构
       JCZCHKHHY, --基础资产客户行业
       ZZTXLX, --最终投向类型
       ZZTXHY, --最终投向行业
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       GSFZJG,--归属分支机构
       TY_ZJ_FLAG --同业资金标志
      )
    SELECT SYS_GUID()                                AS RID,       --数据主键
           T.JRXKZH                                  AS JRXKZH,    --金融许可证号
           T.NBJGH                                   AS NBJGH,     --内部机构号
           T.YHJGMC                                  AS YHJGMC,    --银行机构名称
           T.JRGJBH                                  AS JRGJBH,    --金融工具编号
           T.JRGJMC                                  AS JRGJMC,    --金融工具名称
           T.ZCLX                                    AS ZCLX,      --资产类型
           T.BZ                                      AS BZ,        --币种
           NVL(T.FXJG,0)                             AS FXJG,      --发行价格
           T.FXZGM                                   AS FXZGM,     --发行总规模
           --T.FXJGMC                                  AS FXJGMC,    --发行机构名称
           --MOD BY LIP 20230506 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(T.FXJGMC),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(T.FXJGMC),'(','（'),')','）'),' ','')
                ELSE TRIM(T.FXJGMC)
            END                                      AS FXJGMC,    --发行机构名称
           T.FXJGDM                                  AS FXJGDM,    --发行机构代码
           T.FXGB                                    AS FXGB,      --发行国别
           NVL(T.FXRQ,'99991231')                    AS FXRQ,      --发行日期
           NVL(T.DQRQ,'99991231')                    AS DQRQ,      --到期日期
           T.LLLX                                    AS LLLX,      --利率类型
           --T.SJLL                                    AS SJLL,      --实际利率
           NVL(T.SJLL,0)                             AS SJLL,      --实际利率
           T.HQBS                                    AS HQBS,      --含权标识
           --T.ZJPGJG                                  AS ZJPGJG,    --最近评估价格
           NVL(T.ZJPGJG,0)                           AS ZJPGJG,    --最近评估价格
           NVL(T.PGJGRQ,'99991231')                  AS PGJGRQ,    --评估价格日期
           T.JCZCBH                                  AS JCZCBH,    --基础资产编号
           T.JCZCMC                                  AS JCZCMC,    --基础资产名称
           --CASE WHEN TRIM(T.JCZCBH) IS NULL THEN NULL
           CASE WHEN TRIM(T.JCZCBH) IS NULL THEN '0'
                ELSE NVL(TRIM(B.ZMYE), 0)
            END                                      AS JCZCGM,    --基础资产规模
           --CASE WHEN TRIM(T.JCZCBH) IS NULL THEN NULL
           /*CASE WHEN TRIM(T.JCZCBH) IS NULL THEN 0
                ELSE CASE WHEN T.FXZGM = 0 THEN 0
                          WHEN NVL(TRIM(B.ZMYE), 0) / T.FXZGM > 1 THEN 100
                          ELSE NVL(TRIM(B.ZMYE), 0) / T.FXZGM * 100
                      END
            END                                      AS JCZCZB,    --基础资产占比*/
           CASE WHEN TRIM(T.JCZCBH) IS NULL THEN 0
                WHEN T.ZCLX LIKE '%同业存单发行%' THEN (--MODIFY BY TANGAN AT 20230104
                  CASE WHEN NVL(TRIM(C.ZJCZCGM),0) = 0 THEN 0
                       ELSE NVL(TRIM(B.ZMYE), 0) / C.ZJCZCGM * 100
                   END)
                ELSE CASE WHEN T.FXZGM = 0 THEN 0
                          WHEN NVL(TRIM(B.ZMYE), 0) / T.FXZGM > 1 THEN 100
                          ELSE NVL(TRIM(B.ZMYE), 0) / T.FXZGM * 100
                      END
            END                                      AS JCZCZB,    --基础资产占比
           T.JCZCPJ                                  AS JCZCPJ,    --基础资产评级
           T.JCZCPJJG                                AS JCZCPJJG,  --基础资产评级机构
           --T.JCZCKHMC                                AS JCZCKHMC,  --基础资产客户名称
           --MOD BY LIP 20221017 基础资产名称直接取金融工具名称
           --NVL(TRIM(T.JCZCKHMC),TRIM(T.JRGJMC))      AS JCZCKHMC,  --基础资产客户名称
           --MOD BY LIP 20230506 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN TRIM(T.JCZCKHMC) IS NOT NULL
                     AND REGEXP_REPLACE(TRIM(T.JCZCKHMC),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(T.JCZCKHMC),'(','（'),')','）'),' ','')
                WHEN TRIM(T.JCZCKHMC) IS NOT NULL THEN TRIM(T.JCZCKHMC)
                WHEN TRIM(T.JRGJMC) IS NOT NULL
                     AND REGEXP_REPLACE(TRIM(T.JRGJMC),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(T.JRGJMC),'(','（'),')','）'),' ','')
                WHEN TRIM(T.JRGJMC) IS NOT NULL THEN TRIM(T.JRGJMC)
            END                                      AS JCZCKHMC,  --基础资产客户名称
           T.JCZCKHGJ                                AS JCZCKHGJ,  --基础资产客户国家
           T.JCZCKHPJ                                AS JCZCKHPJ,  --基础资产客户评级
           TRIM(T.JCZCKHPJJG)                        AS JCZCKHPJJG,--基础资产客户评级机构
           --T.JCZCHKHHY                               AS JCZCHKHHY, --基础资产客户行业
           REPLACE(CASE WHEN INSTR(T.JCZCHKHHY,'_') > 0
                        THEN SUBSTR(T.JCZCHKHHY,1,INSTR(T.JCZCHKHHY,'_')-1)
                        ELSE T.JCZCHKHHY
                    END,'-','')                      AS JCZCHKHHY, --基础资产客户行业
           TRIM(T.ZZTXLX)                            AS ZZTXLX,    --最终投向类型
           --T.ZZTXHY                                  AS ZZTXHY,    --最终投向行业
           REPLACE(CASE WHEN INSTR(T.ZZTXHY,'_') > 0
                        THEN SUBSTR(T.ZZTXHY,1,INSTR(T.ZZTXHY,'_')-1)
                        ELSE T.ZZTXHY
                    END,'-','')                      AS ZZTXHY,    --最终投向行业
           T.BBZ                                     AS BBZ,       --备注
           T.CJRQ                                    AS CJRQ,      --采集日期
           T.DEPT_NO                                 AS DEPT_NO,   --部门编号
           T.SRC_SYS_ID                              AS SRC_SYS_ID,--来源系统ID
           '000000'                                  AS ISSUED_NO, --填报机构
           T.ORG_NO                                  AS ORG_NO,    --报送机构
           T.ADDRESS                                 AS ADDRESS,   --归属地
           T.GSFZJG                                  AS GSFZJG,    --归属分支机构
           --'同业'                                    AS TY_ZJ_FLAG --同业资金标志
           T.ISSUED_NO                               AS TY_ZJ_FLAG --同业资金标志
      FROM RRP_EAST.EAST5_1002_JRGJXXB_TY_R T
      LEFT JOIN (/*SELECT JRGJBH,JRGJMC,CJRQ,SUM(ZMYE) AS ZMYE*/
                 SELECT JRGJBH,JRGJMC,CJRQ,
                        --MOD BY LIP 20220826 根据孙若真反馈邮件修改：工具表中，发行同业存单的资产规模都是负数，应该改成正数
                        SUM(ABS(ZMYE)) AS ZMYE
                   FROM RRP_EAST.EAST5_1004_ZYZJYWYEB_TY_R
                  GROUP BY JRGJBH, JRGJMC, CJRQ) B
        ON B.JRGJBH = T.JRGJBH
       AND B.JRGJMC = T.JRGJMC
       AND B.CJRQ = T.CJRQ
      LEFT JOIN ( --根据陈晓桂缺陷BUG_069722反馈修改：发行同业存单的基础资产占比是用基础资产规模除以发行总规模，这样同一支同业存单的基础资产占比合计就会小于100，需要改成基础资产规模除以同一支同业存单的基础资产规模合计
                SELECT AA.JCZCBH,SUM(AA.JCZCGM) AS ZJCZCGM
                  FROM (--处理同业存单发行的基础资产规模
                  SELECT T.JRGJBH
                        ,T.JRGJMC
                        ,T.ZCLX
                        ,T.JCZCBH
                        ,CASE WHEN TRIM(T.JCZCBH) IS NULL THEN '0'
                              ELSE NVL(TRIM(B.ZMYE), 0)
                          END AS JCZCGM
                    FROM RRP_EAST.EAST5_1002_JRGJXXB_TY_R T
                    LEFT JOIN (SELECT JRGJBH,JRGJMC,CJRQ,SUM(ABS(ZMYE)) AS ZMYE
                                 FROM RRP_EAST.EAST5_1004_ZYZJYWYEB_TY_R
                                GROUP BY JRGJBH,JRGJMC,CJRQ) B
                      ON B.JRGJBH = T.JRGJBH
                     AND B.JRGJMC = T.JRGJMC
                     AND B.CJRQ = T.CJRQ) AA
                 WHERE AA.ZCLX LIKE '%同业存单发行%'
                   AND TRIM(AA.JCZCBH) IS NOT NULL
                 GROUP BY AA.JCZCBH) C
       ON C.JCZCBH = T.JCZCBH;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP      := V_STEP + 1;
    V_STEP_DESC := '委托同业代付数据-插入目标表';
    V_STARTTIME := SYSDATE;
    --委托同业代付数据
    INSERT INTO RRP_EAST.EAST5_1002_JRGJXXB
      (RID, --数据主键
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       YHJGMC, --银行机构名称
       JRGJBH, --金融工具编号
       JRGJMC, --金融工具名称
       ZCLX, --资产类型
       BZ, --币种
       FXJG, --发行价格
       FXZGM, --发行总规模
       FXJGMC, --发行机构名称
       FXJGDM, --发行机构代码
       FXGB, --发行国别
       FXRQ, --发行日期
       DQRQ, --到期日期
       LLLX, --利率类型
       SJLL, --实际利率
       HQBS, --含权标识
       ZJPGJG, --最近评估价格
       PGJGRQ, --评估价格日期
       JCZCBH, --基础资产编号
       JCZCMC, --基础资产名称
       JCZCGM, --基础资产规模
       JCZCZB, --基础资产占比
       JCZCPJ, --基础资产评级
       JCZCPJJG, --基础资产评级机构
       JCZCKHMC, --基础资产客户名称
       JCZCKHGJ, --基础资产客户国家
       JCZCKHPJ, --基础资产客户评级
       JCZCKHPJJG, --基础资产客户评级机构
       JCZCHKHHY, --基础资产客户行业
       ZZTXLX, --最终投向类型
       ZZTXHY, --最终投向行业
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       GSFZJG,--归属分支机构
       TY_ZJ_FLAG --同业资金标志
      )
    SELECT SYS_GUID()                                      AS RID, --数据主键
           B.FIN_PERMIT_NO                                 AS JRXKZH, --金融许可证号
           NVL(TRIM(C.ORG_ID1),'800')                      AS NBJGH, --内部机构号
           B.ORG_NM                                        AS YHJGMC, --银行机构名称
           A.FIN_INST_ID                                   AS JRGJBH, --金融工具编号
           TRIM(A.FIN_INST_NM)                             AS JRGJMC, --金融工具名称
           CODE.TAR_VALUE_NAME                             AS ZCLX, --资产类型
           A.CUR                                           AS BZ, --币种
           ABS(A.ISU_PRC)                                  AS FXJG, --发行价格
           ABS(A.ISU_TOT_SCALE)                            AS FXZGM, --发行总规模
           --A.ISU_ORG_NM                                    AS FXJGMC, --发行机构名称
           --MOD BY LIP 20230506 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(A.ISU_ORG_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(A.ISU_ORG_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(A.ISU_ORG_NM)
            END                                            AS FXJGMC, --发行机构名称
           A.ISU_ORG_ID                                    AS FXJGDM, --发行机构代码
           A.ISU_CTRY_CD                                   AS FXGB, --发行国别
           NVL(A.ISU_DT,'99991231')                        AS FXRQ, --发行日期
           NVL(A.EXP_DT,'99991231')                        AS DQRQ, --到期日期
           --CODE3.EAST_VALUE_NAME                           AS LLLX, --利率类型
           A.RATE_TYP                                      AS LLLX, --利率类型
           ABS(A.ACT_RATE)                                 AS SJLL, --实际利率
           CODE1.TAR_VALUE_NAME                            AS HQBS, --含权标识
           ABS(A.RCTLY_ASES_PRC)                           AS ZJPGJG, --最近评估价格
           NVL(A.ASES_PRC_DT,'99991231')                  AS PGJGRQ, --评估价格日期
           A.BASE_AST_ID                                   AS JCZCBH, --基础资产编号
           TRIM(A.BASE_AST_NM)                             AS JCZCMC, --基础资产名称
           ABS(A.BASE_AST_SCALE)                           AS JCZCGM, --基础资产规模
           ABS(A.BASE_AST_PCT)                             AS JCZCZB, --基础资产占比
           TRIM(A.BASE_AST_RTG)                            AS JCZCPJ, --基础资产评级
           TRIM(A.BASE_AST_RTG_ORG_NM)                     AS JCZCPJJG, --基础资产评级机构
           --A.BASE_AST_CUST_NM                              AS JCZCKHMC, --基础资产客户名称
           --MOD BY LIP 20230506 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(A.BASE_AST_CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(A.BASE_AST_CUST_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(A.BASE_AST_CUST_NM)
            END                                            AS JCZCKHMC, --基础资产客户名称
           TRIM(A.BASE_AST_CUST_CTRY_CD)                   AS JCZCKHGJ, --基础资产客户国家
           TRIM(A.BASE_AST_CUST_RTG)                       AS JCZCKHPJ, --基础资产客户评级
           TRIM(A.BASE_AST_CUST_RTG_ORG_NM)                AS JCZCKHPJJG, --基础资产客户评级机构
           TRIM(A.BASE_AST_CUST_IDY)                       AS JCZCHKHHY, --基础资产客户行业
           TRIM(A.FNL_DIR_TYP)                             AS ZZTXLX, --最终投向类型
           TRIM(A.FNL_DIR_IDY)                             AS ZZTXHY, --最终投向行业
           ''                                              AS BBZ, --备注
           V_MONTH_END_DATEID                              AS CJRQ, --采集日期
           '000'                                           AS DEPT_NO, --部门编号
           '01'                                            AS SRC_SYS_ID, --来源系统ID
           '000000'                                        AS ISSUED_NO, --填报机构
           ORG.ORG_ID_LEL_0                                AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                            AS ADDRESS, --归属地
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                            AS GSFZJG,--归属分支机构
           --'同业代付'                                      AS TY_ZJ_FLAG --同业资金标志
           A.DEPT_LINE                                     AS TY_ZJ_FLAG --同业资金标志
      FROM RRP_MDL.M_FIN_INST_INFO A --金融工具基础信息表
      LEFT JOIN RRP_MDL.ORG_CONFIG C --机构映射表
        ON C.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(TRIM(C.ORG_ID1),'800')
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = A.AST_TYP
       AND CODE.SRC_CLASS_CODE = 'T0032' --资产类型
       AND CODE.TAR_CLASS_CODE = 'T0032' --资产类型
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = A.OPTION_FLG
       AND CODE1.SRC_CLASS_CODE = 'Z0001' --含权标识
       AND CODE1.TAR_CLASS_CODE = 'Z0001' --含权标识
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = NVL(TRIM(C.ORG_ID1),'800')
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE A.AST_TYP = '9911'
       --AND UPPER(A.DATA_SRC) IN ('CRSS')
       AND UPPER(A.DATA_SRC) IN ('ICMS') --MODIFY BY TANGAN AT 20221223
       AND A.DATA_DT = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --ADD BY LIP 20250409 根据业务要求，检查金融工具表中的金融工具代码，是否在交易表或者余额表中存在，如果不存在，需剔除并提示
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '删除交易表或者余额表中不存在的金融工具';
    V_STARTTIME := SYSDATE;
    DELETE FROM RRP_EAST.EAST5_1002_JRGJXXB T
     WHERE NOT EXISTS (SELECT * FROM RRP_EAST.EAST5_1003_ZYZJJYXXB TA WHERE TA.JRGJBH = T.JRGJBH AND TA.CJRQ = V_MONTH_END_DATEID)
       AND NOT EXISTS (SELECT * FROM RRP_EAST.EAST5_1004_ZYZJYWYEB TB WHERE TB.JRGJBH = T.JRGJBH AND TB.CJRQ = V_MONTH_END_DATEID)
       AND T.CJRQ = V_MONTH_END_DATEID;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

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

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  --在过程跑批完成记录表中插入记录，调度查询该表判断过程是是否跑批完成
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE, V_PROC_NAME, TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

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

END ETL_EAST5_1002_JRGJXXB;
/

