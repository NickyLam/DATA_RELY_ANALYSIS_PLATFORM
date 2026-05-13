CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_1004_ZYZJYWYEB(I_P_DATE IN INTEGER, --跑批日期
                                                     O_ERRCODE OUT VARCHAR2 --错误代码
                                                     )
  /***********************************************************************
  **  存储过程详细说明：自营资金业务余额表
  **  存储过程名称:  ETL_EAST5_1004_ZYZJYWYEB
  **  存储过程创建日期:2022-04-28
  **  存储过程创建人:WUHB
  **  调用方法:
       DECLARE
         I_P_DATE INTEGER;
         O_ERRCODE  CHAR(5);
       BEGIN
         I_P_DATE := '20220101';
         ETL_EAST5_1004_ZYZJYWYEB(I_P_DATE,O_ERRCODE);
       END;
  **  输入参数:   I_P_DATE
  **  输出参数:   O_ERRCODE
  **  返回值:     O_ERRCODE
  **  修改日期      修改人       修改原因
  **  20220714      LHQ          根据源系统口径修改逻辑
  **  20220808      LIP          核对逻辑，调整过程格式
  **  20220824      LIP          增加数据来源描述
  **  20220826      LIP          根据孙若真邮件20220824：关于EAST5.0报送数据现状及后续的整改要求 修改，
  **                             将小类“净值型保险资管计划”，改成“保险业资产管理产品”
  **  20220902   LAIHAIQIANG     交易账户的减值应该为空 科目名称为“交易性”开头的减值准备默认为0
  **  20220913      LIP          增加委托同业代付
  **  20221017      LIP          持有成本为0时，减值准备不需取
  **  20221031     tangan        调整科目和产品映射关系，根据新一代科目和产品进行映射
  ************************************************************************/
IS
  --V_DATE               DATE;             --数据日期(判断输入参数日期格式是否准确)
  V_MONTH_START_DATEID CHAR(10);         --本月初日期
  V_MONTH_END_DATEID   CHAR(8);          --本月月底日期
  V_PARTITION_NAME     VARCHAR2(100);    --分区名称
  V_FREQ_FLAG          VARCHAR2(10);     --跑批频度
  V_STEP               INTEGER := 0;     --任务号
  V_P_DATE             VARCHAR2(10);     --跑批日期
  V_STARTTIME          DATE;             --处理开始时间
  V_ENDTIME            DATE;             --处理结束时间
  V_SQLCOUNT           INTEGER := 0;     --更新或删除影响的记录数
  V_SQLMSG             VARCHAR2(300);    --SQL执行描述信息
  V_STEP_DESC          VARCHAR2(100);    --处理步骤描述
  V_PROC_NAME          VARCHAR2(100):= UPPER('ETL_EAST5_1004_ZYZJYWYEB'); --存储过程名称
  V_TABLE_NAME         VARCHAR2(100):= UPPER('EAST5_1004_ZYZJYWYEB'); --表名称
  V_SYSTEM             VARCHAR2(30):= '监管报送'; --来源系统
BEGIN
  V_STEP_DESC := '程序加工';
  V_P_DATE    := TO_CHAR(I_P_DATE);
  V_FREQ_FLAG := RRP_EAST.FUN_FREQ(V_P_DATE,V_PROC_NAME);
  V_MONTH_END_DATEID := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD');
  V_MONTH_START_DATEID := TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD');
  V_PARTITION_NAME := 'PARTITION_' || V_MONTH_END_DATEID;

  --判断跑批频度
  IF V_FREQ_FLAG = '1' THEN
    /*增加分区、清空当日数据*/
    V_STEP      := 1;
    V_STEP_DESC := '清空当日数据';
    V_STARTTIME := SYSDATE;
    RRP_EAST.ETL_PARTITION_ADD(V_MONTH_END_DATEID,V_TABLE_NAME,'1',O_ERRCODE);
    RRP_EAST.ETL_PARTITION_TRUNCATE(V_MONTH_END_DATEID,V_TABLE_NAME,O_ERRCODE);
    EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_EAST.EAST5_1004_ZYZJYWYEB_ZJ';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_EAST.EAST5_1004_ZYZJYWYEB_TY';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_EAST.EAST5_1004_ZYZJYWYEB_ZJ_R';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_EAST.EAST5_1004_ZYZJYWYEB_TY_R';

    V_SQLCOUNT := SQL%ROWCOUNT;
    O_ERRCODE  := '0';
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    /*插入数据*/
    V_STEP      := 2;
    V_STEP_DESC := '自营资金业务余额表_本币买断式回购';
    V_STARTTIME := SYSDATE;
    --自营资金业务余额表_本币买断式回购
    INSERT INTO RRP_EAST.EAST5_1004_ZYZJYWYEB_ZJ
      (JRXKZH         --金融许可证号
      ,NBJGH          --内部机构号
      ,YHJGMC         --银行机构名称
      ,MXKMBH         --明细科目编号
      ,MXKMMC         --明细科目名称
      ,JRGJBH         --金融工具编号
      ,JRGJMC         --金融工具名称
      ,JYZHLX         --账户类型
      ,YEDL           --业务大类
      ,YWZL           --业务中类
      ,YWXL           --业务小类
      ,CPMC           --产品名称
      ,BZ             --币种
      ,CYCB           --持有成本
      ,ZMYE           --账面余额
      ,BQSY           --本期收益
      ,LJSY           --累计收益
      ,NHLL           --年化利率
      ,XYFXQZ         --信用风险权重
      ,WJFL           --五级分类
      ,JZZB           --减值准备
      ,QXRQ           --起息日期
      ,DQRQ           --到期日期
      ,BBZ            --备注
      ,CJRQ           --采集日期
      ,AMOUNT         --面额
      ,B_ID
      ,JGZ_ID
      ,DATA_SRC_DESC  --数据来源中文
      ,ZCSFL          --资产三分类代码 --ADD BY LIP 20250410
      )
    WITH DATA_BASE AS
     (SELECT BA.*,KF.CONTROLFACTOR
        FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA
       INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_KEEPFOLDER KF
          ON KF.KEEPFOLDER_ID = BA.KEEPFOLDER_ID
       WHERE BA.BALANCE_ID IN
             (SELECT MAX(BA1.BALANCE_ID)
                FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA1
               WHERE BA1.SETTLEDATE <= V_MONTH_END_DATEID
                 AND (BA1.ASSETTYPE = '买断式回购' AND BA1.MINORASSETCODE = BA1.MAJORASSETCODE)
                 AND NVL(BA1.BARETRADENAME,'-') <> 'CARRYOVERDEALS'
               GROUP BY BA1.ASPCLIENT_ID,
                        BA1.KEEPFOLDER_ID,
                        BA1.ASSETTYPE,
                        BA1.BUZTYPE,
                        BA1.MINORASSETCODE,
                        BA1.MAJORASSETCODE)
         AND (BA.HOLDPOSITION <> 0 OR BA.SETTLEDATE >= V_MONTH_START_DATEID)),
    LAST_BALANCE AS --上月末数据
     (SELECT BA.*
        FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA
       WHERE BA.BALANCE_ID IN
             (SELECT MAX(BA1.BALANCE_ID)
                FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA1
               WHERE BA1.SETTLEDATE <= TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH_END_DATEID,'YYYYMMDD'),-1),'YYYYMMDD')
                 AND (BA1.ASSETTYPE = '买断式回购' AND BA1.MINORASSETCODE = BA1.MAJORASSETCODE)
               GROUP BY BA1.ASPCLIENT_ID,
                        BA1.KEEPFOLDER_ID,
                        BA1.ASSETTYPE,
                        BA1.BUZTYPE,
                        BA1.MINORASSETCODE,
                        BA1.MAJORASSETCODE))
    SELECT 'B1194H244050001'                                           AS JRXKZH --金融许可证号
           ,M.DEPARTMENTID                                             AS NBJGH --内部机构号
           ,'广东华兴银行股份有限公司总行'                             AS YXJGMC --银行机构名称
           --,DECODE(T2.BUYORSELL,'B','2111050101','1111040101')         AS MXKMBH --明细科目编号
           --,DECODE(T2.BUYORSELL,'B','卖出回购债券（买断式）','买入返售债券（买断式）') AS MXKMMC --明细科目名称
           ,DECODE(T2.BUYORSELL,'B','21110201','11110201')             AS MXKMBH --明细科目编号  --modify by tangan at 20221031
           ,DECODE(T2.BUYORSELL,'B','卖出回购债券成本','买入返售债券成本') AS MXKMMC --明细科目名称  --modify by tangan at 20221031
           ,T2.CPTYS_ID || '_' || T2.SERIAL_NUMBER                     AS JRGJBH --金融工具编号
           ,T2.CPTYS_SHORT_NAME || '_' || DECODE(T2.BUYORSELL,'B','买断式正回购','买断式逆回购') AS JRGJMC --金融工具名称
           ,DECODE(T1.CONTROLFACTOR,'NT','交易账户','银行账户')        AS JYZHLX --账户类型
           ,'同业往来'                                                 AS YEDL --业务大类
           ,DECODE(T2.BUYORSELL,'B','卖出回购','买入返售')             AS YEZL --业务中类
           ,DECODE(T2.BUYORSELL,'B','卖出回购证券','买入返售证券')     AS YEXL --业务小类
           ,DECODE(T2.BUYORSELL,'B','买断式正回购','买断式逆回购')     AS CPMC --产品名称
           ,'CNY'                                                      AS BZ --币种
           ,DECODE(T1.BUZTYPE,'逆回购',T1.HOLDPOSITION,T1.INTERESTCOST)AS CYCB --持有成本
           ,T1.HOLDPOSITION                                            AS ZMYE --账面余额
           --需要减去上一期的金额
           ,DECODE(T1.BUZTYPE,'逆回购',1,-1) * (T1.INTERESTEARNING - NVL(T3.INTERESTEARNING,0)) AS BQSY --本期收益
           ,DECODE(T1.BUZTYPE,'逆回购',1,-1) * T1.INTERESTEARNING      AS LJSY --累计收益
           ,T2.REPO_RATE                                               AS NHLL --年化利率  目前塞的是票面利率，因为平均成本没法弄
           ,NULL                                                       AS XYFXQZ --信用风险权重
           ,'正常'                                                     AS WJFL --五级分类
           ,NULL                                                       AS JZZB --减值准备
           ,TRIM(T2.VALUE_DATE)                                        AS QXRQ --起息日期
           ,TRIM(T2.MATURITY_DATE)                                     AS DQRQ --到期日期
           ,NULL                                                       AS BBZ --备注
           ,V_MONTH_END_DATEID                                         AS CJRQ --采集日期
           ,T1.HOLDPOSITION                                            AS AMOUNT --面额
           --,T1.MINORASSETCODE                                          AS B_ID
           ,T1.MINORASSETCODE||'-V02#'||T1.MINORASSETCODE||'#'||T2.BONDSCODE AS B_ID --MOD BY LIP 20250103
           ,T1.MINORASSETCODE                                          AS JGZ_ID
           ,'本币买断式回购'                                           AS DATA_SRC_DESC --数据来源中文
           ,DECODE(T1.ASSETTYPE,'交易性金融资产','FVTPL','可供出售金融资产','FVOCI','AC') AS ZCSFL --资产三分类代码 --ADD BY LIP 20250410
      FROM DATA_BASE T1
      --FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE T1
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_V_REPODEALS T2
        ON T2.DEAL_ID = SUBSTR(T1.MINORASSETCODE,4)
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_INTERFACE_PORTF_DEPART_MAPPING M
        ON M.KEEPFOLDER_ID = T2.KEEPFOLDER_ID
      LEFT JOIN LAST_BALANCE T3
        ON T3.ASSETTYPE = T1.ASSETTYPE
       AND T3.BUZTYPE = T1.BUZTYPE
       AND T3.MINORASSETCODE = T1.MINORASSETCODE
       AND T3.MAJORASSETCODE = T1.MAJORASSETCODE
       AND T3.KEEPFOLDER_ID = T1.KEEPFOLDER_ID
     WHERE T1.ASSETTYPE = '买断式回购';

    V_SQLCOUNT := SQL%ROWCOUNT;
    O_ERRCODE  := '0';
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP      := 3;
    V_STEP_DESC := '自营资金业务余额表_本币同业拆借';
    V_STARTTIME := SYSDATE;
    --自营资金业务余额表_本币同业拆借
    INSERT INTO RRP_EAST.EAST5_1004_ZYZJYWYEB_ZJ
      (JRXKZH         --金融许可证号
      ,NBJGH          --内部机构号
      ,YHJGMC         --银行机构名称
      ,MXKMBH         --明细科目编号
      ,MXKMMC         --明细科目名称
      ,JRGJBH         --金融工具编号
      ,JRGJMC         --金融工具名称
      ,JYZHLX         --账户类型
      ,YEDL           --业务大类
      ,YWZL           --业务中类
      ,YWXL           --业务小类
      ,CPMC           --产品名称
      ,BZ             --币种
      ,CYCB           --持有成本
      ,ZMYE           --账面余额
      ,BQSY           --本期收益
      ,LJSY           --累计收益
      ,NHLL           --年化利率
      ,XYFXQZ         --信用风险权重
      ,WJFL           --五级分类
      ,JZZB           --减值准备
      ,QXRQ           --起息日期
      ,DQRQ           --到期日期
      ,BBZ            --备注
      ,CJRQ           --采集日期
      ,AMOUNT         --面额
      ,B_ID
      ,JGZ_ID
      ,DATA_SRC_DESC  --数据来源中文
      ,ZCSFL          --资产三分类代码 --ADD BY LIP 20250410
      )
    WITH DATA_BASE AS
      (SELECT BA.*,KF.CONTROLFACTOR
         FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA
        INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_KEEPFOLDER KF
           ON KF.KEEPFOLDER_ID = BA.KEEPFOLDER_ID
        WHERE BA.BALANCE_ID IN (
              SELECT MAX(BA1.BALANCE_ID)
                FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA1
               WHERE BA1.SETTLEDATE <= V_MONTH_END_DATEID
                 AND (BA1.ASSETTYPE = '拆借' AND BA1.MINORASSETCODE = BA1.MAJORASSETCODE)
                 AND NVL(BA1.BARETRADENAME,'-') <> 'CARRYOVERDEALS'
               GROUP BY BA1.ASPCLIENT_ID,BA1.KEEPFOLDER_ID,BA1.ASSETTYPE,BA1.BUZTYPE,BA1.MINORASSETCODE,BA1.MAJORASSETCODE)
          AND (BA.HOLDPOSITION <> 0 OR BA.SETTLEDATE >= V_MONTH_START_DATEID)),
    --上月末数据
    LAST_BALANCE AS
      (SELECT BA.*
         FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA
        WHERE BA.BALANCE_ID IN (
              SELECT MAX(BA1.BALANCE_ID)
                FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA1
              WHERE BA1.SETTLEDATE <= TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH_END_DATEID,'YYYYMMDD'),-1),'YYYYMMDD')
                AND (BA1.ASSETTYPE = '拆借'AND BA1.MINORASSETCODE = BA1.MAJORASSETCODE)
              GROUP BY BA1.ASPCLIENT_ID,BA1.KEEPFOLDER_ID,BA1.ASSETTYPE,BA1.BUZTYPE,BA1.MINORASSETCODE,BA1.MAJORASSETCODE))
    SELECT 'B1194H244050001'                                           AS JRXKZH --金融许可证号
           ,M.DEPARTMENTID                                             AS NBJGH --内部机构号
           ,'广东华兴银行股份有限公司总行'                             AS YXJGMC --银行机构名称
           ,CASE WHEN T2.BUYORSELL = 'B'
                 THEN DECODE(T7.COMMONATTS_SHORTNAME,'拆入境内银行业存款类金融机构','20030101',
                                                     --'拆入境内银行业非存款类金融机构','20030101', --202507版改为 20030102 拆入境内非银行金融机构
                                                     '拆入境内银行业非存款类金融机构','20030102', --ADD BY LIP 20250707
                                                     '拆入境内证券业金融机构','20030102',
                                                     '拆入境内保险业金融机构','20030102',
                                                     '拆入境内交易及结算类金融机构','20030102',
                                                     '拆入境内金融控股公司','20030102',
                                                     '拆入境内其他金融机构','20030102',
                                                     --'拆入境外银行款项','20030201',
                                                     --'拆入境外非银行款项','20030202',
                                                     '拆入境外银行','20030201', --MOD BY LIP 20250707
                                                     '拆入境外非银行','20030202', --MOD BY LIP 20250707
                                                     '拆入境内银行境外非独立法人','20030201', --ADD BY LIP 20250707
                                                     '') --同业拆借-拆入
                 ELSE DECODE(T7.COMMONATTS_SHORTNAME,--'拆放境内银行款项','13020101',
                                                     '拆放境内银行业存款类金融机构','13020101', --MOD BY LIP 20250707
                                                     '拆放境内证券业金融机构','13020102',
                                                     '拆放境内保险业金融机构','13020102',
                                                     '拆放境内金融控股公司','13020102',
                                                     '拆放境内其他金融机构','13020102',
                                                     '拆放境内交易及结算类金融机构','13020102',
                                                     --'拆放境外银行款项','13020201',
                                                     --'拆放境外非银行款项','13020202',
                                                     '拆放境外银行','13020201', --MOD BY LIP 20250707
                                                     '拆放境外非银行','13020202', --MOD BY LIP 20250707
                                                     '拆放境内银行业非存款类金融机构','13020102', --ADD BY LIP 20250707
                                                     '拆放境内银行境外非独立法人','13020201', --ADD BY LIP 20250707
                                                     '') --同业拆借-拆出
             END                                                       AS MXKMBH --明细科目编号 --MOD BY TANGAN AT 20221031
           ,NULL                                                       AS MXKMMC --直接根据上面的明细科目编号，再统一关联总账科目表取最好          --明细科目名称
           ,T2.CPTYS_ID||'_'||T2.SERIAL_NUMBER                         AS JRGJBH --金融工具编号
           ,T2.CPTYS_SHORT_NAME||'_'||DECODE(T2.BUYORSELL,'B','同业拆入','拆放同业') AS JRGJMC --金融工具名称
           ,DECODE(T1.CONTROLFACTOR,'NT','交易账户','银行账户')        AS JYZHLX --账户类型
           ,'同业往来'                                                 AS YEDL --业务大类
           ,DECODE(T2.BUYORSELL,'B','拆入','拆出')                     AS YEZL --业务中类
           ,CASE WHEN T2.BUYORSELL = 'B'
                   --AND T7.COMMONATTS_SHORTNAME IN ('拆入境内银行业存款类金融机构','拆入境内银行业非存款类金融机构','拆入境外银行款项')
                   AND T7.COMMONATTS_SHORTNAME IN ('拆入境内银行业存款类金融机构','拆入境内银行业非存款类金融机构','拆入境外银行') --MOD BY LIP 20250707
                 THEN '拆入银行金融机构'
                 WHEN T2.BUYORSELL = 'B' THEN '拆入非银行金融机构'
                 --WHEN T2.BUYORSELL = 'S' AND T7.COMMONATTS_SHORTNAME IN ('拆放境内银行款项','拆放境外银行款项')
                 WHEN T2.BUYORSELL = 'S' AND T7.COMMONATTS_SHORTNAME IN ('拆放境内银行业存款类金融机构','拆放境外银行') --MOD BY LIP 20250707
                 THEN '拆出银行金融机构'
                 ELSE '拆出非银行金融机构'
             END                                                       AS YWXL --业务小类
           ,DECODE(T2.BUYORSELL,'B','同业拆入','拆放同业')             AS CPMC --产品名称
           ,'CNY'                                                      AS BZ --币种
           ,DECODE(T1.BUZTYPE,'拆入',T1.INTERESTCOST,T1.HOLDPOSITION)  AS CYCB --持有成本
           ,T1.HOLDPOSITION                                            AS ZMYE --账面余额
           ,T1.INTERESTEARNING - NVL(T3.INTERESTEARNING,0)             AS BQSY --本期收益   需要减去上一期的金额
           ,T1.INTERESTEARNING                                         AS LJSY --累计收益
           ,T2.REPO_RATE                                               AS NHLL --年化利率  目前塞的是票面利率，因为平均成本没法弄
           ,NULL                                                       AS XYFXQZ --信用风险权重
           ,'正常'                                                     AS WJFL --五级分类
           ,NULL                                                       AS JZZB --减值准备
           ,TRIM(T2.VALUE_DATE)                                        AS QXRQ --起息日期
           ,TRIM(T2.MATURITY_DATE)                                     AS DQRQ --到期日期
           ,NULL                                                       AS BBZ --备注
           ,V_MONTH_END_DATEID                                         AS CJRQ --采集日期
           ,T1.HOLDPOSITION                                            AS AMOUNT --面额
           ,T1.MINORASSETCODE                                          AS B_ID
           ,T1.MINORASSETCODE                                          AS JGZ_ID
           ,'本币同业拆借'                                             AS DATA_SRC_DESC --数据来源中文
           ,DECODE(T1.ASSETTYPE,'交易性金融资产','FVTPL','可供出售金融资产','FVOCI','AC') AS ZCSFL --资产三分类代码 --ADD BY LIP 20250410
      FROM DATA_BASE T1
      --FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE T1
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_V_IAMDEALS T2
        ON T2.DEAL_ID = SUBSTR(T1.MINORASSETCODE,4)
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_CPTYS T5
        ON T5.KEY_SRC = T2.CPTYS_ID
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_INTERFACE_PORTF_DEPART_MAPPING M
        ON M.KEEPFOLDER_ID = T2.KEEPFOLDER_ID
      LEFT JOIN LAST_BALANCE T3
        ON T3.ASSETTYPE = T1.ASSETTYPE
       AND T3.BUZTYPE = T1.BUZTYPE
       AND T3.MINORASSETCODE = T1.MINORASSETCODE
       AND T3.MAJORASSETCODE = T1.MAJORASSETCODE
       AND T3.KEEPFOLDER_ID = T1.KEEPFOLDER_ID
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_CPTYATTSMAP T6
        ON T6.CPTYS_ID = T5.CPTYS_ID
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_COMMONATTS T7
        ON T7.COMMONATTS_ID = T6.COMMONATTS_ID
       AND T7.COMMONATTS_ID_PARENT = DECODE(T2.BUYORSELL,'B','11','2')
     WHERE T1.ASSETTYPE = '拆借';

    V_SQLCOUNT := SQL%ROWCOUNT;
    O_ERRCODE  := '0';
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP      := 4;
    V_STEP_DESC := '自营资金业务余额表_本币债券发行';
    V_STARTTIME := SYSDATE;
    --自营资金业务余额表_本币债券发行
    INSERT INTO RRP_EAST.EAST5_1004_ZYZJYWYEB_ZJ
      (JRXKZH         --金融许可证号
      ,NBJGH          --内部机构号
      ,YHJGMC         --银行机构名称
      ,MXKMBH         --明细科目编号
      ,MXKMMC         --明细科目名称
      ,JRGJBH         --金融工具编号
      ,JRGJMC         --金融工具名称
      ,JYZHLX         --账户类型
      ,YEDL           --业务大类
      ,YWZL           --业务中类
      ,YWXL           --业务小类
      ,CPMC           --产品名称
      ,BZ             --币种
      ,CYCB           --持有成本
      ,ZMYE           --账面余额
      ,BQSY           --本期收益
      ,LJSY           --累计收益
      ,NHLL           --年化利率
      ,XYFXQZ         --信用风险权重
      ,WJFL           --五级分类
      ,JZZB           --减值准备
      ,QXRQ           --起息日期
      ,DQRQ           --到期日期
      ,BBZ            --备注
      ,CJRQ           --采集日期
      ,AMOUNT         --面额
      ,B_ID
      ,JGZ_ID
      ,DATA_SRC_DESC  --数据来源中文
      ,ZCSFL          --资产三分类代码 --ADD BY LIP 20250410
      )
    WITH DATA_BASE AS
     (SELECT BA.*,KF.CONTROLFACTOR
        FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA
       INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_KEEPFOLDER KF
          ON KF.KEEPFOLDER_ID = BA.KEEPFOLDER_ID
       WHERE BA.BALANCE_ID IN
             (SELECT MAX(BA1.BALANCE_ID)
                FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA1
               WHERE BA1.SETTLEDATE <= V_MONTH_END_DATEID
                 AND (BA1.ASSETTYPE = '债券发行' AND BA1.MAJORASSETCODE = BA1.MINORASSETCODE)
                 AND NVL(BA1.BARETRADENAME,'-') <> 'CARRYOVERDEALS'
               GROUP BY BA1.ASPCLIENT_ID,BA1.KEEPFOLDER_ID,BA1.ASSETTYPE,BA1.BUZTYPE,BA1.MINORASSETCODE,BA1.MAJORASSETCODE)
         AND (BA.HOLDPOSITION <> 0 OR BA.SETTLEDATE >= V_MONTH_START_DATEID)),
    LAST_BALANCE AS
     (SELECT BA.*
        FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA
       WHERE BA.BALANCE_ID IN
             (SELECT MAX(BA1.BALANCE_ID)
                FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA1
               WHERE BA1.SETTLEDATE <= TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH_END_DATEID,'YYYYMMDD'),-1),'YYYYMMDD')
                 AND (BA1.ASSETTYPE = '债券发行' AND BA1.MINORASSETCODE = BA1.MAJORASSETCODE)
               GROUP BY BA1.ASPCLIENT_ID,BA1.KEEPFOLDER_ID,BA1.ASSETTYPE,BA1.BUZTYPE,BA1.MINORASSETCODE,BA1.MAJORASSETCODE))
    SELECT 'B1194H244050001'                                           AS JRXKZH --金融许可证号
           ,M.DEPARTMENTID                                             AS NBJGH --内部机构号
           ,'广东华兴银行股份有限公司总行'                             AS YXJGMC --银行机构名称
           ,DECODE(T2.SECURITY_TYPE_NEW ,'Y','44010101','9','25020201','25020101') AS MXKMBH --明细科目编号
           ,NULL                                                       AS MXKMMC --直接根据上面的明细科目编号，再统一关联总账科目表取最好  --明细科目名称
           ,NVL(T5.EXTRA_CODE,T2.SECURITY_CODE)                        AS JRGJBH --金融工具编号
           ,T2.SECURITY_NAME                                           AS JRGJMC --金融工具名称
           ,DECODE(T1.CONTROLFACTOR,'NT','交易账户','银行账户')        AS JYZHLX --账户类型
           ,'同业往来'                                                 AS YEDL --业务大类
           ,'债券发行'                                                 AS YEZL --业务中类
           ,DECODE(T2.SECURITY_TYPE_NEW,'Y','银行永续债','9','商业银行债','X','银行次级债','其他-银行自定义') AS YEXL --业务小类
           ,T2.SECURITY_NAME                                           AS CPMC --产品名称
           ,T2.CCY                                                     AS BZ --币种
           ,T1.INTERESTCOST                                            AS CYCB --持有成本
           ,T1.HOLDFACEAMOUNT + T1.INTERESTADJUST                      AS ZMYE --账面余额
           ,T1.INTERESTEARNING - T1.AMORTIZEEARNING -
           (NVL(T3.INTERESTEARNING,0) - NVL(T3.AMORTIZEEARNING,0))     AS BQSY --本期收益 需要减去上一期的金额
           ,T1.INTERESTEARNING - T1.AMORTIZEEARNING                    AS LJSY --累计收益
           ,NVL(T2.FIXED_RATE,T2.AUTION_RATE)                          AS NHLL --年化利率 目前塞的是票面利率
           ,NULL                                                       AS XYFXQZ --信用风险权重
           ,'正常'                                                     AS WJFL --五级分类
           ,NULL                                                       AS JZZB --减值准备
           ,TRIM(T2.START_COUPON_DATE)                                 AS QXRQ --起息日期
           ,TRIM(T2.MATURITY_DATE)                                     AS DQRQ --到期日期
           ,NULL                                                       AS BBZ --备注
           ,V_MONTH_END_DATEID                                         AS CJRQ --采集日期
           ,T1.HOLDPOSITION                                            AS AMOUNT --面额
           ,NULL                                                       AS B_ID
           ,NULL                                                       AS JGZ_ID
           ,'本币债券发行'                                             AS DATA_SRC_DESC --数据来源中文
           ,DECODE(T1.ASSETTYPE,'交易性金融资产','FVTPL','可供出售金融资产','FVOCI','AC') AS ZCSFL --资产三分类代码 --ADD BY LIP 20250410
      FROM DATA_BASE T1
      --FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE T1
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_V_SECURITY T2
        ON T2.SECURITY_CODE = T1.MAJORASSETCODE
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_INTERFACE_PORTF_DEPART_MAPPING M
        ON M.KEEPFOLDER_ID = T1.KEEPFOLDER_ID
      LEFT JOIN LAST_BALANCE T3
        ON T3.ASSETTYPE = T1.ASSETTYPE
       AND T3.BUZTYPE = T1.BUZTYPE
       AND T3.MINORASSETCODE = T1.MINORASSETCODE
       AND T3.MAJORASSETCODE = T1.MAJORASSETCODE
       AND T3.KEEPFOLDER_ID = T1.KEEPFOLDER_ID
      LEFT JOIN RRP_MDL.O_IOL_CTMS_TBS_SECURITY_EXTRA_CODE T5
        ON T5.SECURITY_CODE = T1.MAJORASSETCODE
     WHERE T1.BUZTYPE = '债券发行';

    V_SQLCOUNT := SQL%ROWCOUNT;
    O_ERRCODE  := '0';
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP      := 5;
    V_STEP_DESC := '自营资金业务余额表_本币债券借贷';
    V_STARTTIME := SYSDATE;
    --自营资金业务余额表_本币债券借贷
    INSERT INTO RRP_EAST.EAST5_1004_ZYZJYWYEB_ZJ
      (JRXKZH         --金融许可证号
      ,NBJGH          --内部机构号
      ,YHJGMC         --银行机构名称
      ,MXKMBH         --明细科目编号
      ,MXKMMC         --明细科目名称
      ,JRGJBH         --金融工具编号
      ,JRGJMC         --金融工具名称
      ,JYZHLX         --账户类型
      ,YEDL           --业务大类
      ,YWZL           --业务中类
      ,YWXL           --业务小类
      ,CPMC           --产品名称
      ,BZ             --币种
      ,CYCB           --持有成本
      ,ZMYE           --账面余额
      ,BQSY           --本期收益
      ,LJSY           --累计收益
      ,NHLL           --年化利率
      ,XYFXQZ         --信用风险权重
      ,WJFL           --五级分类
      ,JZZB           --减值准备
      ,QXRQ           --起息日期
      ,DQRQ           --到期日期
      ,BBZ            --备注
      ,CJRQ           --采集日期
      ,AMOUNT         --面额
      ,B_ID
      ,JGZ_ID
      ,DATA_SRC_DESC  --数据来源中文
      ,ZCSFL          --资产三分类代码 --ADD BY LIP 20250410
      )
    WITH DATA_BASE AS
     (SELECT BA.*,KF.CONTROLFACTOR
        FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA
       INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_KEEPFOLDER KF
          ON KF.KEEPFOLDER_ID = BA.KEEPFOLDER_ID
       WHERE BA.BALANCE_ID IN
             (SELECT MAX(BA1.BALANCE_ID)
                FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA1
               WHERE BA1.SETTLEDATE <= V_MONTH_END_DATEID
                 AND (BA1.ASSETTYPE = '债券借贷')
                 AND NVL(BA1.BARETRADENAME,'-') <> 'CARRYOVERDEALS'
               GROUP BY BA1.ASPCLIENT_ID,BA1.KEEPFOLDER_ID,BA1.ASSETTYPE,BA1.BUZTYPE,BA1.MINORASSETCODE,BA1.MAJORASSETCODE)
         AND (BA.HOLDPOSITION <> 0 OR BA.SETTLEDATE >= V_MONTH_START_DATEID)),
    LAST_BALANCE AS
     (SELECT BA.*
        FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA
       WHERE BA.BALANCE_ID IN
             (SELECT MAX(BA1.BALANCE_ID)
                FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA1
               WHERE BA1.SETTLEDATE <= TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH_END_DATEID,'YYYYMMDD'),-1),'YYYYMMDD')
                 AND (BA1.ASSETTYPE = '债券借贷')
               GROUP BY BA1.ASPCLIENT_ID,BA1.KEEPFOLDER_ID,BA1.ASSETTYPE,BA1.BUZTYPE,BA1.MINORASSETCODE,BA1.MAJORASSETCODE))
    SELECT 'B1194H244050001'                                           AS JRXKZH --金融许可证号
           ,M.DEPARTMENTID                                             AS NBJGH --内部机构号
           ,'广东华兴银行股份有限公司总行'                             AS YXJGMC --银行机构名称
           --,DECODE(T2.BUYORSELL,'B','81210201','81210211')             AS MXKMBH --明细科目编号
           ,DECODE(T2.BUYORSELL,'B','81200101','81200102')             AS MXKMBH --明细科目编号  --modify by tangan at 20221031
           ,NULL                                                       AS MXKMMC --直接根据上面的明细科目编号，再统一关联总账科目表取最好  --明细科目名称
           ,T2.CPTYS_ID || '_' || T2.SERIAL_NUMBER                     AS JRGJBH --金融工具编号
           ,T2.CPTYS_SHORT_NAME || '_' || DECODE(T2.BUYORSELL,'B','债券借入','债券借出') AS JRGJMC --金融工具名称
           ,DECODE(T1.CONTROLFACTOR,'NT','交易账户','银行账户')        AS JYZHLX --账户类型
           ,'同业往来'                                                 AS YEDL --业务大类
           ,'其他'                                                     AS YEZL --业务中类
           ,'债券借贷'                                                 AS YWXL --业务小类
           ,DECODE(T2.BUYORSELL,'B','债券借入','债券借出')             AS CPMC --产品名称
           ,'CNY'                                                      AS BZ --币种
           ,0                                                          AS CYCB --持有成本
           ,T1.HOLDPOSITION                                            AS ZMYE --账面余额
           --,DECODE(T1.BUZTYPE,'融入',-1,1) /** (T1.CHARGEEXPENSE - NVL(T3.CHARGEEXPENSE,0))*/ AS BQSY --本期收益 需要减去上一期的金额
           --,DECODE(T1.BUZTYPE,'融入',-1,1) /** T1.CHARGEEXPENSE*/      AS LJSY --累计收益
           --MOD BY LIP 20220901
           ,DECODE(T1.BUZTYPE,'融入',-1,1) * (T1.CHARGEEXPENSE - NVL(T3.CHARGEEXPENSE,0)) AS BQSY --本期收益 需要减去上一期的金额
           ,DECODE(T1.BUZTYPE,'融入',-1,1) * T1.CHARGEEXPENSE          AS LJSY --累计收益  --源表无字段，暂时置0
           ,T2.TRADE_RATE                                              AS NHLL --年化利率  目前塞的是票面利率，因为平均成本没法弄
           ,NULL                                                       AS XYFXQZ --信用风险权重
           ,'正常'                                                     AS WJFL --五级分类
           ,NULL                                                       AS JZZB --减值准备
           ,TRIM(T2.VALUE_DATE)                                        AS QXRQ --起息日期
           ,TRIM(T2.MATURITY_DATE)                                     AS DQRQ --到期日期
           ,NULL                                                       AS BBZ --备注
           ,V_MONTH_END_DATEID                                         AS CJRQ --采集日期
           ,T1.HOLDPOSITION                                            AS AMOUNT --面额
           ,T1.MINORASSETCODE                                          AS B_ID
           ,T1.MINORASSETCODE                                          AS JGZ_ID
           ,'本币债券借贷'                                             AS DATA_SRC_DESC --数据来源中文
           ,DECODE(T1.ASSETTYPE,'交易性金融资产','FVTPL','可供出售金融资产','FVOCI','AC') AS ZCSFL --资产三分类代码 --ADD BY LIP 20250410
      FROM DATA_BASE T1
      --FROM RRP_MDL.O_IOL_CTMS_FBS_V_BALANCE T1
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_V_WTRADE_LEND T2
        --ON SUBSTR(T1.MINORASSETCODE,4) = T2.DEAL_ID
        --MOD BY LIP 20240415 根据资金反馈的逻辑调整关联条件
        ON (SUBSTR(T1.MINORASSETCODE,4) = T2.DEAL_ID OR (SUBSTR(T1.MINORASSETCODE,4) = T2.WTRADE_LEND_ID_GRAND AND T2.STATUS = 'A'))
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_INTERFACE_PORTF_DEPART_MAPPING M
        ON M.KEEPFOLDER_ID = T2.KEEPFOLDER_ID
      LEFT JOIN LAST_BALANCE T3
        ON T3.ASSETTYPE = T1.ASSETTYPE
       AND T3.BUZTYPE = T1.BUZTYPE
       AND T3.MINORASSETCODE = T1.MINORASSETCODE
       AND T3.MAJORASSETCODE = T1.MAJORASSETCODE
       AND T3.KEEPFOLDER_ID = T1.KEEPFOLDER_ID
     WHERE T1.ASSETTYPE = '债券借贷';

    V_SQLCOUNT := SQL%ROWCOUNT;
    O_ERRCODE  := '0';
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP      := 6;
    V_STEP_DESC := '自营资金业务余额表_本币质押式回购';
    V_STARTTIME := SYSDATE;
    --自营资金业务余额表_本币质押式回购
    INSERT INTO RRP_EAST.EAST5_1004_ZYZJYWYEB_ZJ
      (JRXKZH         --金融许可证号
      ,NBJGH          --内部机构号
      ,YHJGMC         --银行机构名称
      ,MXKMBH         --明细科目编号
      ,MXKMMC         --明细科目名称
      ,JRGJBH         --金融工具编号
      ,JRGJMC         --金融工具名称
      ,JYZHLX         --账户类型
      ,YEDL           --业务大类
      ,YWZL           --业务中类
      ,YWXL           --业务小类
      ,CPMC           --产品名称
      ,BZ             --币种
      ,CYCB           --持有成本
      ,ZMYE           --账面余额
      ,BQSY           --本期收益
      ,LJSY           --累计收益
      ,NHLL           --年化利率
      ,XYFXQZ         --信用风险权重
      ,WJFL           --五级分类
      ,JZZB           --减值准备
      ,QXRQ           --起息日期
      ,DQRQ           --到期日期
      ,BBZ            --备注
      ,CJRQ           --采集日期
      ,AMOUNT         --面额
      ,B_ID
      ,JGZ_ID
      ,DATA_SRC_DESC  --数据来源中文
      ,ZCSFL          --资产三分类代码 --ADD BY LIP 20250410
      )
    WITH DATA_BASE AS
     (SELECT BA.*,KF.CONTROLFACTOR
        FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA
       INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_KEEPFOLDER KF
          ON KF.KEEPFOLDER_ID = BA.KEEPFOLDER_ID
       WHERE BA.BALANCE_ID IN
             (SELECT MAX(BA1.BALANCE_ID)
                FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA1
               WHERE BA1.SETTLEDATE <= V_MONTH_END_DATEID
                 AND (BA1.ASSETTYPE = '质押式回购' AND BA1.MINORASSETCODE = BA1.MAJORASSETCODE)
                 AND NVL(BA1.BARETRADENAME,'-') <> 'CARRYOVERDEALS'
               GROUP BY BA1.ASPCLIENT_ID,BA1.KEEPFOLDER_ID,BA1.ASSETTYPE,BA1.BUZTYPE,BA1.MINORASSETCODE,BA1.MAJORASSETCODE)
         AND (BA.HOLDPOSITION <> 0 OR BA.SETTLEDATE >= V_MONTH_START_DATEID)),
    LAST_BALANCE AS
     (SELECT BA.*
        FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA
       WHERE BA.BALANCE_ID IN
             (SELECT MAX(BA1.BALANCE_ID)
                FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA1
               WHERE BA1.SETTLEDATE <= TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH_END_DATEID,'YYYYMMDD'),-1),'YYYYMMDD')
                 AND (BA1.ASSETTYPE = '质押式回购' AND BA1.MINORASSETCODE = BA1.MAJORASSETCODE)
               GROUP BY BA1.ASPCLIENT_ID,BA1.KEEPFOLDER_ID,BA1.ASSETTYPE,BA1.BUZTYPE,BA1.MINORASSETCODE,BA1.MAJORASSETCODE))
    SELECT 'B1194H244050001'                                           AS JRXKZH --金融许可证号
           ,M.DEPARTMENTID                                             AS NBJGH --内部机构号
           ,'广东华兴银行股份有限公司总行'                             AS YXJGMC --银行机构名称
           --,DECODE(T2.BUYORSELL,'B','2111050102','1111040102')         AS MXKMBH --明细科目编号
           --,DECODE(T2.BUYORSELL,'B','卖出回购债券（质押式）','买入返售债券（质押式）') AS MXKMMC --明细科目名称
           ,DECODE(T2.BUYORSELL,'B','21110201','11110201')             AS MXKMBH --明细科目编号  --modify by tangan at 20221031
           ,DECODE(T2.BUYORSELL,'B','卖出回购债券成本','买入返售债券成本') AS MXKMMC --明细科目名称  --modify by tangan at 20221031
           ,T2.CPTYS_ID || '_' || T2.SERIAL_NUMBER                     AS JRGJBH --金融工具编号
           ,T2.CPTYS_SHORT_NAME || '_' || DECODE(T2.BUYORSELL,'B','质押式正回购','质押式逆回购') AS JRGJMC --金融工具名称
           ,DECODE(T1.CONTROLFACTOR,'NT','交易账户','银行账户')        AS JYZHLX --账户类型
           ,'同业往来'                                                 AS YEDL --业务大类
           ,DECODE(T2.BUYORSELL,'B','卖出回购','买入返售')             AS YEZL --业务中类
           ,DECODE(T2.BUYORSELL,'B','卖出回购证券','买入返售证券')     AS YEXL --业务小类
           ,DECODE(T2.BUYORSELL,'B','质押式正回购','质押式逆回购')     AS CPMC --产品名称
           ,'CNY'                                                      AS BZ --币种
           --,T1.HOLDPOSITION                                            AS CYCB --持有成本
           ,DECODE(T1.BUZTYPE,'逆回购',T1.HOLDPOSITION,T1.INTERESTCOST) AS CYCB --持有成本
           ,T1.HOLDPOSITION                                            AS ZMYE --账面余额
           ,T1.INTERESTEARNING - NVL(T3.INTERESTEARNING,0)             AS BQSY --本期收益 需要减去上一期的金额
           ,T1.INTERESTEARNING                                         AS LJSY --累计收益
           ,T2.TRADE_RATE                                              AS NHLL --年化利率  目前塞的是票面利率，因为平均成本没法弄
           ,NULL                                                       AS XYFXQZ --信用风险权重
           ,'正常'                                                     AS WJFL --五级分类
           ,NULL                                                       AS JZZB --减值准备
           ,TRIM(T2.VALUE_DATE)                                        AS QXRQ --起息日期
           ,TRIM(T2.MATURITY_DATE)                                     AS DQRQ --到期日期
           ,NULL                                                       AS BBZ --备注
           ,V_MONTH_END_DATEID                                         AS CJRQ --采集日期
           ,T1.HOLDPOSITION                                            AS AMOUNT --面额
           ,T1.MINORASSETCODE                                          AS B_ID
           ,T1.MINORASSETCODE                                          AS JGZ_ID
           ,'本币质押式回购'                                           AS DATA_SRC_DESC --数据来源中文
           ,DECODE(T1.ASSETTYPE,'交易性金融资产','FVTPL','可供出售金融资产','FVOCI','AC') AS ZCSFL --资产三分类代码 --ADD BY LIP 20250410
      FROM DATA_BASE T1
      --FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE T1
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_V_LDREPODEALS T2
        ON T2.DEAL_ID = SUBSTR(T1.MINORASSETCODE,4)
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_INTERFACE_PORTF_DEPART_MAPPING M
        ON M.KEEPFOLDER_ID = T2.KEEPFOLDER_ID
      LEFT JOIN LAST_BALANCE T3
        ON T3.ASSETTYPE = T1.ASSETTYPE
       AND T3.BUZTYPE = T1.BUZTYPE
       AND T3.MINORASSETCODE = T1.MINORASSETCODE
       AND T3.MAJORASSETCODE = T1.MAJORASSETCODE
       AND T3.KEEPFOLDER_ID = T1.KEEPFOLDER_ID
     WHERE T1.ASSETTYPE = '质押式回购';

    V_SQLCOUNT := SQL%ROWCOUNT;
    O_ERRCODE  := '0';
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP      := 7;
    V_STEP_DESC := '自营资金业务余额表_外币拆借/外币回购';
    V_STARTTIME := SYSDATE;
    --自营资金业务余额表_外币拆借/外币回购
    INSERT INTO RRP_EAST.EAST5_1004_ZYZJYWYEB_ZJ
      (JRXKZH         --金融许可证号
      ,NBJGH          --内部机构号
      ,YHJGMC         --银行机构名称
      ,MXKMBH         --明细科目编号
      ,MXKMMC         --明细科目名称
      ,JRGJBH         --金融工具编号
      ,JRGJMC         --金融工具名称
      ,JYZHLX         --账户类型
      ,YEDL           --业务大类
      ,YWZL           --业务中类
      ,YWXL           --业务小类
      ,CPMC           --产品名称
      ,BZ             --币种
      ,CYCB           --持有成本
      ,ZMYE           --账面余额
      ,BQSY           --本期收益
      ,LJSY           --累计收益
      ,NHLL           --年化利率
      ,XYFXQZ         --信用风险权重
      ,WJFL           --五级分类
      ,JZZB           --减值准备
      ,QXRQ           --起息日期
      ,DQRQ           --到期日期
      ,BBZ            --备注
      ,CJRQ           --采集日期
      ,AMOUNT         --面额
      ,B_ID
      ,JGZ_ID
      ,DATA_SRC_DESC  --数据来源中文
      ,ZCSFL          --资产三分类代码 --ADD BY LIP 20250410
      )
    WITH DATA_BASE AS
     (SELECT BA.*
        FROM RRP_MDL.O_IOL_CTMS_FBS_V_BALANCE BA
       WHERE BA.BALANCE_ID IN
             (SELECT MAX(BA1.BALANCE_ID)
                FROM RRP_MDL.O_IOL_CTMS_FBS_V_BALANCE BA1
               WHERE BA1.SETTLEDATE <= V_MONTH_END_DATEID
                 AND BA1.BUZTYPE = '外币拆借/同存'
               GROUP BY BA1.KEEPFOLDER_ID,BA1.ASSETTYPE,BA1.BUZTYPE,BA1.MINORASSETCODE,BA1.MAJORASSETCODE)
         AND (BA.SETTLEDATE >= V_MONTH_START_DATEID)),
    ASSET_LAST_PROFIT AS
     (SELECT BA.*
        FROM RRP_MDL.O_IOL_CTMS_FBS_V_BALANCE BA
       WHERE BA.BALANCE_ID IN
             (SELECT MAX(BA1.BALANCE_ID)
                FROM RRP_MDL.O_IOL_CTMS_FBS_V_BALANCE BA1
               WHERE BA1.SETTLEDATE <= TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH_END_DATEID,'YYYYMMDD'),-1),'YYYYMMDD')
                 AND BA1.BUZTYPE = '外币拆借/同存'
               GROUP BY BA1.KEEPFOLDER_ID,BA1.ASSETTYPE,BA1.BUZTYPE,BA1.MINORASSETCODE,BA1.MAJORASSETCODE))
    SELECT 'B1194H244050001'                                           AS JRXKZH --金融许可证号
           ,'896821'                                                   AS NBJGH --内部机构号
           ,'广东华兴银行股份有限公司总行'                             AS YXJGMC --银行机构名称
            ,CASE WHEN T2.IBO_TYPE = '0' AND T2.DEAL_DIR = '1'
                 THEN DECODE(T3.INTERBANKTYPE,'境内银行业存款类金融机构','20030101',
                                              --'境内银行业非存款类金融机构','20030101', --202507版改为 20030102 拆入境内非银行金融机构
                                              --'境内银行境外非独立法人','20030101', --MOD BY LIP 20250603 先改成这个科目，7月版再改为 20030201 拆入境外银行
                                              '境内银行业非存款类金融机构','20030102', --MOD BY LIP 20250707
                                              '境内银行境外非独立法人','20030201', --MOD BY LIP 20250707
                                              '境内证券业金融机构','20030102',
                                              '境内保险业金融机构','20030102',
                                              '境内金融控股公司','20030102',
                                              '境内交易及结算类金融机构','20030102',
                                              '境内其他金融机构','20030102',
                                              --'境内非银境外非独立法人','20030102', --MOD BY LIP 20250707 上游删除了这个分类
                                              '境外银行','20030201',
                                              '境外非银行','20030202',
                                              '-') --同业拆借-拆入
                 WHEN T2.IBO_TYPE = '0' AND T2.DEAL_DIR = '-1'
                 THEN DECODE(T3.INTERBANKTYPE,'境内银行业存款类金融机构','13020101',
                                              --'境内银行业非存款类金融机构','13020102', --202507版改为 13020102 拆放境内非银行金融机构
                                              --'境内银行境外非独立法人','13020101', --MOD BY LIP 20250603 先改成这个科目，7月版再改为 13020201 拆放境外银行
                                              '境内银行业非存款类金融机构','13020102', --MOD BY LIP 20250707
                                              '境内银行境外非独立法人','13020201', --MOD BY LIP 20250707
                                              '境内证券业金融机构','13020102',
                                              '境内保险业金融机构','13020102',
                                              '境内金融控股公司','13020102',
                                              '境内交易及结算类金融机构','13020102',
                                              '境内其他金融机构','13020102',
                                              --'境内非银境外非独立法人','13020102', --MOD BY LIP 20250707 上游删除了这个分类
                                              '境外银行','13020201',
                                              '境外非银行','13020202',
                                              '-') --同业拆借-拆出
                 WHEN T2.IBO_TYPE = '4' AND T2.COLLATERAL_METHOD = '质押'
                 THEN DECODE(T2.DEAL_DIR,'1','21110201','11110201')
                 WHEN T2.IBO_TYPE = '4' AND T2.COLLATERAL_METHOD = '买断'
                 THEN DECODE(T2.DEAL_DIR,'1','21110201','11110201')
             END                                                       AS MXKMBH --明细科目编号 --MODIFY BY TANGAN AT 20221031
           ,NULL                                                       AS MXKMMC --直接根据上面的明细科目编号，再统一关联总账科目表取最好 --明细科目名称
           ,T2.COUNTER_PARTY_ID || '_' || T2.DEAL_SQNO                 AS JRGJBH --金融工具编号
           ,T2.COUNTER_PARTY_SCNAME || '_' ||
            CASE WHEN T2.IBO_TYPE = '0'
                 THEN DECODE(T2.DEAL_DIR,'1','同业拆入','拆放同业')
                 WHEN T2.IBO_TYPE = '4' AND T2.COLLATERAL_METHOD = '质押'
                 THEN DECODE(T2.DEAL_DIR,'1','质押式正回购','质押式逆回购')
                 WHEN T2.IBO_TYPE = '4' AND T2.COLLATERAL_METHOD = '买断'
                 THEN DECODE(T2.DEAL_DIR,'1','买断式正回购','买断式逆回购')
             END                                                       AS JRGJMC --金融工具名称
           ,'银行账户'                                                 AS JYZHLX --账户类型
           ,'同业往来'                                                 AS YEDL --业务大类
           ,CASE WHEN T2.IBO_TYPE = '0' THEN DECODE(T2.DEAL_DIR,'1','拆入','拆出')
                 WHEN T2.IBO_TYPE = '4' THEN DECODE(T2.DEAL_DIR,'1','卖出回购','买入返售')
             END                                                       AS YEZL --业务中类
           ,CASE WHEN T2.IBO_TYPE = '0' AND T2.DEAL_DIR = '1'
                      AND T3.INTERBANKTYPE IN ('境内银行业存款类金融机构','境内银行业非存款类金融机构','境外银行')
                 THEN '拆入银行金融机构'
                 WHEN T2.IBO_TYPE = '0' AND T2.DEAL_DIR = '1' THEN '拆入非银行金融机构'
                 WHEN T2.IBO_TYPE = '0' AND T2.DEAL_DIR = '-1'
                      AND T3.INTERBANKTYPE IN ('境内银行业存款类金融机构','境内银行业非存款类金融机构','境外银行')
                 THEN '拆出银行金融机构'
                 WHEN T2.IBO_TYPE = '0' AND T2.DEAL_DIR = '-1' THEN '拆出非银行金融机构'
                 WHEN T2.IBO_TYPE = '4' THEN DECODE(T2.DEAL_DIR,'1','卖出回购证券','买入返售证券')
             END                                                       AS YEXL --业务小类
           ,CASE WHEN T2.IBO_TYPE = '0' THEN DECODE(T2.DEAL_DIR,'1','同业拆入','拆放同业')
                 WHEN T2.IBO_TYPE = '4' AND T2.COLLATERAL_METHOD = '质押'
                 THEN DECODE(T2.DEAL_DIR,'1','质押式正回购','质押式逆回购')
                 WHEN T2.IBO_TYPE = '4' AND T2.COLLATERAL_METHOD = '买断'
                 THEN DECODE(T2.DEAL_DIR,'1','买断式正回购','买断式逆回购')
             END                                                       AS CPMC --产品名称
           ,T2.CRNCY_CODE                                              AS BZ --币种
           ,CASE WHEN T1.SETTLEDATE >= TO_CHAR(T2.MATURITY_DATE,'YYYYMMDD') THEN 0
                 ELSE DECODE(T2.DEAL_DIR ,'1' ,ABS(T1.INTERESTCOST) ,ABS(T1.HOLDPOSITION))
             END                                                       AS CYCB --持有成本
           ,CASE WHEN T1.SETTLEDATE >= TO_CHAR(T2.MATURITY_DATE,'YYYYMMDD') THEN 0
                 ELSE ABS(T1.HOLDPOSITION)
             END                                                       AS ZMYE --账面余额
           ,T1.INTERESTEARNING - NVL(T4.INTERESTEARNING,0)             AS BQSY --本期收益 需要减去上一期的金额
           ,T1.INTERESTEARNING                                         AS LJSY --累计收益
           ,T2.RATE                                                    AS NHLL --年化利率  目前塞的是票面利率，因为平均成本没法弄
           ,NULL                                                       AS XYFXQZ --信用风险权重
           ,'正常'                                                     AS WJFL --五级分类
           ,NULL                                                       AS JZZB --减值准备
           ,TO_CHAR(T2.VALUE_DATE,'YYYYMMDD')                          AS QXRQ --起息日期
           ,TO_CHAR(T2.MATURITY_DATE,'YYYYMMDD')                       AS DQRQ --到期日期
           ,NULL                                                       AS BBZ --备注
           ,V_MONTH_END_DATEID                                         AS CJRQ --采集日期
           ,CASE WHEN T1.SETTLEDATE >= TO_CHAR(T2.MATURITY_DATE,'YYYYMMDD') THEN 0
                 ELSE ABS(T1.HOLDPOSITION)
             END                                                       AS AMOUNT --面额
           ,TO_CHAR(T1.MAJORASSETCODE)                                 AS B_ID
           ,TO_CHAR(T1.MAJORASSETCODE)                                 AS JGZ_ID
           ,'外币拆借/外币回购'                                        AS DATA_SRC_DESC --数据来源中文
           ,DECODE(T1.ASSETTYPE,'交易性金融资产','FVTPL','可供出售金融资产','FVOCI','AC') AS ZCSFL --资产三分类代码 --ADD BY LIP 20250410
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
       AND T4.KEEPFOLDER_ID = T1.KEEPFOLDER_ID
     WHERE 1 = 1;

    V_SQLCOUNT := SQL%ROWCOUNT;
    O_ERRCODE  := '0';
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP      := 8;
    V_STEP_DESC := '自营资金业务余额表_债券及同业存单投资';
    V_STARTTIME := SYSDATE;
    --自营资金业务余额表_债券及同业存单投资
    INSERT INTO RRP_EAST.EAST5_1004_ZYZJYWYEB_ZJ
      (JRXKZH         --金融许可证号
      ,NBJGH          --内部机构号
      ,YHJGMC         --银行机构名称
      ,MXKMBH         --明细科目编号
      ,MXKMMC         --明细科目名称
      ,JRGJBH         --金融工具编号
      ,JRGJMC         --金融工具名称
      ,JYZHLX         --账户类型
      ,YEDL           --业务大类
      ,YWZL           --业务中类
      ,YWXL           --业务小类
      ,CPMC           --产品名称
      ,BZ             --币种
      ,CYCB           --持有成本
      ,ZMYE           --账面余额
      ,BQSY           --本期收益
      ,LJSY           --累计收益
      ,NHLL           --年化利率
      ,XYFXQZ         --信用风险权重
      ,WJFL           --五级分类
      ,JZZB           --减值准备
      ,QXRQ           --起息日期
      ,DQRQ           --到期日期
      ,BBZ            --备注
      ,CJRQ           --采集日期
      ,AMOUNT         --面额
      ,B_ID
      ,JGZ_ID
      ,DATA_SRC_DESC  --数据来源中文
      ,ZCSFL          --资产三分类代码 --ADD BY LIP 20250410
      )
    WITH DATA_BASE AS
     (SELECT BA.*,KF.CONTROLFACTOR
        FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA
       INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_KEEPFOLDER KF
          ON KF.KEEPFOLDER_ID = BA.KEEPFOLDER_ID
       WHERE BA.BALANCE_ID IN
             (SELECT MAX(BA1.BALANCE_ID)
                FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA1
               WHERE BA1.SETTLEDATE <= V_MONTH_END_DATEID
                 AND (BA1.BUZTYPE IN ('现券','债券负债') AND BA1.MAJORASSETCODE = BA1.MINORASSETCODE)
                 AND NVL(BA1.BARETRADENAME,'-') <> 'CARRYOVERDEALS'
               GROUP BY BA1.ASPCLIENT_ID,BA1.KEEPFOLDER_ID,BA1.ASSETTYPE,BA1.BUZTYPE,BA1.MINORASSETCODE,BA1.MAJORASSETCODE)
         AND (BA.HOLDPOSITION <> 0 OR BA.SETTLEDATE >= V_MONTH_START_DATEID)),
    LAST_BALANCE AS
     (SELECT BA.*
        FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA
       WHERE BA.BALANCE_ID IN
             (SELECT MAX(BA1.BALANCE_ID)
                FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE BA1
               WHERE BA1.SETTLEDATE <= TO_CHAR(ADD_MONTHS(TO_DATE(V_MONTH_END_DATEID,'YYYYMMDD'),-1),'YYYYMMDD')
                 AND (BA1.BUZTYPE IN ('现券','债券负债') AND BA1.MAJORASSETCODE = BA1.MINORASSETCODE)
               GROUP BY BA1.ASPCLIENT_ID,BA1.KEEPFOLDER_ID,BA1.ASSETTYPE,BA1.BUZTYPE,BA1.MINORASSETCODE,BA1.MAJORASSETCODE))
    SELECT 'B1194H244050001'                                           AS JRXKZH --金融许可证号
           ,M.DEPARTMENTID                                             AS NBJGH --内部机构号
           ,'广东华兴银行股份有限公司总行'                             AS YXJGMC --银行机构名称
           /*,CASE WHEN T1.BUZTYPE = '现券' AND T1.ASSETTYPE = '交易性金融资产'
                 THEN CASE WHEN T2.ISSUER IN ('中华人民共和国铁道部','中国铁路总公司','中国国家铁路集团有限公司')
                           THEN '1101011501'
                           WHEN T2.ISSUER IN ('中国进出口银行','中国农业发展银行','国家开发银行') OR T2.SECURITY_TYPE_NEW = '8'
                           THEN '1101011301'
                           WHEN T2.SECURITY_TYPE_NEW IN ('61','C1','C2','C3','C4','C5','C6','7','U','9','L','X')
                           THEN '1101011401'
                           WHEN T2.SECURITY_TYPE_NEW = '1' THEN '1101011101'
                           WHEN T2.SECURITY_TYPE_NEW = '5' THEN '1101011201'
                           WHEN T2.ISSUER = '中央汇金投资有限责任公司'
                                OR T2.SECURITY_TYPE_NEW IN ('N','6','O','P','V','4','E','L1','D','J')
                           THEN '1101011601'
                           WHEN T2.SECURITY_TYPE_NEW = 'M' THEN '1101011701'
                           WHEN T2.SECURITY_TYPE_NEW = 'W' THEN '1101011901'
                           WHEN T2.SECURITY_TYPE_NEW = 'Z' THEN '1101012001'
                           ELSE '1101011801'
                       END
                 WHEN T1.BUZTYPE = '现券' AND T1.ASSETTYPE = '可供出售金融资产'
                 THEN CASE WHEN T2.ISSUER IN ('中华人民共和国铁道部','中国铁路总公司','中国国家铁路集团有限公司')
                           THEN '15031501'
                           WHEN T2.ISSUER IN ('中国进出口银行','中国农业发展银行','国家开发银行') OR T2.SECURITY_TYPE_NEW = '8'
                           THEN '15031301'
                           WHEN T2.SECURITY_TYPE_NEW IN ('61','C1','C2','C3','C4','C5','C6','7','U','9','L','X')
                           THEN '15031401'
                           WHEN T2.SECURITY_TYPE_NEW = '1' THEN '15031101'
                           WHEN T2.SECURITY_TYPE_NEW = '5' THEN '15031201'
                           WHEN T2.ISSUER IN ('中央汇金投资有限责任公司')
                                OR T2.SECURITY_TYPE_NEW IN ('N','6','O','P','V','4','E','L1','D','J')
                           THEN  '15031601'
                           WHEN T2.SECURITY_TYPE_NEW = 'M' THEN  '15031701'
                           WHEN T2.SECURITY_TYPE_NEW = 'W' THEN  '15032001'
                           WHEN T2.SECURITY_TYPE_NEW = 'Z' THEN  '15032501'
                           ELSE '15031801'
                       END
                 WHEN T1.BUZTYPE = '现券' AND T1.ASSETTYPE = '持有至到期投资'
                 THEN CASE WHEN T2.ISSUER IN ('中华人民共和国铁道部','中国铁路总公司','中国国家铁路集团有限公司')
                           THEN '15011501'
                           WHEN T2.ISSUER IN ('中国进出口银行','中国农业发展银行','国家开发银行') OR T2.SECURITY_TYPE_NEW = '8'
                           THEN '15011301'
                           WHEN T2.SECURITY_TYPE_NEW IN ('61','C1','C2','C3','C4','C5','C6','7','U','9','L','X')
                           THEN '15011401'
                           WHEN T2.SECURITY_TYPE_NEW = '1' THEN '15011101'
                           WHEN T2.SECURITY_TYPE_NEW = '5' THEN '15011201'
                           WHEN T2.ISSUER IN ('中央汇金投资有限责任公司')
                                OR T2.SECURITY_TYPE_NEW IN ('N','6','O','P','V','4','E','L1','D','J')
                           THEN '15011601'
                           WHEN T2.SECURITY_TYPE_NEW = 'M' THEN '15011701'
                           WHEN T2.SECURITY_TYPE_NEW = 'W' THEN '15011901'
                           WHEN T2.SECURITY_TYPE_NEW = 'Z' THEN '15012001'
                           ELSE '15011801'
                       END
                 WHEN T1.BUZTYPE = '债券负债' THEN '210101'
            END                                                        AS MXKMBH --明细科目编号*/
            ,CASE WHEN T1.BUZTYPE = '现券' AND T1.ASSETTYPE = '交易性金融资产'
                 THEN CASE /*WHEN T2.ISSUER IN ('中华人民共和国铁道部','中国铁路总公司','中国国家铁路集团有限公司')
                           THEN '11010101'
                           WHEN T2.ISSUER IN ('中国进出口银行','中国农业发展银行','国家开发银行') OR T2.SECURITY_TYPE_NEW = '8'
                           THEN '11010101'
                           WHEN T2.SECURITY_TYPE_NEW IN ('61','C1','C2','C3','C4','C5','C6','7','U','9','L','X','C9')
                           THEN '11010101'
                           WHEN T2.SECURITY_TYPE_NEW = '1' THEN '11010101'
                           WHEN T2.SECURITY_TYPE_NEW = '5' THEN '11010101'
                           WHEN T2.ISSUER = '中央汇金投资有限责任公司'
                                OR T2.SECURITY_TYPE_NEW IN ('N','6','O','P','V','4','E','L1','D','J')
                           THEN '11010101'
                           WHEN T2.SECURITY_TYPE_NEW = 'M' THEN '11010101'*/
                           --MOD BY LIP 20250512 新一代后只有这四种科目的映射
                           WHEN T2.SECURITY_TYPE_NEW = 'W' THEN '11010201'
                           WHEN T2.SECURITY_TYPE_NEW IN ('L','L1') THEN '11010301' --ADD BY LIP 20250509 根据上游反馈调整
                           WHEN T2.SECURITY_TYPE_NEW = 'Z' THEN '11010401'
                           --ELSE '11019901'
                           ELSE '11010101' --MOD BY LIP 20250509 根据上游反馈调整
                       END
                 WHEN T1.BUZTYPE = '现券' AND T1.ASSETTYPE = '可供出售金融资产'
                 THEN CASE /*WHEN T2.ISSUER IN ('中华人民共和国铁道部','中国铁路总公司','中国国家铁路集团有限公司')
                           THEN '15030101'
                           WHEN T2.ISSUER IN ('中国进出口银行','中国农业发展银行','国家开发银行') OR T2.SECURITY_TYPE_NEW = '8'
                           THEN '15030101'
                           WHEN T2.SECURITY_TYPE_NEW IN ('61','C1','C2','C3','C4','C5','C6','7','U','9','L','X','C9') --MOD BY LIP 20240830 增加C9
                           THEN '15030101'
                           WHEN T2.SECURITY_TYPE_NEW = '1' THEN '15030101'
                           WHEN T2.SECURITY_TYPE_NEW = '5' THEN '15030101'
                           WHEN T2.ISSUER IN ('中央汇金投资有限责任公司')
                                OR T2.SECURITY_TYPE_NEW IN ('N','6','O','P','V','4','E','L1','D','J')
                           THEN '15030101'
                           WHEN T2.SECURITY_TYPE_NEW = 'M' THEN '15030101'*/
                           --MOD BY LIP 20250512 新一代后只有这四种科目的映射
                           WHEN T2.SECURITY_TYPE_NEW = 'W' THEN '15030201'
                           WHEN T2.SECURITY_TYPE_NEW = 'Z' THEN '15030401'
                           WHEN T2.SECURITY_TYPE_NEW IN ('L','L1') THEN '15030301' --ADD BY LIP 20250509 根据上游反馈调整
                           WHEN T2.SECURITY_TYPE_NEW IN ('S','F') THEN '15030101' --MOD BY LIP 20241010 15030101 计入其他综合收益的债券面值 --MOD BY LIP 20250506 增加F的映射
                           --ELSE '15039901'
                           ELSE '15030101' --MOD BY LIP 20250509 根据上游反馈调整
                       END
                 WHEN T1.BUZTYPE = '现券' AND T1.ASSETTYPE = '持有至到期投资'
                 THEN CASE /*WHEN T2.ISSUER IN ('中华人民共和国铁道部','中国铁路总公司','中国国家铁路集团有限公司')
                           THEN '15010101'
                           WHEN T2.ISSUER IN ('中国进出口银行','中国农业发展银行','国家开发银行') OR T2.SECURITY_TYPE_NEW = '8'
                           THEN '15010101'
                           WHEN T2.SECURITY_TYPE_NEW IN ('61','C1','C2','C3','C4','C5','C6','7','U','9','L','X','C9')
                           THEN '15010101'
                           WHEN T2.SECURITY_TYPE_NEW = '1' THEN '15010101'
                           WHEN T2.SECURITY_TYPE_NEW = '5' THEN '15010101'
                           WHEN T2.ISSUER IN ('中央汇金投资有限责任公司')
                                OR T2.SECURITY_TYPE_NEW IN ('N','6','O','P','V','4','E','L1','D','J')
                           THEN '15010101'
                           WHEN T2.SECURITY_TYPE_NEW = 'M' THEN '15010101'*/
                           --MOD BY LIP 20250512 新一代后只有这四种科目的映射
                           WHEN T2.SECURITY_TYPE_NEW = 'W' THEN '15010201'
                           WHEN T2.SECURITY_TYPE_NEW IN ('L','L1') THEN '15010301' --ADD BY LIP 20250509 根据上游反馈调整
                           WHEN T2.SECURITY_TYPE_NEW = 'Z' THEN '15010401'
                           ELSE '15010101'
                       END
                 WHEN T1.BUZTYPE = '债券负债' THEN '21010101'
            END                                                        AS MXKMBH --明细科目编号 --MODIFY BY TANGAN AT 20221031
           ,NULL                                                       AS MXKMMC --明细科目名称
           ,NVL(T5.EXTRA_CODE,T1.MAJORASSETCODE)                       AS JRGJBH --金融工具编号
           ,T2.SECURITY_NAME                                           AS JRGJMC --金融工具名称
           ,DECODE(T1.CONTROLFACTOR,'NT','交易账户','银行账户')        AS JYZHLX --账户类型
           ,CASE WHEN T2.SECURITY_TYPE_NEW = 'W' THEN '同业往来'
                 ELSE '债券投资与同业投资'
             END                                                       AS YEDL --业务大类
           ,CASE WHEN T2.SECURITY_TYPE_NEW = 'W' THEN '同业存单'
                 ELSE '债券投资'
             END                                                       AS YEZL --业务中类
           ,CASE WHEN T2.SECURITY_TYPE_NEW = 'W' THEN '同业存单投资'
                 WHEN T2.SECURITY_TYPE_NEW = '1' THEN '国债'
                 WHEN T2.SECURITY_TYPE_NEW = 'M' THEN '地方政府债'
                 WHEN T2.SECURITY_TYPE_NEW = '5' THEN '央票'
                 WHEN T2.SECURITY_TYPE_NEW = 'Q' THEN '政府支持机构债'
                 WHEN T2.ISSUER IN ('中国进出口银行','中国农业发展银行','国家开发银行') OR T2.SECURITY_TYPE_NEW = '8'
                 THEN '政策性金融债'
                 --MOD BY HUANGCHANG 20230529
                 --WHEN T2.SECURITY_TYPE_NEW IN ('61','C1','C2','C3','C4','C5','C6','C9','7','U','9','L','X','Y')
                 WHEN T2.SECURITY_TYPE_NEW IN ('61','C1','C2','C3','C4','C5','C6','C9','7','U','9','X','Y')
                 THEN '商业性金融债'
                 WHEN T2.SECURITY_TYPE_NEW IN ('N','6','O','P','V','4','E','G','D','J','I','H')
                 THEN '非金融企业债券'
                 WHEN T2.SECURITY_TYPE_NEW = 'L' THEN '资产支持证券（信贷资产证券化）'
                 WHEN T2.SECURITY_TYPE_NEW = 'L1' THEN '资产支持证券（资产支持票据）'
                 WHEN T2.SECURITY_TYPE_NEW IN ('F','FL','FG','S') THEN '外国债券' --MOD BY LIP 20241017 增加S的映射
                 ELSE '其他-银行自定义'
             END                                                       AS YEXL --业务小类
           ,T2.SECURITY_NAME                                           AS CPMC --产品名称
           ,T2.CCY                                                     AS BZ --币种
           ,DECODE(T1.BUZTYPE,'债券负债',T1.INTERESTCOST,
                   DECODE(T1.ASSETTYPE,'交易性金融资产',T1.CLEANPRICECOST,T1.HOLDFACEAMOUNT)) AS CYCB --持有成本
           ,DECODE(T1.BUZTYPE,'债券负债',-1,1) *
            (DECODE(T1.ASSETTYPE,'交易性金融资产',T1.CLEANPRICECOST,T1.HOLDFACEAMOUNT) + T1.INTERESTADJUST + T1.FAIRVALUEALTER +
            (CASE WHEN T2.DISCOUNT_RATE = '0' AND T2.RATE_TYPE != '3' AND
                       (T2.PAYMENT_FREQ != '1Y' OR
                       (T2.PAYMENT_FREQ = '1Y'
                        AND TO_DATE(T2.MATURITY_DATE,'YYYYMMDD')-TO_DATE(T2.START_COUPON_DATE,'YYYYMMDD') > 366))
                  THEN 0
                  ELSE T1.INTERESTCOST
              END))                                                    AS ZMYE --账面余额
           ,CASE WHEN T1.BUZTYPE = '债券负债'
                 THEN - (T1.INTERESTEARNING + T1.FAIRVALUEINCOME + T1.PRICEEARNING)
                      + (NVL(T1.INTERESTEARNING,0) + NVL(T1.FAIRVALUEINCOME,0) + NVL(T1.PRICEEARNING,0))
                 ELSE T1.INTERESTEARNING + T1.AMORTIZEEARNING + T1.FAIRVALUEINCOME + T1.PRICEEARNING -
                      (NVL(T3.INTERESTEARNING,0) + NVL(T3.AMORTIZEEARNING,0) +
                      NVL(T3.FAIRVALUEINCOME,0) + NVL(T3.PRICEEARNING,0))
             END                                                       AS BQSY --本期收益 需要减去上一期的金额
           ,DECODE(T1.BUZTYPE,'债券负债',- (T1.INTERESTEARNING + T1.FAIRVALUEINCOME + T1.PRICEEARNING),
                              T1.INTERESTEARNING + T1.AMORTIZEEARNING + T1.FAIRVALUEINCOME + T1.PRICEEARNING) AS LJSY --累计收益
           ,DECODE(T2.DISCOUNT_RATE,'1',T2.AUTION_RATE,T2.FIXED_RATE)  AS NHLL --年化利率 目前塞的是票面利率，因为平均成本没法弄
           ,NULL                                                       AS XYFXQZ --信用风险权重
           ,'正常'                                                     AS WJFL --五级分类
           ,NULL                                                       AS JZZB --减值准备
           ,TRIM(T2.START_COUPON_DATE)                                 AS QXRQ --起息日期
           ,TRIM(T2.MATURITY_DATE)                                     AS DQRQ --到期日期
           ,NULL                                                       AS BBZ --备注
           ,V_MONTH_END_DATEID                                         AS CJRQ --采集日期
           ,T1.HOLDPOSITION                                            AS AMOUNT --面额
           ,DECODE(T1.BUZTYPE,'现券',NVL(T5.EXTRA_CODE,T1.MAJORASSETCODE) || '_' ||
                  DECODE(T1.ASSETTYPE,'交易性金融资产','FVTPL','可供出售金融资产','FVOCI','AC') || '_' ||
                  T1.KEEPFOLDER_ID,NULL)                               AS B_ID
           ,DECODE(T1.BUZTYPE,'现券',T1.MAJORASSETCODE || '_' ||
                  DECODE(T1.ASSETTYPE,'交易性金融资产','FVTPL','可供出售金融资产','FVOCI','AC') || '_' ||
                  T1.KEEPFOLDER_ID,NULL)                               AS JGZ_ID
           ,'债券及同业存单投资'                                       AS DATA_SRC_DESC --数据来源中文
           ,DECODE(T1.ASSETTYPE,'交易性金融资产','FVTPL','可供出售金融资产','FVOCI','AC') AS ZCSFL --资产三分类代码 --ADD BY LIP 20250410
      FROM DATA_BASE T1
      --FROM RRP_MDL.O_IOL_CTMS_TBS_V_BALANCE T1
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_V_SECURITY T2
        ON T2.SECURITY_CODE = T1.MAJORASSETCODE
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_INTERFACE_PORTF_DEPART_MAPPING M
        ON M.KEEPFOLDER_ID = T1.KEEPFOLDER_ID
      LEFT JOIN LAST_BALANCE T3
        ON T3.ASSETTYPE = T1.ASSETTYPE
       AND T3.BUZTYPE = T1.BUZTYPE
       AND T3.MINORASSETCODE = T1.MINORASSETCODE
       AND T3.MAJORASSETCODE = T1.MAJORASSETCODE
       AND T3.KEEPFOLDER_ID = T1.KEEPFOLDER_ID
      LEFT JOIN RRP_MDL.O_IOL_CTMS_TBS_SECURITY_EXTRA_CODE T5
        ON T5.SECURITY_CODE = T1.MAJORASSETCODE
     WHERE T1.BUZTYPE IN ('现券','债券负债');

    V_SQLCOUNT := SQL%ROWCOUNT;
    O_ERRCODE  := '0';
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP      := 9;
    V_STEP_DESC := '自营资金业务余额表_同业系统';
    V_STARTTIME := SYSDATE;
    --自营资金业务余额表_同业系统
    INSERT INTO RRP_EAST.EAST5_1004_ZYZJYWYEB_TY
      (JRXKZH         --金融许可证号
      ,NBJGH          --内部机构号
      ,YHJGMC         --银行机构名称
      ,MXKMBH         --明细科目编号
      ,MXKMMC         --明细科目名称
      ,JRGJBH         --金融工具编号
      ,JRGJMC         --金融工具名称
      ,JYZHLX         --账户类型
      ,YEDL           --业务大类
      ,YWZL           --业务中类
      ,YWXL           --业务小类
      ,CPMC           --产品名称
      ,BZ             --币种
      ,CYCB           --持有成本
      ,ZMYE           --账面余额
      ,BQSY           --本期收益
      ,LJSY           --累计收益
      ,NHLL           --年化利率
      ,XYFXQZ         --信用风险权重
      ,WJFL           --五级分类
      ,JZZB           --减值准备
      ,QXRQ           --起息日期
      ,DQRQ           --到期日期
      ,BBZ            --备注
      ,CJRQ           --采集日期
      ,CORE_SYS_CUSTOMER_CODE --核心客户号
      ,AMOUNT         --面额
      ,PRIMARYKEY     --主键
      ,OBJ_ID         --核算对象ID
      ,DATA_SRC_DESC  --数据来源中文
      ,PRIMARYKEY_BF  --主键_巴三前 --ADD BY LIP 20250217
      ,OBJ_ID_BF      --核算对象ID_OBJ_ID --ADD BY LIP 20250217
      ,ZCSFL          --资产三分类代码 --ADD BY LIP 20250410
      )
    WITH INPUTPARAMS AS
     (SELECT TO_CHAR(TO_DATE(V_MONTH_START_DATEID,'YYYYMMDD'),'YYYY-MM-DD') FIRSTDATE,
             --TO_CHAR(TO_DATE(V_MONTH_END_DATEID,'YYYYMMDD'),'YYYY-MM-DD') BEGDATE FROM DUAL
             TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD'),'YYYY-MM-DD') BEGDATE FROM DUAL), --MOD BY LIP 20250220
    PARAMS AS
     (SELECT FIRSTDATE,
             BEGDATE,
             TO_CHAR(TO_DATE(FIRSTDATE,'YYYY-MM-DD') - 1,'YYYY-MM-DD') FIRSTLASTDATE,
             TO_CHAR(TRUNC(TO_DATE(BEGDATE,'YYYY-MM-DD'),'MM') - 1,'YYYY-MM-DD') LASTDATE,
             TO_CHAR(TRUNC(TO_DATE(BEGDATE,'YYYY-MM-DD'),'YY') - 1,'YYYY-MM-DD') LASTYEARDATE
        FROM INPUTPARAMS),
    ACCTG AS
     (SELECT /*+MATERIALIZE*/*
        FROM (SELECT ROW_NUMBER() OVER(PARTITION BY A.ACCTG_OBJ_ID ORDER BY A.BEG_DATE DESC) FK,
                     A.ACCTG_OBJ_ID,A.SUBJ_CODE,A.CORE_ACCT_NAME
                FROM RRP_MDL.O_IOL_IBMS_TTRD_BOOKKEEPING_OBJ_ACCTG A
                LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_ACCOUNTING_ENTRY_DEF D
                  ON D.ACTING_CODE = A.SUBJ_CODE
               WHERE D.GZB_TYPE = '1'
                 AND A.BEG_DATE <= (SELECT BEGDATE FROM PARAMS)) A
       WHERE A.FK = 1),
    ICODE_CHG AS
     (SELECT /*+MATERIALIZE*/DISTINCT C.ACCTG_OBJ_ID,TRD.I_CODE,TRD.A_TYPE,TRD.M_TYPE
        FROM (SELECT INST_ID,ERASE_REF_CHG_ID,I_CODE,A_TYPE,M_TYPE,ACCTG_OBJ_ID
                FROM RRP_MDL.O_IOL_IBMS_TTRD_ACCOUNTING_SECU_CHG
               UNION ALL
              SELECT INST_ID,ERASE_REF_CHG_ID,I_CODE,A_TYPE,M_TYPE,ACCTG_OBJ_ID
                FROM RRP_MDL.O_IOL_IBMS_TTRD_ACCOUNTING_SECU_CHG_HIS) C
        LEFT JOIN RRP_MDL.O_IOL_IBMS_VTRD_SET_INSTRUCTION_SECU SE
          ON SE.SECU_INST_ID = C.INST_ID
        LEFT JOIN RRP_MDL.O_IOL_IBMS_VTRD_SET_INSTRUCTION V
          ON V.INST_ID = SE.INST_ID
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
    ZHLXVIEW AS
     (SELECT /*+MATERIALIZE*/*
        FROM (SELECT SECU_ACCID,TRADE_GRP_ID,I_CODE,A_TYPE,M_TYPE,CREDIT_SECU_TYPE,
                     ROW_NUMBER() OVER(PARTITION BY SECU_ACCID,TRADE_GRP_ID,I_CODE,A_TYPE,M_TYPE ORDER BY SETDATE DESC) FK
                FROM (SELECT TRD.SECU_ACCID,
                             --COALESCE(TRD.TRADE_GRP_ID,'-1') TRADE_GRP_ID,
                             COALESCE(TRIM(TRD.TRADE_GRP_ID),'-1') TRADE_GRP_ID, --MOD BY LIP 20250103
                             CASE WHEN TRD.TRDTYPE IN ('0201100','0202100') THEN S.U_I_CODE
                                  ELSE TRD.I_CODE
                              END I_CODE,
                             CASE WHEN TRD.TRDTYPE IN ('0201100','0202100') THEN S.U_A_TYPE
                                  ELSE TRD.A_TYPE
                              END A_TYPE,
                             CASE WHEN TRD.TRDTYPE IN ('0201100','0202100') THEN S.U_M_TYPE
                                  ELSE TRD.M_TYPE
                              END M_TYPE,
                             TRD.CREDIT_SECU_TYPE,
                             TRD.SETDATE
                        FROM RRP_MDL.O_IOL_IBMS_TTRD_OTC_TRADE TRD
                        LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_INSTRUMENT S
                          ON S.I_CODE = TRD.I_CODE
                         AND S.A_TYPE = TRD.A_TYPE
                         AND S.M_TYPE = TRD.M_TYPE
                       WHERE TRD.ORDSTATUS = 4
                         AND TRD.INSSTATUS = 999
                         AND TRD.TRDTYPE IN ('0000000','0706080','0702080','0702150','0700080','0201100','0202100')
                         AND TRD.CREDIT_SECU_TYPE IS NOT NULL
                         AND TRD.SETDATE <= (SELECT BEGDATE FROM PARAMS)) TRD)
       WHERE FK = 1)
    SELECT NULL                                                        JRXKZH, --金融许可证号
           INST.ORG_ID                                                 NBJGH, --内部机构号
           NULL                                                        YHJGMC, --银行机构名称
           A.SUBJ_CODE                                                 MXKMBH, --明细科目编号
           A.CORE_ACCT_NAME                                            MXKMMC, --明细科目名称
           COALESCE(IC.I_CODE || IC.A_TYPE || IC.M_TYPE,T.I_CODE || T.A_TYPE || T.M_TYPE) || INST.ORG_ID ||
                    CASE WHEN TRD.TRDTYPE = '0000081' THEN TO_CHAR(NRD.PARTYID)
                         ELSE ''
                     END                                               JRGJBH, --金融工具编号
           COALESCE(TB.B_NAME,TF.F_NAME,S.I_NAME)                      JRGJMC, --金融工具名称
           --DECODE(COALESCE(ZV.CREDIT_SECU_TYPE,TRD.CREDIT_SECU_TYPE),'Bank','银行账簿','Trade','交易账簿') JYZHLX, --账户类型
           --MODIFY BY LIP 20220826 根据校验账户类型非空时应填 银行账户、交易账户 修改
           DECODE(COALESCE(ZV.CREDIT_SECU_TYPE,TRD.CREDIT_SECU_TYPE),'Bank','银行账户','Trade','交易账户') JYZHLX, --账户类型
           ST.LTYPE                                                    YWDL, --业务大类
           ST.MTYPE                                                    YWZL, --业务中类
           ST.STYPE                                                    YWXL, --业务小类
           S.I_NAME                                                    CPMC, --产品名称
           S.CURRENCY                                                  BZ, --币种
           ABS(ROUND(CASE WHEN T.EXTRA_DIM = 'S' THEN T.PRFT_IR ELSE T.REAL_CP + T.DUE_CP END,2)) CYCB, --持有成本
           NULL                                                        ZMYE, --账面余额
           ROUND(T.PRFT_IR + T.PRFT_TRD + T.PRFT_FV - COALESCE(H.PRFT_IR + H.PRFT_TRD + H.PRFT_FV,0),2) BQSY, --本期收益
           --ROUND(T.PRFT_IR + T.PRFT_TRD + T.PRFT_FV - COALESCE(L.PRFT_IR + L.PRFT_TRD + L.PRFT_FV,0),2) LJSY, --累计收益
           --MODIFY BY LIP 20220829 根据孙若真邮件，将同业存单发行的修改为全部累计
           ROUND(T.PRFT_IR + T.PRFT_TRD + T.PRFT_FV - COALESCE(CASE WHEN ST.STYPE = '同业存单发行' THEN 0
                                                               ELSE L.PRFT_IR + L.PRFT_TRD + L.PRFT_FV
                                                       END,0),2)       LJSY, --累计收益
           ROUND(CASE WHEN TRD.TRDTYPE = '0000081' THEN NCD.ANNUAL_RATE
                      ELSE DECODE(COALESCE(TB.B_COUPON_TYPE,TO_CHAR(S.COUPON_TYPE)),'2',AD.AD_ACTUALRATE,
                                  COALESCE(TB.B_COUPON,S.COUPON)) * 100
                  END,4)                                               NHLL, --年化利率
           NULL                                                        XYFXQZ, --信用风险权重
           NULL                                                        WJFL, --五级分类
           DECODE(TRD.CREDIT_SECU_TYPE,'Trade',0,NULL)                 JZZB, --减值准备
           REPLACE(CASE WHEN S.P_TYPE IN ('0000','1100','1200') THEN TRIM(S.START_DATE)
                        WHEN S.P_TYPE IN ('0703','0706') THEN TRIM(TF.F_DATE)
                        WHEN S.P_TYPE IN ('0700') THEN '9999-12-31'
                        ELSE TRIM(S.START_DATE)
                    END,'-','')                                        QXRQ, --起息日期
           REPLACE(CASE WHEN S.P_TYPE IN ('0000','1100','1200') THEN TRIM(S.MTR_DATE)
                        WHEN S.P_TYPE IN ('0703','0706') THEN '9999-12-31'
                        WHEN S.P_TYPE IN ('0700') THEN '9999-12-31'
                        ELSE TRIM(S.MTR_DATE)
                    END,'-','')                                        DQRQ, --到期日期
           NULL                                                        BZH, --备注
           --REPLACE(P.BEGDATE,'-','')                                   CJRQ, --采集日期
           V_MONTH_END_DATEID                                          CJRQ, --采集日期 --MOD BY LIP 20250220
           PINST.CORE_SYS_CUSTOMER_CODE                                CORE_SYS_CUSTOMER_CODE, --核心客户号
           T.REAL_AMOUNT + T.DUE_AMOUNT                                AMOUNT, --面额
           CASE WHEN S.P_TYPE IN ('0000','1100','1200'/*,'0170'*/)
                --THEN T.OBJ_ID || '_' || T.I_CODE || '_' || DECODE(ACTG.I9_CLASS,1,'AC',2,'FVOCI',4,'FVTPL')
                THEN T.I_CODE || '_' || DECODE(ACTG.I9_CLASS,1,'AC',2,'FVOCI',4,'FVTPL') || '_' || T.OBJ_ID --MOD BY LIP 20241220 资本新规调整评级方式
                ELSE T.OBJ_ID
            END                                                        PRIMARYKEY, --主键
           /*T.OBJ_ID                                                    OBJ_ID, --核算对象ID*/
           COALESCE(IC.I_CODE,T.I_CODE)                                OBJ_ID, --核算对象ID --MODIFY BY TANGAN AT 20230530
           '同业系统'                                                  DATA_SRC_DESC, --数据来源中文
           CASE WHEN S.P_TYPE IN ('0000','1100','1200'/*,'0170'*/)
                THEN T.OBJ_ID || '_' || T.I_CODE || '_' || DECODE(ACTG.I9_CLASS,1,'AC',2,'FVOCI',4,'FVTPL')
                ELSE T.OBJ_ID
            END                                                        PRIMARYKEY_BF, --主键_巴三前 --ADD BY LIP 20250217
           T.OBJ_ID                                                    OBJ_ID_BF,     --核算对象ID_OBJ_ID --ADD BY LIP 20250217
           DECODE(ACTG.I9_CLASS,1,'AC',2,'FVOCI',4,'FVTPL')            ZCSFL          --资产三分类代码 --ADD BY LIP 20250410
      FROM (/*SELECT I_CODE,A_TYPE,M_TYPE,REAL_CP,DUE_CP,OBJ_ID,PRFT_IR,PRFT_TRD,PRFT_FV,SECU_ACCT_ID,TRADE_ID,
                   BEG_DATE,TRADE_GRP_ID,DUE_AMOUNT,REAL_AMOUNT,EXTRA_DIM
              FROM RRP_MDL.O_IOL_IBMS_TTRD_ACCOUNTING_SECU_OBJ T
             WHERE T.BEG_DATE = (SELECT BEGDATE FROM PARAMS)
            UNION ALL*/
            SELECT I_CODE,A_TYPE,M_TYPE,REAL_CP,DUE_CP,OBJ_ID,PRFT_IR,PRFT_TRD,PRFT_FV,SECU_ACCT_ID,TRADE_ID,
                   BEG_DATE,TRADE_GRP_ID,DUE_AMOUNT,REAL_AMOUNT,EXTRA_DIM
              FROM RRP_MDL.O_IOL_IBMS_TTRD_ACCOUNTING_SECU_OBJ_HIS T
             WHERE T.BEG_DATE = (SELECT BEGDATE FROM PARAMS)
            UNION ALL
            SELECT I_CODE,A_TYPE,M_TYPE,REAL_CP,DUE_CP,OBJ_ID,PRFT_IR,PRFT_TRD,PRFT_FV,SECU_ACCT_ID,TRADE_ID,
                   BEG_DATE,TRADE_GRP_ID,DUE_AMOUNT,REAL_AMOUNT,EXTRA_DIM
              FROM RRP_MDL.O_IOL_IBMS_TTRD_ACCOUNTING_SECU_OBJ_COMP T
             WHERE T.BEG_DATE <= (SELECT BEGDATE FROM PARAMS)
               AND T.END_DATE > (SELECT BEGDATE FROM PARAMS)) T
      LEFT JOIN (SELECT I_CODE,A_TYPE,M_TYPE,REAL_CP,DUE_CP,OBJ_ID,PRFT_IR,PRFT_TRD,PRFT_FV,SECU_ACCT_ID
                   FROM RRP_MDL.O_IOL_IBMS_TTRD_ACCOUNTING_SECU_OBJ_HIS H
                  WHERE H.BEG_DATE = (SELECT LASTDATE FROM PARAMS)
                 UNION ALL
                 SELECT I_CODE,A_TYPE,M_TYPE,REAL_CP,DUE_CP,OBJ_ID,PRFT_IR,PRFT_TRD,PRFT_FV,SECU_ACCT_ID
                   FROM RRP_MDL.O_IOL_IBMS_TTRD_ACCOUNTING_SECU_OBJ_COMP H
                  WHERE H.BEG_DATE <= (SELECT LASTDATE FROM PARAMS)
                    AND H.END_DATE > (SELECT LASTDATE FROM PARAMS)) H
        ON H.OBJ_ID = T.OBJ_ID
      LEFT JOIN (SELECT I_CODE,A_TYPE,M_TYPE,REAL_CP,DUE_CP,OBJ_ID,PRFT_IR,PRFT_TRD,PRFT_FV,SECU_ACCT_ID
                   FROM RRP_MDL.O_IOL_IBMS_TTRD_ACCOUNTING_SECU_OBJ_HIS H
                  WHERE BEG_DATE = (SELECT LASTYEARDATE FROM PARAMS)
                  UNION ALL
                 SELECT I_CODE,A_TYPE,M_TYPE,REAL_CP,DUE_CP,OBJ_ID,PRFT_IR,PRFT_TRD,PRFT_FV,SECU_ACCT_ID
                   FROM RRP_MDL.O_IOL_IBMS_TTRD_ACCOUNTING_SECU_OBJ_COMP T
                  WHERE BEG_DATE <= (SELECT LASTYEARDATE FROM PARAMS)
                    AND END_DATE > (SELECT LASTYEARDATE FROM PARAMS)) L
        ON L.OBJ_ID = T.OBJ_ID
      LEFT JOIN (SELECT I_CODE,A_TYPE,M_TYPE,REAL_CP,DUE_CP,OBJ_ID,PRFT_IR,PRFT_TRD,PRFT_FV,SECU_ACCT_ID
                   FROM RRP_MDL.O_IOL_IBMS_TTRD_ACCOUNTING_SECU_OBJ_HIS H
                  WHERE BEG_DATE = (SELECT FIRSTLASTDATE FROM PARAMS)
                 UNION ALL
                 SELECT I_CODE,A_TYPE,M_TYPE,REAL_CP,DUE_CP,OBJ_ID,PRFT_IR,PRFT_TRD,PRFT_FV,SECU_ACCT_ID
                   FROM RRP_MDL.O_IOL_IBMS_TTRD_ACCOUNTING_SECU_OBJ_COMP T
                  WHERE BEG_DATE <= (SELECT FIRSTLASTDATE FROM PARAMS)
                    AND END_DATE > (SELECT FIRSTLASTDATE FROM PARAMS)) F
        ON F.OBJ_ID = T.OBJ_ID
      LEFT JOIN ICODE_CHG IC
        ON IC.ACCTG_OBJ_ID = T.OBJ_ID
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_INSTRUMENT S
        ON S.I_CODE = COALESCE(IC.I_CODE,T.I_CODE)
       AND S.A_TYPE = COALESCE(IC.A_TYPE,T.A_TYPE)
       AND S.M_TYPE = COALESCE(IC.M_TYPE,T.M_TYPE)
      LEFT JOIN RRP_MDL.O_IOL_IBMS_VTRD_INSTRUMENT_FUND_MAPPING VM
        ON VM.I_CODE = S.I_CODE
       AND VM.A_TYPE = S.A_TYPE
       AND VM.M_TYPE = S.M_TYPE
      --LEFT JOIN SM_TYPE ST
      LEFT JOIN RRP_EAST.ADD_EAST5_ZYZJYW_YWXL_MAPPING ST --自营资金同业业务种类映射 MOD BY LIP 20241126 维护成参数表
        ON ST.PROD_CODE = VM.PROD_CODE
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_ACC_SECU ACC
        ON ACC.ACCID = T.SECU_ACCT_ID
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_ACCTG_ACCOUNT_TYPE ACTG
        ON ACTG.TYPEID = ACC.ACTING_TYPE
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_INSTITUTION INST
        ON INST.I_ID = ACC.I_ID
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_INSTITUTION PINST
        ON PINST.I_ID = S.PARTY_ID
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_OTC_TRADE TRD
        ON TRD.INTORDID = T.TRADE_ID
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_OTC_TRADE PTRD
        ON PTRD.SYSORDID = TRD.REF_SYSORDID
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_EQUITY TEQ
        ON TEQ.I_CODE = T.I_CODE
       AND TEQ.A_TYPE = T.A_TYPE
       AND TEQ.M_TYPE = T.M_TYPE
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TFND TF
        ON TF.I_CODE = T.I_CODE
       AND TF.A_TYPE = T.A_TYPE
       AND TF.M_TYPE = T.M_TYPE
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TBND TB
        ON TB.I_CODE = T.I_CODE
       AND TB.A_TYPE = T.A_TYPE
       AND TB.M_TYPE = T.M_TYPE
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TBSI_ACCRUALDETAIL AD
        ON AD.I_CODE = S.I_CODE
       AND AD.A_TYPE = S.A_TYPE
       AND AD.M_TYPE = S.M_TYPE
       AND AD.AD_STARTDATE <= T.BEG_DATE
       AND AD.AD_ENDDATE > T.BEG_DATE
      LEFT JOIN ACCTG A
        ON A.ACCTG_OBJ_ID = T.OBJ_ID
      LEFT JOIN ZHLXVIEW ZV
        ON ZV.I_CODE = T.I_CODE
       AND ZV.A_TYPE = T.A_TYPE
       AND ZV.M_TYPE = T.M_TYPE
       AND ZV.SECU_ACCID = T.SECU_ACCT_ID
       AND ZV.TRADE_GRP_ID = T.TRADE_GRP_ID
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_OTC_NCD NCD
        ON NCD.I_CODE = T.I_CODE
       AND NCD.A_TYPE = T.A_TYPE
       AND NCD.M_TYPE = T.M_TYPE
       AND NCD.INTORDID = PTRD.INTORDID
      --LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_NCD_RESULT_DETAILS NRD
      LEFT JOIN RRP_MDL.O_IOL_IBMS_VTRD_NCD_RESULT_DETAILS NRD --MOD BY LIP 20240429 根据同业反馈，调整取数表
        ON NRD.REF_SYSORDID = TRD.SYSORDID
       AND NRD.SYSORDID = TRD.REF_SYSORDID
       AND NRD.I_CODE = T.I_CODE
       AND NRD.A_TYPE = T.A_TYPE
       AND NRD.M_TYPE = T.M_TYPE
      LEFT JOIN PARAMS P
        ON 1 = 1
     WHERE (T.REAL_CP + T.DUE_CP <> 0 OR
           COALESCE(F.REAL_CP + F.DUE_CP,0) <> 0 OR
           T.PRFT_IR + T.PRFT_TRD + T.PRFT_FV - COALESCE(F.PRFT_IR + F.PRFT_TRD + F.PRFT_FV,0) <> 0)
       AND S.P_TYPE IN ('0000','1100','1200','0201','0202','0158','0150','0700','0703','0706','0170','0125','0121','0179',
                        '2000');--ADD BY LIP 20240219 增加'0179'银团同业借款数据 --MOD BY LIP 20250715 增加2000债权借贷

    V_SQLCOUNT := SQL%ROWCOUNT;
    O_ERRCODE  := '0';
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --ADD BY LIP 20241129 将信用风险的数据装入临时表
    V_STEP      := 10;
    V_STEP_DESC := '自营资金业务余额表_信用风险权重';
    V_STARTTIME := SYSDATE;
    EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_EAST.EAST5_1004_ZYZJYWYEB_RWA_XYFXQZ';
    /*INSERT INTO RRP_EAST.EAST5_1004_ZYZJYWYEB_RWA_XYFXQZ
      (LOAN_REF_NO           --借据号
      ,SPECIFIC_RISK_CHARGE  --信用风险权重
      ,TZL_RISK_CHARGE       --调整后信用风险权重
      ,NUM                   --序号
      )
    SELECT TT.LOAN_REF_NO,TT.SPECIFIC_RISK_CHARGE,TT.TZL_RISK_CHARGE,\*TT.FLG,*\
           ROW_NUMBER() OVER(PARTITION BY TT.LOAN_REF_NO ORDER BY TT.FLG) AS NUM
      FROM (SELECT T.LOAN_REF_NO,T.SPECIFIC_RISK_CHARGE,T.TZL_RISK_CHARGE,T.FLG
              FROM (SELECT LOAN_REF_NO,
                           REPLACE(TRIM(SPECIFIC_RISK_CHARGE),'%','') / 100 AS SPECIFIC_RISK_CHARGE,
                           (SPECIFIC_RISK_RATIO + REPLACE(TRIM(SPECIFIC_RISK_CHARGE),'%','') / 100) * 12.5 AS TZL_RISK_CHARGE,
                           ROW_NUMBER() OVER(PARTITION BY LOAN_REF_NO ORDER BY DATA_DATE DESC) AS NUM,
                           '1' AS FLG
                      FROM RRP_MDL.O_IOL_RWAS_RWA_REPORT_TRAN_SECURITIES --债项填报信息表
                     WHERE DATA_DATE <= TO_DATE(V_P_DATE,'YYYYMMDD')) T
              WHERE T.NUM = 1
             UNION ALL
             SELECT T.LOAN_REF_NO,T.SPECIFIC_RISK_CHARGE,T.TZL_RISK_CHARGE,T.FLG
               FROM (SELECT LOAN_REF_NO,
                            RWBANDID AS SPECIFIC_RISK_CHARGE,
                            RWBANDID AS TZL_RISK_CHARGE,
                            ROW_NUMBER() OVER(PARTITION BY LOAN_REF_NO ORDER BY DATA_DATE DESC) AS NUM,
                            '2' AS FLG
                       FROM RRP_MDL.O_IOL_RWAS_RWA_REPORT_FB_INVEST --债项填报信息表-非标表
                      WHERE DATA_DATE <= TO_DATE(V_P_DATE,'YYYYMMDD')) T
              WHERE T.NUM = 1
             UNION ALL
             SELECT T.LOAN_REF_NO,T.SPECIFIC_RISK_CHARGE,T.TZL_RISK_CHARGE,T.FLG
               FROM (SELECT LOAN_REF_NO,
                            CASE WHEN EAD_PROVISION = 0 THEN 0
                                 ELSE RWAAMOUNT / EAD_PROVISION
                             END AS SPECIFIC_RISK_CHARGE,
                            CASE WHEN EAD_PROVISION = 0 THEN 0
                                 ELSE RWAAMOUNT / EAD_PROVISION
                             END AS TZL_RISK_CHARGE,
                            ROW_NUMBER() OVER(PARTITION BY LOAN_REF_NO ORDER BY DATA_DATE DESC) AS NUM,
                            '3' AS FLG
                       FROM RRP_MDL.O_IOL_RWAS_RWA_REPORT_FUND --债项填报信息表-基金投资
                      WHERE DATA_DATE <= TO_DATE(V_P_DATE,'YYYYMMDD')) T
              WHERE T.NUM = 1
              UNION ALL
             SELECT T.LOAN_REF_NO,T.SPECIFIC_RISK_CHARGE,T.TZL_RISK_CHARGE,T.FLG
               FROM (SELECT LOAN_REF_NO,
                            RWBANDID AS SPECIFIC_RISK_CHARGE,
                            RWBANDID AS TZL_RISK_CHARGE,
                            ROW_NUMBER() OVER(PARTITION BY LOAN_REF_NO ORDER BY DATA_DATE DESC) AS NUM,
                            '4' AS FLG
                       FROM RRP_MDL.O_IOL_RWAS_RWA_REPORT_SEC_INVEST --债项填报信息表-ABS
                      WHERE DATA_DATE <= TO_DATE(V_P_DATE,'YYYYMMDD')) T
              WHERE T.NUM = 1
             UNION ALL
             SELECT T.LOAN_REF_NO,T.SPECIFIC_RISK_CHARGE,T.TZL_RISK_CHARGE,T.FLG
               FROM (SELECT LOAN_REF_NO,
                            RWBANDID AS SPECIFIC_RISK_CHARGE,
                            RWBANDID AS TZL_RISK_CHARGE,
                            ROW_NUMBER() OVER(PARTITION BY LOAN_REF_NO ORDER BY DATA_DATE DESC) AS NUM,
                            '5' AS FLG
                       FROM RRP_MDL.O_IOL_RWAS_RWA_REPORT_STD_LOAN --债项填报信息表-标准债权
                      WHERE DATA_DATE <= TO_DATE(V_P_DATE,'YYYYMMDD')) T
              WHERE T.NUM = 1) TT;*/
    --MOD BY LIP 20250103 信用风险的数据改为从资本新规数据出数
    INSERT INTO RRP_EAST.EAST5_1004_ZYZJYWYEB_RWA_XYFXQZ
      (LOAN_REF_NO           --借据号
      ,SPECIFIC_RISK_CHARGE  --信用风险权重
      ,TZL_RISK_CHARGE       --调整后信用风险权重
      ,NUM                   --序号
      )
    WITH TMP1 AS (
    SELECT /*+MATERIALIZE*/
           T.LOAN_REF_NO,AFTER_CRMRW AS SPECIFIC_RISK_CHARGE,
           ROW_NUMBER() OVER(PARTITION BY LOAN_REF_NO ORDER BY TRIM(CRM_NO) NULLS LAST) NUM --暂时先按这个排序
      FROM RRP_MDL.O_IOL_RWAS_MR_SA_RWA_RESULT_DETAIL T --计量_RWA计量明细结果表
     WHERE SRC_SYSTEM_ID NOT IN ('LHWD','BDMX')
       AND LOAN_REF_DESC NOT LIKE '%贷款%'
       AND DATA_DATE = TO_DATE(V_P_DATE,'YYYYMMDD')
       AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     UNION ALL
    SELECT T.LOAN_REF_NO,FM_AVG_RW AS SPECIFIC_RISK_CHARGE,0 NUM
      FROM RRP_MDL.O_IOL_RWAS_RPT_ASSET_MANAGER_RESULT T --内部管理报表_资管产品计量明细
     WHERE DATA_DATE = TO_DATE(V_P_DATE,'YYYYMMDD')
       AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     UNION ALL
    SELECT T.LOAN_REF_NO,SEC_RW_ADJ AS SPECIFIC_RISK_CHARGE,0 NUM
      FROM RRP_MDL.O_IOL_RWAS_RPT_ASSET_SECURITIZATION T --内部管理报表_资产证券化
     WHERE DATA_DATE = TO_DATE(V_P_DATE,'YYYYMMDD')
       AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     UNION ALL
    SELECT T.LOAN_REF_NO,/*T.CRM_WEIGHTING_RW,*/
           --RWA系统内部管理报表-回购里 第AX列风险加权资产 除以第AM列扣减准备金后的风险暴露 计算信用风险权重 而不是用AU列缓释加权权重直接计算
           CASE WHEN NVL(T.EAD_AFTERPRO,0) = 0 THEN 0 ELSE T.RWA / T.EAD_AFTERPRO END AS SPECIFIC_RISK_CHARGE, --MOD BY LIP 20250417
           0 NUM
      FROM RRP_MDL.O_IOL_RWAS_RPT_REPO T --内部管理报表_回购
     WHERE DATA_DATE = TO_DATE(V_P_DATE,'YYYYMMDD')
       AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
    SELECT LOAN_REF_NO            AS LOAN_REF_NO           --借据号
          ,SPECIFIC_RISK_CHARGE   AS SPECIFIC_RISK_CHARGE  --信用风险权重
          ,SPECIFIC_RISK_CHARGE   AS TZL_RISK_CHARGE       --调整后信用风险权重
          ,ROW_NUMBER() OVER(PARTITION BY LOAN_REF_NO ORDER BY NUM) AS NUM  --序号
      FROM TMP1;

    V_SQLCOUNT := SQL%ROWCOUNT;
    O_ERRCODE  := '0';
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP      := 11;
    V_STEP_DESC := '自营资金业务余额表_资金';
    V_STARTTIME := SYSDATE;
    --资金
    INSERT INTO RRP_EAST.EAST5_1004_ZYZJYWYEB_ZJ_R
      (RID              --数据主键
      ,JRXKZH           --金融许可证号
      ,NBJGH            --内部机构号
      ,YHJGMC           --银行机构名称
      ,MXKMBH           --明细科目编号
      ,MXKMMC           --明细科目名称
      ,JRGJBH           --金融工具编号
      ,JRGJMC           --金融工具名称
      ,JYZHLX           --账户类型
      ,YEDL             --业务大类
      ,YWZL             --业务中类
      ,YWXL             --业务小类
      ,CPMC             --产品名称
      ,BZ               --币种
      ,CYCB             --持有成本
      ,ZMYE             --账面余额
      ,BQSY             --本期收益
      ,LJSY             --累计收益
      ,NHLL             --年化利率
      ,XYFXQZ           --信用风险权重
      ,WJFL             --五级分类
      ,JZZB             --减值准备
      ,QXRQ             --起息日期
      ,DQRQ             --到期日期
      ,BBZ              --备注
      ,CJRQ             --采集日期
      ,DEPT_NO          --部门编号
      ,SRC_SYS_ID       --来源系统ID
      ,ISSUED_NO        --填报机构
      ,ORG_NO           --报送机构
      ,ADDRESS          --归属地
      ,GSFZJG           --归属分支机构
      ,DATA_SRC_DESC    --数据来源中文
      ,B_ID             --ADD BY LIP 20241219
      ,JGZ_ID           --ADD BY LIP 20241219
      ,ZCSFL            --资产三分类代码 --ADD BY LIP 20250410
      )
    SELECT SYS_GUID()                                                  AS RID,
           B.FIN_PERMIT_NO                                             AS JRXKZH,
           NVL(TRIM(B0.ORG_ID1),'896')                                 AS NBJGH,
           B.ORG_NM                                                    AS YHJGMC,
           SUBSTR(A.MXKMBH,1,8)                                        AS MXKMBH,
           NVL(TRIM(C.SUBJ_NM),C1.SUBJ_NM)                             AS MXKMMC,
           A.JRGJBH                                                    AS JRGJBH,
           A.JRGJMC                                                    AS JRGJMC,
           A.JYZHLX                                                    AS JYZHLX,
           A.YEDL                                                      AS YEDL,
           A.YWZL                                                      AS YWZL,
           A.YWXL                                                      AS YWXL,
           A.CPMC                                                      AS CPMC,
           A.BZ                                                        AS BZ,
           A.CYCB                                                      AS CYCB,
           A.ZMYE                                                      AS ZMYE,
           A.BQSY                                                      AS BQSY,
           A.LJSY                                                      AS LJSY,
           --A.NHLL                                                      AS NHLL,
           NVL(A.NHLL,0)                                               AS NHLL,
           /*CASE WHEN A.YEDL LIKE '%投资%' AND A.JYZHLX LIKE '%交易%' THEN E.TZL_RISK_CHARGE
                ELSE E.SPECIFIC_RISK_CHARGE * 1
            END                                                        AS XYFXQZ,*/
           CASE WHEN A.YEDL LIKE '%投资%' AND A.JYZHLX LIKE '%交易%' AND E.LOAN_REF_NO IS NOT NULL THEN E.TZL_RISK_CHARGE
                WHEN E.LOAN_REF_NO IS NOT NULL THEN E.SPECIFIC_RISK_CHARGE * 1
                WHEN A.YEDL LIKE '%投资%' AND A.JYZHLX LIKE '%交易%' AND E1.LOAN_REF_NO IS NOT NULL THEN E1.TZL_RISK_CHARGE
                WHEN E1.LOAN_REF_NO IS NOT NULL THEN E1.SPECIFIC_RISK_CHARGE * 1
            END                                                        AS XYFXQZ, --MOD BY LIP 20250313 调整美元的关联取数
           CASE WHEN F.V_REGUL_CLASSIF_CD/*LEVEL5_CLASS_CD*/ = '1' THEN '正常'
                WHEN F.V_REGUL_CLASSIF_CD/*LEVEL5_CLASS_CD*/ = '2' THEN '关注'
                WHEN F.V_REGUL_CLASSIF_CD/*LEVEL5_CLASS_CD*/ = '3' THEN '次级'
                WHEN F.V_REGUL_CLASSIF_CD = '4' THEN '可疑'
                WHEN F.V_REGUL_CLASSIF_CD = '5' THEN '损失'
                ELSE '正常'
            END                                                        AS WJFL,
           F.N_ECL_BEFORE                                              AS JZZB,
           TRIM(A.QXRQ)                                                AS QXRQ,
           TRIM(A.DQRQ)                                                AS DQRQ,
           A.BBZ                                                       AS BBZ,
           A.CJRQ                                                      AS CJRQ,
           '000'                                                       AS DEPT_NO,
           '01'                                                        AS SRC_SYS_ID,
           A.NBJGH                                                     AS ISSUED_NO,
           '000000'                                                    AS ORG_NO,
           ''                                                          AS ADDRESS,
           B.GSFZJG                                                    AS GSFZJG,
           A.DATA_SRC_DESC                                             AS DATA_SRC_DESC, --数据来源中文
           A.B_ID                                                      AS B_ID, --ADD BY LIP 20241219
           A.JGZ_ID                                                    AS JGZ_ID, --ADD BY LIP 20241219
           A.ZCSFL                                                     AS ZCSFL --资产三分类代码 --ADD BY LIP 20250410
      FROM RRP_EAST.EAST5_1004_ZYZJYWYEB_ZJ A
      LEFT JOIN RRP_MDL.ORG_CONFIG B0 --机构映射表
        ON B0.ORG_ID = A.NBJGH
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(TRIM(B0.ORG_ID1),'896')
       AND B.DATA_DT = V_MONTH_END_DATEID
      LEFT JOIN RRP_MDL.M_GL_INFO C --总账会计科目信息表
        ON C.SUBJ_ID = SUBSTR(A.MXKMBH,1,8) --科目报送到三级
       AND C.DATA_DT = V_MONTH_END_DATEID
      LEFT JOIN RRP_MDL.M_GL_INFO C1 --总账会计科目信息表
        ON C1.SUBJ_ID = SUBSTR(A.MXKMBH,1,8) --科目报送到三级
       AND C1.DATA_DT = V_MONTH_END_DATEID
      LEFT JOIN RRP_EAST.EAST5_1004_ZYZJYWYEB_RWA_XYFXQZ E --MOD BY LIP 20241129
        ON E.LOAN_REF_NO = A.B_ID
       AND E.NUM = 1
      LEFT JOIN RRP_EAST.EAST5_1004_ZYZJYWYEB_RWA_XYFXQZ E1 --MOD BY LIP 20250313
        ON E1.LOAN_REF_NO = A.JGZ_ID
       AND E1.NUM = 1
      LEFT JOIN (SELECT F1.*,
                        ROW_NUMBER() OVER(PARTITION BY F1.V_ID_NUMBER ORDER BY F1.D_DATE_DT DESC) AS NUM
                   FROM RRP_MDL.O_IOL_IFRS_FCT_ECL_RES_DTL F1
                  WHERE F1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) F --减值结果表
        ON F.V_ID_NUMBER = A.JGZ_ID
       AND F.NUM = 1
     WHERE A.CJRQ = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    O_ERRCODE  := '0';
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP      := 12;
    V_STEP_DESC := '自营资金业务余额表_同业';
    V_STARTTIME := SYSDATE;
    --同业
    INSERT INTO RRP_EAST.EAST5_1004_ZYZJYWYEB_TY_R
      (RID              --数据主键
      ,JRXKZH           --金融许可证号
      ,NBJGH            --内部机构号
      ,YHJGMC           --银行机构名称
      ,MXKMBH           --明细科目编号
      ,MXKMMC           --明细科目名称
      ,JRGJBH           --金融工具编号
      ,JRGJMC           --金融工具名称
      ,JYZHLX           --账户类型
      ,YEDL             --业务大类
      ,YWZL             --业务中类
      ,YWXL             --业务小类
      ,CPMC             --产品名称
      ,BZ               --币种
      ,CYCB             --持有成本
      ,ZMYE             --账面余额
      ,BQSY             --本期收益
      ,LJSY             --累计收益
      ,NHLL             --年化利率
      ,XYFXQZ           --信用风险权重
      ,WJFL             --五级分类
      ,JZZB             --减值准备
      ,QXRQ             --起息日期
      ,DQRQ             --到期日期
      ,BBZ              --备注
      ,CJRQ             --采集日期
      ,DEPT_NO          --部门编号
      ,SRC_SYS_ID       --来源系统ID
      ,ISSUED_NO        --填报机构
      ,ORG_NO           --报送机构
      ,ADDRESS          --归属地
      ,GSFZJG           --归属分支机构
      ,DATA_SRC_DESC    --数据来源中文
      ,PRIMARYKEY       --ADD BY LIP 20241219
      ,OBJ_ID           --ADD BY LIP 20241219
      ,PRIMARYKEY_BF    --主键_巴三前 --ADD BY LIP 20250217
      ,OBJ_ID_BF        --核算对象ID_OBJ_ID --ADD BY LIP 20250217
      ,ZCSFL            --资产三分类代码 --ADD BY LIP 20250410
      )
      WITH TMP_BOOK_BAL AS (--取账面余额
    --5 同业 同业现金借贷表出卖出回购和买入返售证券数据
    SELECT A.OBJ_ID /*A.FIN_INSTM_ID*/        AS FIN_INST_ID, --金融工具编号
           A.ACTL_BAL                         AS BOOK_BAL,    --账面余额
           A.BELONG_ORG_ID                    AS ORG_ID,      --机构编号
           '1'                                AS TAB_FLG
      FROM RRP_MDL.O_ICL_CMM_IBANK_CASH_DEBIT_CRDT A --同业现金借贷表
     WHERE TRIM(A.SUBJ_ID) IS NOT NULL
       AND A.ASSET_TYPE_NAME LIKE '%回购%'
       AND ABS(A.ACTL_BAL) > 0
       AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     UNION ALL
    --11 同业 同业现金借贷表出同业拆入和拆放同业数据
    SELECT A.OBJ_ID /*A.FIN_INSTM_ID*/        AS FIN_INST_ID, --金融工具编号
           --A.ACTL_BAL                         AS BOOK_BAL,  --账面余额
           ABS(A.ACTL_BAL)                    AS BOOK_BAL,    --账面余额 --MOD BY LIP 20230901
           A.BELONG_ORG_ID                    AS ORG_ID,      --机构编号
           '2'                                AS TAB_FLG
      FROM RRP_MDL.O_ICL_CMM_IBANK_CASH_DEBIT_CRDT A --同业现金借贷表
     WHERE SUBSTR(A.SUBJ_ID,1,4) IN ('1302','2003')
       AND ABS(A.ACTL_BAL) > 0
       AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     UNION ALL
    --13 同业 同业证券持仓表出同业存单发行数据
    --SELECT A.OBJ_ID || '_' || A.FIN_INSTM_ID || '_' AS FIN_INST_ID, --金融工具编号
    SELECT A.FIN_INSTM_ID || '_' || '_' || A.OBJ_ID AS FIN_INST_ID, --金融工具编号 --MOD BY LIP 20250217
           A.ACTL_BAL + A.INT_ADJ_AMT          AS BOOK_BAL,    --账面余额
           A.BELONG_ORG_ID                     AS ORG_ID,      --机构编号
           '3'                                 AS TAB_FLG
      FROM RRP_MDL.O_ICL_CMM_IBANK_SECU_POST A --同业证券持仓表
     WHERE A.ASSET_TYPE_NAME LIKE '%同业存单%'
       AND ABS(A.ACTL_BAL) > 0
       AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     UNION ALL
    --16 同业 同业债券投资表出债券投资数据
    --SELECT A.OBJ_ID || '_' || A.FIN_INSTM_ID || '_' || A.ASSET_THD_CLS_CD AS FIN_INST_ID, --金融工具编号
    SELECT A.FIN_INSTM_ID || '_' || A.ASSET_THD_CLS_CD || '_' || A.OBJ_ID AS FIN_INST_ID, --金融工具编号 --MOD BY LIP 20250211
           A.BOOK_BAL                          AS BOOK_BAL,    --账面余额
           A.BELONG_ORG_ID                     AS ORG_ID,      --机构编号
           '4'                                 AS TAB_FLG
      FROM RRP_MDL.O_ICL_CMM_IBANK_BOND_INVEST A --同业债券投资表
     WHERE ABS(A.BOOK_BAL) > 0
       AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     UNION ALL
    --17 同业 同业非标投资表出资产支持证券（资产支持票据）和公募基金投资、资产管理产品投资数据
    --SELECT A.OBJ_ID || '_' || A.FIN_INSTM_ID || '_' || A.ASSET_THD_CLS_CD AS FIN_INST_ID, --金融工具编号
    SELECT A.OBJ_ID                            AS FIN_INST_ID, --金融工具编号
           CASE WHEN A.ASSET_TYPE_NAME LIKE '%票据资管计划%' THEN A.BOOK_BAL
                --ELSE A.BOOK_BAL + ROUND(NVL(O.N_PV_VARIATION,0),2)
                --ELSE NVL(B.NET_PRICE_COST,0) + ROUND(NVL(O.N_PV_VARIATION,0),2) + NVL(B.ACRU_INT,0) --MOD BY LIP 20250220
                --MOD BY LIP 20260209 增加 应计利息金额+利息调整金额
                ELSE NVL(B.NET_PRICE_COST,0) + ROUND(NVL(O.N_PV_VARIATION,0),2) + NVL(B.ACRU_INT,0) + NVL(B.INT_ADJ_AMT,0)
                --ELSE NVL(A.CURRT_BAL,0) --账面金额中包含应收利息应收未收利息
            END                                AS BOOK_BAL,    --账面余额
           A.BELONG_ORG_ID                     AS ORG_ID,      --机构编号
           '5'                                 AS TAB_FLG
      FROM RRP_MDL.O_ICL_CMM_IBANK_NON_STD_INVEST A --同业非标投资表
      LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_SECU_POST B --同业证券持仓表 --MOD BY LIP 20250220
        ON B.OBJ_ID = A.OBJ_ID
       AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      /*LEFT JOIN RRP_MDL.O_IOL_IFRS_VAL_RPT_TRADE O --I9估值报告表 取公允价值变动
        ON O.V_ASSET_CODE = A.FIN_INSTM_ID
       AND O.V_THREE_CLASS = A.ASSET_THD_CLS_CD
       AND O.V_TRADE_NO = A.OBJ_ID
       AND O.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')*/
      LEFT JOIN RRP_MDL.O_IOL_IFRS_FCT_ECL_RES_DTL O --减值结果表
        ON O.V_ID_NUMBER = A.OBJ_ID
       AND O.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     WHERE A.ASSET_TYPE_NAME NOT LIKE '%货币基金%'
       AND ABS(A.BOOK_BAL) > 0
       AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     UNION ALL
    --18 同业 同业净值型产品投资表出资产管理计划、债券基金数据
    SELECT A.OBJ_ID /*A.FIN_INSTM_ID*/        AS FIN_INST_ID,  --金融工具编号
           A.BOOK_BAL                         AS BOOK_BAL,     --账面余额
           A.BELONG_ORG_ID                    AS ORG_ID,       --机构编号
           '6'                                AS TAB_FLG
      FROM RRP_MDL.O_ICL_CMM_IBANK_NV_TYPE_PROD_INVEST A --同业净值型产品投资
     WHERE ABS(A.BOOK_BAL) > 0
       AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     UNION ALL
    --19 同业 同业证券持仓表出货币基金数据
    SELECT A.OBJ_ID /*A.FIN_INSTM_ID*/         AS FIN_INST_ID, --金融工具编号
           NVL(A.ACTL_BAL,0) + NVL(A.EVHA_VAL_CHAG,0) AS BOOK_BAL, --账面余额
           A.BELONG_ORG_ID                     AS ORG_ID,      --机构编号
           '7'                                 AS TAB_FLG
      FROM RRP_MDL.O_ICL_CMM_IBANK_SECU_POST A --同业证券持仓表
     WHERE ABS(A.ACTL_BAL) > 0
       AND A.ASSET_TYPE_NAME LIKE '%货币基金%'
       AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     UNION ALL
    --20 同业 同业现金借贷表出非结算性存放同业数据
    SELECT A.OBJ_ID /*A.FIN_INSTM_ID*/        AS FIN_INST_ID, --金融工具编号
           A.ACTL_BAL                         AS BOOK_BAL,    --账面余额
           A.BELONG_ORG_ID                    AS ORG_ID,      --机构编号
           '8'                                AS TAB_FLG
      FROM RRP_MDL.O_ICL_CMM_IBANK_CASH_DEBIT_CRDT A --同业现金借贷表
     WHERE ABS(A.ACTL_BAL) > 0
       AND A.ASSET_TYPE_NAME LIKE '%存放同业%'
       AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     UNION ALL
    --9 同业 同业债券借贷 --ADD BY LIP 20250715
    SELECT A.OBJ_ID                           AS FIN_INST_ID, --金融工具编号
           A.CURRT_BAL                        AS BOOK_BAL,    --账面余额
           A.ENTRY_ORG_ID                     AS ORG_ID,      --机构编号
           '9'                                AS TAB_FLG
      FROM RRP_MDL.O_ICL_CMM_IBANK_BOND_DEBIT_CRDT A --同业债券借贷
     WHERE ABS(A.CURRT_BAL) > 0
       AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
    SELECT SYS_GUID()                                                    AS RID --数据主键
           ,B.FIN_PERMIT_NO                                              AS JRXKZH --金融许可证号
           ,NVL(TRIM(B1.ORG_ID1),'896')                                  AS NBJGH --内部机构号
           ,B.ORG_NM                                                     AS YHJGMC --银行机构名称
           ,SUBSTR(A.MXKMBH,1,8)                                         AS MXKMBH --明细科目编号
           ,NVL(TRIM(C.SUBJ_NM),C1.SUBJ_NM)                              AS MXKMMC --明细科目名称
           ,A.JRGJBH                                                     AS JRGJBH --金融工具编号
           ,A.JRGJMC                                                     AS JRGJMC --金融工具名称
           ,NVL(TRIM(A.JYZHLX),'银行账户')                               AS JYZHLX --账户类型
           ,A.YEDL                                                       AS YEDL --业务大类
           ,A.YWZL                                                       AS YWZL --业务中类
           ,A.YWXL                                                       AS YWXL --业务小类
           ,A.CPMC                                                       AS CPMC --产品名称
           ,A.BZ                                                         AS BZ --币种
           ,A.CYCB                                                       AS CYCB --持有成本
           ,NVL(TRIM(BB.BOOK_BAL),0)                                     AS ZMYE --账面余额
           ,A.BQSY                                                       AS BQSY --本期收益
           ,A.LJSY                                                       AS LJSY --累计收益
           --,A.NHLL                                                       AS NHLL --年化利率
           ,NVL(A.NHLL,0)                                                AS NHLL --年化利率
           ,CASE WHEN A.YEDL LIKE '%投资%' AND A.JYZHLX LIKE '%交易%'
                 THEN NVL(TRIM(E1.TZL_RISK_CHARGE),E2.TZL_RISK_CHARGE)
                 ELSE NVL(TRIM(E1.SPECIFIC_RISK_CHARGE),E2.SPECIFIC_RISK_CHARGE)
             END                                                         AS XYFXQZ --信用风险权重
           ,CASE WHEN NVL(TRIM(F1.V_REGUL_CLASSIF_CD),F2.V_REGUL_CLASSIF_CD) = '1' THEN '正常'
                 WHEN NVL(TRIM(F1.V_REGUL_CLASSIF_CD),F2.V_REGUL_CLASSIF_CD) = '2' THEN '关注'
                 WHEN NVL(TRIM(F1.V_REGUL_CLASSIF_CD),F2.V_REGUL_CLASSIF_CD) = '3' THEN '次级'
                 WHEN NVL(TRIM(F1.V_REGUL_CLASSIF_CD),F2.V_REGUL_CLASSIF_CD) = '4' THEN '可疑'
                 WHEN NVL(TRIM(F1.V_REGUL_CLASSIF_CD),F2.V_REGUL_CLASSIF_CD) = '5' THEN '损失'
                 ELSE '正常'
             END                                                         AS WJFL --五级分类
            /*,CASE WHEN F1.LEVEL5_CLASS_CD = '10' THEN '正常'
                  WHEN F1.LEVEL5_CLASS_CD = '20' THEN '关注'
                  WHEN F1.LEVEL5_CLASS_CD = '30' THEN '次级'
                  WHEN F1.LEVEL5_CLASS_CD = '40' THEN '可疑'
                  WHEN F1.LEVEL5_CLASS_CD = '50' THEN '损失'
                  ELSE '正常'
             END                                                         AS WJFL  --五级分类*/
           --,F1.N_ECL_BEFORE                                              AS JZZB --减值准备
           --,NVL(TRIM(F1.N_ECL_BEFORE),F2.N_ECL_BEFORE)                  AS JZZB --减值准备
           ,CASE WHEN F1.V_DFC_ECL_CD = 'dcf' AND F1.N_ECL_BEFORE_DCF IS NOT NULL THEN F1.N_ECL_BEFORE_DCF
                 WHEN F1.N_ECL_BEFORE IS NOT NULL THEN F1.N_ECL_BEFORE
                 WHEN F2.V_DFC_ECL_CD = 'dcf' AND F2.N_ECL_BEFORE_DCF IS NOT NULL THEN F2.N_ECL_BEFORE_DCF
                 WHEN F2.N_ECL_BEFORE IS NOT NULL THEN F2.N_ECL_BEFORE
             END                                                         AS JZZB --减值准备 --根据业务数据情况修改 MOD BY LIP 20220926
           ,TRIM(A.QXRQ)                                                 AS QXRQ --起息日期
           ,TRIM(A.DQRQ)                                                 AS DQRQ --到期日期
           ,A.BBZ                                                        AS BBZ --备注
           ,A.CJRQ                                                       AS CJRQ --采集日期
           ,'000'                                                        AS DEPT_NO --部门编号
           ,'01'                                                         AS SRC_SYS_ID --来源系统ID
           ,A.NBJGH                                                      AS ISSUED_NO --填报机构
           ,'000000'                                                     AS ORG_NO --报送机构
           ,''                                                           AS ADDRESS --归属地
           ,B.GSFZJG                                                     AS GSFZJG --归属分支机构
           ,A.DATA_SRC_DESC                                              AS DATA_SRC_DESC --数据来源中文
           ,A.PRIMARYKEY                                                 AS PRIMARYKEY --ADD BY LIP 20241219
           ,A.OBJ_ID                                                     AS OBJ_ID --ADD BY LIP 20241219
           ,A.PRIMARYKEY_BF                                              AS PRIMARYKEY_BF --主键_巴三前 --ADD BY LIP 20250217
           ,A.OBJ_ID_BF                                                  AS OBJ_ID_BF --核算对象ID_OBJ_ID --ADD BY LIP 20250217
           ,A.ZCSFL                                                      AS ZCSFL --资产三分类代码 --ADD BY LIP 20250410
      FROM RRP_EAST.EAST5_1004_ZYZJYWYEB_TY A
      LEFT JOIN TMP_BOOK_BAL BB
        ON BB.FIN_INST_ID = A.PRIMARYKEY
       AND BB.ORG_ID = A.NBJGH
      LEFT JOIN RRP_MDL.ORG_CONFIG B1 --机构映射表
        ON B1.ORG_ID = A.NBJGH
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(TRIM(B1.ORG_ID1),'896')
       AND B.DATA_DT = V_MONTH_END_DATEID
      LEFT JOIN RRP_MDL.M_GL_INFO C --总账会计科目信息表
        ON C.SUBJ_ID = SUBSTR(A.MXKMBH,1,8) --科目报送到三级
       AND C.DATA_DT = V_MONTH_END_DATEID
      LEFT JOIN RRP_MDL.M_GL_INFO C1 --总账会计科目信息表
        ON C1.SUBJ_ID = SUBSTR(A.MXKMBH,1,8) --科目报送到三级
       AND C1.DATA_DT = V_MONTH_END_DATEID
      --LEFT JOIN TMP_XYFXQZ E1
      LEFT JOIN RRP_EAST.EAST5_1004_ZYZJYWYEB_RWA_XYFXQZ E1 --MOD BY LIP 20241129
        ON E1.LOAN_REF_NO = A.PRIMARYKEY
       AND E1.NUM = 1
      --LEFT JOIN TMP_XYFXQZ E2
      LEFT JOIN RRP_EAST.EAST5_1004_ZYZJYWYEB_RWA_XYFXQZ E2 --MOD BY LIP 20241129
        ON E2.LOAN_REF_NO = A.OBJ_ID
       AND E2.NUM = 1
      LEFT JOIN (SELECT F11.*,
                        ROW_NUMBER() OVER(PARTITION BY F11.V_ID_NUMBER ORDER BY F11.D_DATE_DT DESC) AS NUM
                   FROM RRP_MDL.O_IOL_IFRS_FCT_ECL_RES_DTL F11
                  WHERE F11.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) F1 --减值结果表
        --ON F1.V_ID_NUMBER = A.PRIMARYKEY
        ON F1.V_ID_NUMBER = A.PRIMARYKEY_BF
       AND F1.NUM = 1
      LEFT JOIN (SELECT F11.*,
                        ROW_NUMBER() OVER(PARTITION BY F11.V_ID_NUMBER ORDER BY F11.D_DATE_DT DESC) AS NUM
                   FROM RRP_MDL.O_IOL_IFRS_FCT_ECL_RES_DTL F11
                  WHERE F11.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) F2 --减值结果表
        ON F2.V_ID_NUMBER = A.OBJ_ID
       AND F2.NUM = 1
     WHERE A.CJRQ = V_MONTH_END_DATEID;

    V_SQLCOUNT := SQL%ROWCOUNT;
    O_ERRCODE  := '0';
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP      := 13;
    V_STEP_DESC := '自营资金业务余额表_插入目标表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_1004_ZYZJYWYEB
      (RID              --数据主键
      ,JRXKZH           --金融许可证号
      ,NBJGH            --内部机构号
      ,YHJGMC           --银行机构名称
      ,MXKMBH           --明细科目编号
      ,MXKMMC           --明细科目名称
      ,JRGJBH           --金融工具编号
      ,JRGJMC           --金融工具名称
      ,JYZHLX           --账户类型
      ,YEDL             --业务大类
      ,YWZL             --业务中类
      ,YWXL             --业务小类
      ,CPMC             --产品名称
      ,BZ               --币种
      ,CYCB             --持有成本
      ,ZMYE             --账面余额
      ,BQSY             --本期收益
      ,LJSY             --累计收益
      ,NHLL             --年化利率
      ,XYFXQZ           --信用风险权重
      ,WJFL             --五级分类
      ,JZZB             --减值准备
      ,QXRQ             --起息日期
      ,DQRQ             --到期日期
      ,BBZ              --备注
      ,CJRQ             --采集日期
      ,DEPT_NO          --部门编号
      ,SRC_SYS_ID       --来源系统ID
      ,ISSUED_NO        --填报机构
      ,ORG_NO           --报送机构
      ,ADDRESS          --归属地
      ,GSFZJG           --归属分支机构
      ,TY_ZJ_FLAG       --同业资金标志
      ,ZCSFL            --资产三分类代码 --ADD BY LIP 20250410
      ,DATA_SRC_DESC    --数据来源系统 --ADD BY LIP 20250410
      )
    SELECT  RID                                        AS RID        --数据主键
           ,JRXKZH                                     AS JRXKZH     --金融许可证号
           ,NBJGH                                      AS NBJGH      --内部机构号
           ,YHJGMC                                     AS YHJGMC     --银行机构名称
           ,MXKMBH                                     AS MXKMBH     --明细科目编号
           ,MXKMMC                                     AS MXKMMC     --明细科目名称
           ,JRGJBH                                     AS JRGJBH     --金融工具编号
           ,JRGJMC                                     AS JRGJMC     --金融工具名称
           ,JYZHLX                                     AS JYZHLX     --账户类型
           ,YEDL                                       AS YEDL       --业务大类
           ,YWZL                                       AS YWZL       --业务中类
           ,YWXL                                       AS YWXL       --业务小类
           ,CPMC                                       AS CPMC       --产品名称
           ,BZ                                         AS BZ         --币种
           ,CYCB                                       AS CYCB       --持有成本
           ,ZMYE                                       AS ZMYE       --账面余额
           ,BQSY                                       AS BQSY       --本期收益
           ,LJSY                                       AS LJSY       --累计收益
           ,NHLL                                       AS NHLL       --年化利率
           --,NVL(XYFXQZ,0)                              AS XYFXQZ     --信用风险权重
           --MOD BY LIP 20220914 根据孙若真反馈：持有成本，账面价值为0的，信用风险不用取
           ,CASE WHEN CYCB = 0 AND ZMYE = 0 THEN 0
                 WHEN JYZHLX = '交易账户' THEN 0 --MOD BY LIP 20250103 银行账户的才有信用风险权重
                 ELSE NVL(XYFXQZ,0)
             END                                       AS XYFXQZ     --信用风险权重
           ,WJFL                                       AS WJFL       --五级分类
           --,NVL(JZZB,0)                                AS JZZB       --减值准备
           --MOD BY LIP 20221017 持有成本为0时，减值准备不需取
           ,CASE WHEN JYZHLX = '交易账户' THEN 0
                 --WHEN MXKMMC LIKE '交易性%' THEN 0
                 WHEN MXKMBH LIKE '1101%' /*交易性金融资产*/ THEN 0 --modify by tangan at 20221128 将通过科目名称判断交易性金融资产改为通过科目编号判断
                 WHEN CYCB = 0 THEN 0
                 ELSE NVL(JZZB,0)
             END                                       AS JZZB       --减值准备
           ,NVL(TRIM(QXRQ),'99991231')                 AS QXRQ       --起息日期
           ,NVL(TRIM(DQRQ),'99991231')                 AS DQRQ       --到期日期
           ,BBZ                                        AS BBZ        --备注
           ,CJRQ                                       AS CJRQ       --采集日期
           ,DEPT_NO                                    AS DEPT_NO    --部门编号
           ,SRC_SYS_ID                                 AS SRC_SYS_ID --来源系统id
           --,ISSUED_NO                                  AS ISSUED_NO  --填报机构
           ,'000000'                                   AS ISSUED_NO  --填报机构
           ,ORG_NO                                     AS ORG_NO     --报送机构
           ,ADDRESS                                    AS ADDRESS    --归属地
           ,GSFZJG                                     AS GSFZJG     --归属分支机构
           --,'资金'                                     AS TY_ZJ_FLAG --同业资金标志
           ,ISSUED_NO                                  AS TY_ZJ_FLAG --同业资金标志
           ,ZCSFL                                      AS ZCSFL      --资产三分类代码 --ADD BY LIP 20250410
           ,'资金系统'                                 AS DATA_SRC_DESC --数据来源系统 --ADD BY LIP 20250410
      FROM RRP_EAST.EAST5_1004_ZYZJYWYEB_ZJ_R;

    V_SQLCOUNT := SQL%ROWCOUNT;
    O_ERRCODE  := '0';
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP      := 14;
    V_STEP_DESC := '自营资金业务余额表_插入目标表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_1004_ZYZJYWYEB
      (RID              --数据主键
      ,JRXKZH           --金融许可证号
      ,NBJGH            --内部机构号
      ,YHJGMC           --银行机构名称
      ,MXKMBH           --明细科目编号
      ,MXKMMC           --明细科目名称
      ,JRGJBH           --金融工具编号
      ,JRGJMC           --金融工具名称
      ,JYZHLX           --账户类型
      ,YEDL             --业务大类
      ,YWZL             --业务中类
      ,YWXL             --业务小类
      ,CPMC             --产品名称
      ,BZ               --币种
      ,CYCB             --持有成本
      ,ZMYE             --账面余额
      ,BQSY             --本期收益
      ,LJSY             --累计收益
      ,NHLL             --年化利率
      ,XYFXQZ           --信用风险权重
      ,WJFL             --五级分类
      ,JZZB             --减值准备
      ,QXRQ             --起息日期
      ,DQRQ             --到期日期
      ,BBZ              --备注
      ,CJRQ             --采集日期
      ,DEPT_NO          --部门编号
      ,SRC_SYS_ID       --来源系统ID
      ,ISSUED_NO        --填报机构
      ,ORG_NO           --报送机构
      ,ADDRESS          --归属地
      ,GSFZJG           --归属分支机构
      ,TY_ZJ_FLAG       --同业资金标志
      ,ZCSFL            --资产三分类代码 --ADD BY LIP 20250410
      ,DATA_SRC_DESC    --数据来源系统 --ADD BY LIP 20250410
      )
    SELECT  RID                                        AS RID        --数据主键
           ,JRXKZH                                     AS JRXKZH     --金融许可证号
           ,NBJGH                                      AS NBJGH      --内部机构号
           ,YHJGMC                                     AS YHJGMC     --银行机构名称
           ,MXKMBH                                     AS MXKMBH     --明细科目编号
           ,MXKMMC                                     AS MXKMMC     --明细科目名称
           ,JRGJBH                                     AS JRGJBH     --金融工具编号
           ,JRGJMC                                     AS JRGJMC     --金融工具名称
           ,JYZHLX                                     AS JYZHLX     --账户类型
           ,YEDL                                       AS YEDL       --业务大类
           ,YWZL                                       AS YWZL       --业务中类
           ,YWXL                                       AS YWXL       --业务小类
           ,CPMC                                       AS CPMC       --产品名称
           ,BZ                                         AS BZ         --币种
           ,CYCB                                       AS CYCB       --持有成本
           ,ZMYE                                       AS ZMYE       --账面余额
           ,BQSY                                       AS BQSY       --本期收益
           ,LJSY                                       AS LJSY       --累计收益
           ,NHLL                                       AS NHLL       --年化利率
           --,NVL(XYFXQZ,0)                              AS XYFXQZ     --信用风险权重
           --MOD BY LIP 20220914 根据孙若真反馈：持有成本，账面价值为0的，信用风险不用取
           ,CASE WHEN CYCB = 0 AND ZMYE = 0 THEN 0
                 WHEN JYZHLX = '交易账户' THEN 0 --MOD BY LIP 20250103 银行账户的才有信用风险权重
                 ELSE NVL(XYFXQZ,0)
             END                                       AS XYFXQZ     --信用风险权重
           ,WJFL                                       AS WJFL       --五级分类
           --MOD BY 交易账户的减值应该为空 科目名称为“交易性”开头的减值准备默认为0 LAIHAIQIANG 20220902
           /*,CASE WHEN JYZHLX = '交易账户' THEN 0
                 WHEN MXKMMC LIKE '交易性%' THEN 0
                 ELSE NVL(JZZB,0)
             END                                       AS JZZB       --减值准备*/
           --MOD BY LIP 20221017 持有成本为0时，减值准备不需取
           ,CASE WHEN JYZHLX = '交易账户' THEN 0
                 --WHEN MXKMMC LIKE '交易性%' THEN 0
                 WHEN MXKMBH LIKE '1101%' /*交易性金融资产*/ THEN 0 --modify by tangan at 20221128 将通过科目名称判断交易性金融资产改为通过科目编号判断
                 WHEN CYCB = 0 THEN 0
                 ELSE NVL(JZZB,0)
             END                                       AS JZZB       --减值准备
           ,NVL(TRIM(QXRQ),'99991231')                 AS QXRQ       --起息日期
           ,NVL(TRIM(DQRQ),'99991231')                 AS DQRQ       --到期日期
           ,BBZ                                        AS BBZ        --备注
           ,CJRQ                                       AS CJRQ       --采集日期
           ,DEPT_NO                                    AS DEPT_NO    --部门编号
           ,SRC_SYS_ID                                 AS SRC_SYS_ID --来源系统id
           --,ISSUED_NO                                  AS ISSUED_NO  --填报机构
           ,'000000'                                   AS ISSUED_NO  --填报机构
           ,ORG_NO                                     AS ORG_NO     --报送机构
           ,ADDRESS                                    AS ADDRESS    --归属地
           ,GSFZJG                                     AS GSFZJG     --归属分支机构
           --,'同业'                                     AS TY_ZJ_FLAG --同业资金标志
           ,ISSUED_NO                                  AS TY_ZJ_FLAG --同业资金标志
           ,ZCSFL                                      AS ZCSFL      --资产三分类代码 --ADD BY LIP 20250410
           ,DATA_SRC_DESC                              AS DATA_SRC_DESC --数据来源系统 --ADD BY LIP 20250410
      FROM RRP_EAST.EAST5_1004_ZYZJYWYEB_TY_R;

    V_SQLCOUNT := SQL%ROWCOUNT;
    O_ERRCODE  := '0';
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP      := 15;
    V_STEP_DESC := '自营资金业务余额表_委托同业代付';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_1004_ZYZJYWYEB
      (RID              --数据主键
      ,JRXKZH           --金融许可证号
      ,NBJGH            --内部机构号
      ,YHJGMC           --银行机构名称
      ,MXKMBH           --明细科目编号
      ,MXKMMC           --明细科目名称
      ,JRGJBH           --金融工具编号
      ,JRGJMC           --金融工具名称
      ,JYZHLX           --账户类型
      ,YEDL             --业务大类
      ,YWZL             --业务中类
      ,YWXL             --业务小类
      ,CPMC             --产品名称
      ,BZ               --币种
      ,CYCB             --持有成本
      ,ZMYE             --账面余额
      ,BQSY             --本期收益
      ,LJSY             --累计收益
      ,NHLL             --年化利率
      ,XYFXQZ           --信用风险权重
      ,WJFL             --五级分类
      ,JZZB             --减值准备
      ,QXRQ             --起息日期
      ,DQRQ             --到期日期
      ,BBZ              --备注
      ,CJRQ             --采集日期
      ,DEPT_NO          --部门编号
      ,SRC_SYS_ID       --来源系统ID
      ,ISSUED_NO        --填报机构
      ,ORG_NO           --报送机构
      ,ADDRESS          --归属地
      ,GSFZJG           --归属分支机构
      ,TY_ZJ_FLAG       --同业资金标志
      ,DATA_SRC_DESC    --数据来源系统 --ADD BY LIP 20250410
      )
    SELECT --MD5(V_MONTH_END_DATEID || A.FIN_INST_ID) AS RID, --数据主键
           SYS_GUID()                                   AS RID, --数据主键
           B.FIN_PERMIT_NO                              AS JRXKZH, --金融许可证号
           NVL(TRIM(F.ORG_ID1),'800')                   AS NBJGH, --内部机构号
           B.ORG_NM                                     AS YHJGMC, --银行机构名称
           SUBSTR(A.SUBJ_ID,1,8)                        AS MXKMBH, --明细科目编号
           C.SUBJ_NM                                    AS MXKMMC, --明细科目名称
           A.FIN_INST_ID                                AS JRGJBH, --金融工具编号
           D.FIN_INST_NM                                AS JRGJMC, --金融工具名称
           A.ACC_TYP                                    AS JYZHLX, --账户类型
           A.BIZ_LRG_CL                                 AS YEDL, --业务大类
           A.BIZ_MID_CL                                 AS YWZL, --业务中类
           A.BIZ_SML_CL                                 AS YWXL, --业务小类
           A.PROD_NM                                    AS CPMC, --产品名称
           A.CUR                                        AS BZ, --币种
           CASE WHEN A.BIZ_MID_CL IN ('买入返售','卖出回购','拆入','拆出','同业借款') AND A.BOOK_BAL = 0 THEN 0
                WHEN A.BIZ_SML_CL = '债券借贷' AND A.BOOK_BAL = 0 THEN 0
                ELSE A.HOLD_COST
           END                                          AS CYCB, --持有成本
           A.BOOK_BAL                                   AS ZMYE, --账面余额
           A.CURR_PFT                                   AS BQSY, --本期收益
           --A.CURR_PFT + NVL(E.LJSY,0)                   AS LJSY, --累计收益
           A.CUM_PFT                                    AS LJSY, --累计收益
           A.YEAR_RATE                                  AS NHLL, --年化利率
           A.CR_RSK_WGT                                 AS XYFXQZ, --信用风险权重
           A.LVL5_CL                                    AS WJFL, --五级分类
           --A.PRO_IMPT                                   AS JZZB, --减值准备
           CASE WHEN A.ACC_TYP = '交易账户' THEN NULL
                ELSE A.PRO_IMPT
            END                                         AS JZZB, --减值准备  modify by tangan at 20220602 交易账户不取减值准备
           NVL(A.VAL_DT,'99991231')                     AS QXRQ, --起息日期
           NVL(A.EXP_DT,'99991231')                     AS DQRQ, --到期日期
           ''                                           AS BBZ, --备注
           V_MONTH_END_DATEID                           AS CJRQ, --采集日期
           --A.DEPT_LINE                                  AS DEPT_NO, --部门编号
           '000'                                        AS DEPT_NO, --部门编号
           '01'                                         AS SRC_SYS_ID, --来源系统ID
           --A.ORG_ID                                     AS ISSUED_NO, --填报机构
           --A.DEPT_LINE                                  AS ISSUED_NO, --填报机构
           '000000'                                     AS ISSUED_NO, --填报机构
           ORG.ORG_ID_LEL_0                             AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                         AS ADDRESS, --归属地
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                         AS GSFZJG,    --归属分支机构
           --'同业代付'                                   AS TY_ZJ_FLAG --同业资金标志
           A.DEPT_LINE                                  AS TY_ZJ_FLAG, --同业资金标志
           '同业代付'                                   AS DATA_SRC_DESC --数据来源系统 --ADD BY LIP 20250410
      FROM RRP_MDL.M_EAST_OWN_CPTL_BAL A --自营资金业务余额表
      LEFT JOIN RRP_MDL.ORG_CONFIG F --机构映射表
        ON F.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(TRIM(F.ORG_ID1),'800')
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_GL_INFO C --总账会计科目信息表
        ON C.SUBJ_ID = SUBSTR(A.SUBJ_ID,1,8)--科目报送到三级
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_FIN_INST_INFO D --金融工具信息表
        ON D.FIN_INST_ID = A.FIN_INST_ID
       --AND D.DATA_SRC = '委托同业代付数据'
       AND UPPER(D.DATA_SRC) IN ('ICMS')
       AND D.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = B.ORG_ID
      LEFT JOIN CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON 1 = 1
       AND UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE /*UPPER(A.DATA_SRC) IN ('CRSS')*/
           UPPER(A.DATA_SRC) IN ('ICMS') --MODIFY BY TANGAN AT 20221223
       AND A.BIZ_MID_CL = '同业代付'
       AND A.DATA_DT = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    O_ERRCODE  := '0';
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP      := 16;
    V_STEP_DESC := '表分析开始';
    V_STARTTIME := SYSDATE;
    ETL_DBMS_STATS(V_P_DATE,V_TABLE_NAME,V_PARTITION_NAME,O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    O_ERRCODE  := '0';
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  END IF;

  --在过程跑批完成记录表中插入记录，调度查询该表判断过程是是否跑批完成
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (I_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  O_ERRCODE  := '0';
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
    RAISE;

END ETL_EAST5_1004_ZYZJYWYEB;
/

