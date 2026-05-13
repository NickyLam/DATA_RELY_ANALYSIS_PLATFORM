CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_1003_ZYZJJYXXB(I_P_DATE IN INTEGER, --跑批日期
                                                     O_ERRCODE OUT VARCHAR2 --错误代码
                                                     )
  /***********************************************************************
  **  存储过程详细说明：自营资金交易信息表
  **  存储过程名称:  ETL_EAST5_1003_ZYZJJYXXB
  **  存储过程创建日期:2022-03-07
  **  存储过程创建人:蔡正伟
  **  调用方法:
       DECLARE
         I_P_DATE INTEGER;
         O_ERRCODE  CHAR(5);
       BEGIN
         I_P_DATE := '20220101';
         ETL_EAST5_1003_ZYZJJYXXB(I_P_DATE, O_ERRCODE);
       END;
  **  输入参数:   I_P_DATE
  **  输出参数:   O_ERRCODE
  **  返回值:     O_ERRCODE
  **  返回值:     O_ERRCODE
  **  修改日期      修改人       修改原因
  **  20220714      LHQ          根据源系统口径修改逻辑
  **  20220805      LIP          核对逻辑，调整过程格式
  **  20220824      LIP          增加数据来源描述
  **  20220826      LIP          根据孙若真邮件20220824：关于EAST5.0报送数据现状及后续的整改要求 修改，
  **                             将小类“净值型保险资管计划”，改成“保险业资产管理产品”
  **  20220913      LIP          增加委托同业代付
  ************************************************************************/
IS
  V_DATE               DATE;             --数据日期(判断输入参数日期格式是否准确)
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
  V_PROC_NAME          VARCHAR2(100):= UPPER('ETL_EAST5_1003_ZYZJJYXXB'); --存储过程名称
  V_TABLE_NAME         VARCHAR2(100):= UPPER('EAST5_1003_ZYZJJYXXB'); --表名称
  V_SYSTEM             VARCHAR2(30):= '监管报送'; --来源系统
BEGIN
  --特殊跑批日期处理
  --跑批日期初始化 /*该表每月2号跑上月末的数据 即日常跑批是T-1 本表需要T-2*/
  /*SELECT COUNT(1) INTO V_SQLCOUNT FROM RRP_MDL.ETL_STATE TA
   WHERE TA.PROC_NAME = 'ETL_EAST5_1002_JRGJXXB' AND TA.ETL_DATE = I_P_DATE;  --查询跑批日期是否有跑批记录
  IF V_SQLCOUNT > 0 THEN V_P_DATE := I_P_DATE; --重跑不限制
  ELSE V_P_DATE := TO_CHAR(TO_DATE(I_P_DATE,'YYYYMMDD') - 1 ,'YYYYMMDD');
  END IF;*/

  V_P_DATE    := TO_CHAR(I_P_DATE);
  V_DATE      := TO_DATE(V_P_DATE,'YYYY-MM-DD'); --将参数转化为日期格式，判读输入参数是否符合日期要求
  V_FREQ_FLAG := RRP_EAST.FUN_FREQ(V_P_DATE, V_PROC_NAME);
  V_MONTH_END_DATEID := TO_CHAR(LAST_DAY(V_DATE),'YYYYMMDD');
  V_PARTITION_NAME   := 'PARTITION_'|| V_MONTH_END_DATEID;
  V_MONTH_START_DATEID := TO_CHAR(TRUNC(V_DATE,'MM'),'YYYYMMDD');

  V_STEP_DESC   := '程序加工开始';
  --判断跑批频度
  IF V_FREQ_FLAG = '1' THEN

    V_STEP      := 1;
    V_STEP_DESC := '删除当日分区数据';
    V_STARTTIME := SYSDATE;
    --删除当日分区数据
    RRP_EAST.ETL_PARTITION_ADD(V_MONTH_END_DATEID, V_TABLE_NAME, 1, O_ERRCODE);
    RRP_EAST.ETL_PARTITION_TRUNCATE(V_MONTH_END_DATEID, V_TABLE_NAME, O_ERRCODE);

    EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_EAST.EAST5_1003_ZYZJJYXXB_ZJ';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_EAST.EAST5_1003_ZYZJJYXXB_TY';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_EAST.EAST5_1003_ZYZJJYXXB_ZJ_R';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_EAST.EAST5_1003_ZYZJJYXXB_TY_R';

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --ADD BY LIP 20241126 转自营的交易对手加工
    V_STEP      := 2;
    V_STEP_DESC := '自营资金交易信息表_转自营的交易对手加工';
    V_STARTTIME := SYSDATE;
    EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_EAST.EAST5_1003_ZYZJJYXXB_ZJ_DFXX';
    INSERT INTO RRP_EAST.EAST5_1003_ZYZJJYXXB_ZJ_DFXX
      (JYBH --交易编号
      ,ECIF_CODE --交易对手客户编号
      ,JYDSMC --交易对手名称
      ,JYDSZH --交易对手账号
      ,JYDSKHHH --交易对手开户行号
      ,JYDSKHHM --交易对手开户行名
      ,RN --排序
      )
    SELECT T1.SECURITY_TRADE_NO            AS JYBH --用于关联回流水号
          ,TRIM(T6.LABEL)                  AS ECIF_CODE --ECIF客户号，用于与ECIF系统关联
          ,TRIM(T6.CPTYS_NAME)             AS JYDSMC --交易对手名称
          ,TRIM(T5.CASH_ACC_NO)            AS JYDSZH --交易对手账号
          ,TRIM(T5.CASH_ACC_BANK_EX)       AS JYDSKHHH --交易对手开户行号
          ,TRIM(T5.CASH_ACC_BANK)          AS JYDSKHHM --交易对手开户行名
          ,ROW_NUMBER() OVER(PARTITION BY T1.SECURITY_TRADE_NO ORDER BY T1.TRADE_DATE) AS RN --排序
      FROM RRP_MDL.O_IOL_CTMS_TBS_V_WTRADE_UNDERWRITE T1
      LEFT JOIN RRP_MDL.O_IOL_CTMS_TBS_V_WTRADE_UNDERWRITE T2 --用成交编号关联转自营的成交编号
        ON T2.REF_NUMBER = REPLACE(REPLACE(TRIM(T1.REF_NUMBER),'转自营',''),'衍生','')
       AND T2.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
       AND T2.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_IOL_CTMS_TBS_V_WTRADE_UNDERWRITE T3
        ON T3.SERIAL_NUMBER = TRIM(T2.UW_BUY_NO)
       AND T3.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
       AND T3.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_IOL_CTMS_TBS_V_BONDSDEALS T4
        ON T4.SERIAL_NUMBER = T3.SECURITY_TRADE_NO
      LEFT JOIN RRP_MDL.O_IOL_CTMS_WTRADE_TR_SI T5
        ON T5.SERIAL_NUMBER = T4.SERIAL_NUMBER
       AND T5.BS <> T4.BUYORSELL
      LEFT JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_CPTYS T6
        ON T6.KEY_SRC = T4.CPTYS_ID
     WHERE T1.REF_NUMBER LIKE '转自营%'
       AND T1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
       AND T1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --自营资金交易信息表_本币买断式回购
    V_STEP      := 3;
    V_STEP_DESC := '自营资金交易信息表_本币买断式回购1';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_1003_ZYZJJYXXB_ZJ
      (NBJGH --内部机构号
      ,JRXKZH --金融许可证号
      ,YHJGMC --明细科目编号
      ,MXKMBH --银行机构名称
      ,MXKMMC --明细科目名称
      ,JYZHLX --账户类型
      ,JYBH --交易编号
      ,JRGJBH --金融工具编号
      ,JRGJMC --金融工具名称
      ,YEDL --业务大类
      ,YWZL --业务中类
      ,YWXL --业务小类
      ,CPMC --产品名称
      ,JYFX --交易方向
      ,MYBJBZ --合约币种
      ,MYBJJE --合约币种
      ,NHLL --年化利率
      ,JYRQ --交易日期
      ,HTYDRQ --合同起始日期
      ,HTDQRQ --合同到期日期
      ,BFQSZH --本方清算账号
      ,JYDSLB --交易对手类别 资金系统没有
      ,ECIF_CODE --ECIF客户号，用于与ECIF系统关联
      ,JYDSMC --交易对手名称
      ,JYDSPJ --交易对手评级
      ,JYDSPJJG --交易对手评级机构
      ,JYDSZH --交易对手账号
      ,JYDSKHHH --交易对手开户行号
      ,JYDSKHHM --交易对手开户行号
      ,WTGLBZ --委托管理标志
      ,SPRGH --审批人工号
      ,JYYGH --经办人工号
      ,BBZ --备注
      ,CJRQ --采集日期
      ,DATA_SRC_DESC --数据来源中文
      ,ZCSFL --资产三分类代码 --ADD BY LIP 20250415
      )
    SELECT M.DEPARTMENTID                                            AS NBJGH --内部机构号
          ,'B1194H244050001'                                         AS JRXKZH --金融许可证号
          ,'广东华兴银行股份有限公司总行'                            AS YXJGMC --银行机构名称
          --,DECODE(T1.BUYORSELL,'B','2111050101','1111040101')        AS MXKMBH --明细科目编号
          --,DECODE(T1.BUYORSELL,'B','卖出回购债券（买断式）','买入返售债券（买断式）') AS MXKMMC --明细科目名称
          ,DECODE(T1.BUYORSELL,'B','21110201','11110201')            AS MXKMBH --明细科目编号  --MODIFY BY LHQ AT 20221031
          ,DECODE(T1.BUYORSELL,'B','卖出回购债券成本','买入返售债券成本') AS MXKMMC --明细科目名称  --modify by LHQ at 20221031
          ,DECODE(T2.CONTROLFACTOR,'NT','交易账户','银行账户')       AS JYZHLX --账户类型
          ,T1.SERIAL_NUMBER || '_' || '1'                            AS JYBH --交易编号
          ,T1.CPTYS_ID || '_' || T1.SERIAL_NUMBER                    AS JRGJBH --金融工具编号
          ,T1.CPTYS_SHORT_NAME || '_' || DECODE(T1.BUYORSELL,'B','买断式正回购','买断式逆回购') AS JRGJMC --金融工具名称
          ,'同业往来'                                                AS YEDL --业务大类
          ,DECODE(T1.BUYORSELL,'B','卖出回购','买入返售')            AS YEZL --业务中类
          ,DECODE(T1.BUYORSELL,'B','卖出回购证券','买入返售证券')    AS YEXL --业务小类
          ,DECODE(T1.BUYORSELL,'B','买断式正回购','买断式逆回购')    AS CPMC --产品名称
          ,DECODE(T1.BUYORSELL,'B','卖出','买入')                    AS JYFX --交易方向
          ,'CNY'                                                     AS MYBJBZ --合约币种
          ,T1.AMOUNT                                                 AS MYBJJE --合约金额
          ,T1.REPO_RATE                                              AS NHLL --年化利率
          ,TRIM(T1.VALUE_DATE)                                       AS JYRQ --交易日期
          ,TRIM(T1.VALUE_DATE)                                       AS HTYDRQ --合同起始日期
          ,TRIM(T1.MATURITY_DATE)                                    AS HTDQRQ --合同到期日期
          ,SELFSI.CASH_ACC_NO                                        AS BFQSZH --本方清算账号
          ,NULL                                                      AS JYDSLB --交易对手类别 资金系统没有
          ,TRIM(T3.LABEL)                                            AS ECIF_CODE --ECIF客户号，用于与ECIF系统关联
          ,NULL                                                      AS JYDSMC --交易对手名称
          ,NULL                                                      AS JYDSPJ --交易对手评级
          ,NULL                                                      AS JYDSPJJG --交易对手评级机构
          ,CPTYSI.CASH_ACC_NO                                        AS JYDSZH --交易对手账号
          ,CPTYSI.CASH_ACC_BANK_EX                                   AS JYDSKHHH --交易对手开户行号
          ,CPTYSI.CASH_ACC_BANK                                      AS JYDSKHHM --交易对手开户行号
          ,'否'                                                      AS WTGLBZ --委托管理标志
          ,NULL                                                      AS SPRGH --审批人工号
          ,T1.DN_DEALER                                              AS JYYGH --经办人工号
          ,NULL                                                      AS BBZ --备注
          ,V_MONTH_END_DATEID                                        AS CJRQ --采集日期
          ,'本币买断式回购'                                          AS DATA_SRC_DESC --数据来源中文
          ,'AC'                                                      AS ZCSFL --资产三分类代码 --ADD BY LIP 20250415
      FROM RRP_MDL.O_IOL_CTMS_TBS_V_REPODEALS T1
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_KEEPFOLDER T2
        ON T2.KEEPFOLDER_ID = T1.KEEPFOLDER_ID
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_INTERFACE_PORTF_DEPART_MAPPING M
        ON M.KEEPFOLDER_ID = T1.KEEPFOLDER_ID
      LEFT JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_CPTYS T3
        ON T3.KEY_SRC = T1.CPTYS_ID
      LEFT JOIN RRP_MDL.O_IOL_CTMS_WTRADE_TR_SI SELFSI
        ON SELFSI.SERIAL_NUMBER = T1.SERIAL_NUMBER
       AND SELFSI.BS = T1.BUYORSELL
      LEFT JOIN RRP_MDL.O_IOL_CTMS_WTRADE_TR_SI CPTYSI
        ON CPTYSI.SERIAL_NUMBER = T1.SERIAL_NUMBER
       AND CPTYSI.BS <> T1.BUYORSELL
     WHERE T1.VALUE_DATE >= V_MONTH_START_DATEID
       AND T1.VALUE_DATE <= V_MONTH_END_DATEID;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP      := 4;
    V_STEP_DESC := '自营资金交易信息表_本币买断式回购2';
    V_STARTTIME := SYSDATE;
    --自营资金交易信息表_本币买断式回购2
    INSERT INTO RRP_EAST.EAST5_1003_ZYZJJYXXB_ZJ
      (NBJGH --内部机构号
      ,JRXKZH --金融许可证号
      ,YHJGMC --明细科目编号
      ,MXKMBH --银行机构名称
      ,MXKMMC --明细科目名称
      ,JYZHLX --账户类型
      ,JYBH --交易编号
      ,JRGJBH --金融工具编号
      ,JRGJMC --金融工具名称
      ,YEDL --业务大类
      ,YWZL --业务中类
      ,YWXL --业务小类
      ,CPMC --产品名称
      ,JYFX --交易方向
      ,MYBJBZ --合约币种
      ,MYBJJE --合约币种
      ,NHLL --年化利率
      ,JYRQ --交易日期
      ,HTYDRQ --合同起始日期
      ,HTDQRQ --合同到期日期
      ,BFQSZH --本方清算账号
      ,JYDSLB --交易对手类别 资金系统没有
      ,ECIF_CODE --ECIF客户号，用于与ECIF系统关联
      ,JYDSMC --交易对手名称
      ,JYDSPJ --交易对手评级
      ,JYDSPJJG --交易对手评级机构
      ,JYDSZH --交易对手账号
      ,JYDSKHHH --交易对手开户行号
      ,JYDSKHHM --交易对手开户行号
      ,WTGLBZ --委托管理标志
      ,SPRGH --审批人工号
      ,JYYGH --经办人工号
      ,BBZ --备注
      ,CJRQ --采集日期
      ,DATA_SRC_DESC --数据来源中文
      ,ZCSFL --资产三分类代码 --ADD BY LIP 20250415
      )
    SELECT M.DEPARTMENTID                                            AS NBJGH --内部机构号
          ,'B1194H244050001'                                         AS JRXKZH --金融许可证号
          ,'广东华兴银行股份有限公司总行'                            AS YXJGMC --银行机构名称
          --,DECODE(T1.BUYORSELL,'B','2111050101','1111040101')        AS MXKMBH --明细科目编号
          --,DECODE(T1.BUYORSELL,'B','卖出回购债券（买断式）','买入返售债券（买断式）') AS MXKMMC --明细科目名称
          ,DECODE(T1.BUYORSELL,'B','21110201','11110201')            AS MXKMBH --明细科目编号  --modify by LHQ at 20221031
          ,DECODE(T1.BUYORSELL,'B','卖出回购债券成本','买入返售债券成本') AS MXKMMC --明细科目名称  --modify by LHQ at 20221031
          ,DECODE(T2.CONTROLFACTOR,'NT','交易账户','银行账户')       AS JYZHLX --账户类型
          ,T1.SERIAL_NUMBER || '_' || '0'                            AS JYBH --交易编号
          ,T1.CPTYS_ID || '_' || T1.SERIAL_NUMBER                    AS JRGJBH --金融工具编号
          ,T1.CPTYS_SHORT_NAME||'_'||DECODE(T1.BUYORSELL,'B','买断式正回购','买断式逆回购') AS JRGJMC --金融工具名称
          ,'同业往来'                                                AS YEDL --业务大类
          ,DECODE(T1.BUYORSELL,'B','卖出回购','买入返售')            AS YEZL --业务中类
          ,DECODE(T1.BUYORSELL,'B','卖出回购证券','买入返售证券')    AS YEXL --业务小类
          ,DECODE(T1.BUYORSELL,'B','买断式正回购','买断式逆回购')    AS CPMC --产品名称
          ,DECODE(T1.BUYORSELL,'S','卖出','买入')                    AS JYFX --交易方向
          ,'CNY'                                                     AS MYBJBZ --合约币种
          ,T1.AMOUNT                                                 AS MYBJJE --合约金额
          ,T1.REPO_RATE                                              AS NHLL --年化利率
          ,TRIM(T1.MATURITY_DATE)                                    AS JYRQ --交易日期
          ,TRIM(T1.VALUE_DATE)                                       AS HTYDRQ --合同起始日期
          ,TRIM(T1.MATURITY_DATE)                                    AS HTDQRQ --合同到期日期
          ,SELFSI.CASH_ACC_NO                                        AS BFQSZH --本方清算账号
          ,NULL                                                      AS JYDSLB --交易对手类别 资金系统没有
          ,TRIM(T3.LABEL)                                            AS ECIF_CODE --ECIF客户号，用于与ECIF系统关联
          ,NULL                                                      AS JYDSMC --交易对手名称
          ,NULL                                                      AS JYDSPJ --交易对手评级
          ,NULL                                                      AS JYDSPJJG --交易对手评级机构
          ,CPTYSI.CASH_ACC_NO                                        AS JYDSZH --交易对手账号
          ,CPTYSI.CASH_ACC_BANK_EX                                   AS JYDSKHHH --交易对手开户行号
          ,CPTYSI.CASH_ACC_BANK                                      AS JYDSKHHM --交易对手开户行号
          ,'否'                                                      AS WTGLBZ --委托管理标志
          ,NULL                                                      AS SPRGH --审批人工号
          ,T1.DN_DEALER                                              AS JYYGH --经办人工号
          ,NULL                                                      AS BBZ --备注
          ,V_MONTH_END_DATEID                                        AS CJRQ --采集日期
          ,'本币买断式回购'                                          AS DATA_SRC_DESC --数据来源中文
          ,'AC'                                                      AS ZCSFL --资产三分类代码 --ADD BY LIP 20250415
      FROM RRP_MDL.O_IOL_CTMS_TBS_V_REPODEALS T1
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_KEEPFOLDER T2
        ON T2.KEEPFOLDER_ID = T1.KEEPFOLDER_ID
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_INTERFACE_PORTF_DEPART_MAPPING M
        ON M.KEEPFOLDER_ID = T1.KEEPFOLDER_ID
      LEFT JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_CPTYS T3
        ON T3.KEY_SRC = T1.CPTYS_ID
      LEFT JOIN RRP_MDL.O_IOL_CTMS_WTRADE_TR_SI SELFSI
        ON SELFSI.SERIAL_NUMBER = T1.SERIAL_NUMBER
       AND SELFSI.BS = T1.BUYORSELL
      LEFT JOIN RRP_MDL.O_IOL_CTMS_WTRADE_TR_SI CPTYSI
        ON CPTYSI.SERIAL_NUMBER = T1.SERIAL_NUMBER
       AND CPTYSI.BS <> T1.BUYORSELL
     WHERE T1.MATURITY_DATE >= V_MONTH_START_DATEID
       AND T1.MATURITY_DATE <= V_MONTH_END_DATEID;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP      := 5;
    V_STEP_DESC := '自营资金交易信息表_外币拆借/外币回购1';
    V_STARTTIME := SYSDATE;
    --自营资金交易信息表_外币拆借/外币回购
    INSERT INTO RRP_EAST.EAST5_1003_ZYZJJYXXB_ZJ
      (NBJGH --内部机构号
      ,JRXKZH --金融许可证号
      ,YHJGMC --明细科目编号
      ,MXKMBH --银行机构名称
      ,MXKMMC --明细科目名称
      ,JYZHLX --账户类型
      ,JYBH --交易编号
      ,JRGJBH --金融工具编号
      ,JRGJMC --金融工具名称
      ,YEDL --业务大类
      ,YWZL --业务中类
      ,YWXL --业务小类
      ,CPMC --产品名称
      ,JYFX --交易方向
      ,MYBJBZ --合约币种
      ,MYBJJE --合约币种
      ,NHLL --年化利率
      ,JYRQ --交易日期
      ,HTYDRQ --合同起始日期
      ,HTDQRQ --合同到期日期
      ,BFQSZH --本方清算账号
      ,JYDSLB --交易对手类别 资金系统没有
      ,ECIF_CODE --ECIF客户号，用于与ECIF系统关联
      ,JYDSMC --交易对手名称
      ,JYDSPJ --交易对手评级
      ,JYDSPJJG --交易对手评级机构
      ,JYDSZH --交易对手账号
      ,JYDSKHHH --交易对手开户行号
      ,JYDSKHHM --交易对手开户行号
      ,WTGLBZ --委托管理标志
      ,SPRGH --审批人工号
      ,JYYGH --经办人工号
      ,BBZ --备注
      ,CJRQ --采集日期
      ,DATA_SRC_DESC --数据来源中文
      ,ZCSFL --资产三分类代码 --ADD BY LIP 20250415
      )
      WITH MAX_DEAL_SQNO AS (
      SELECT ORI_DEAL_SQNO,MAX(DEAL_SQNO) AS LAST_DEAL_SQNO
        FROM (SELECT /*IBO.DEAL_SQNO AS ORI_DEAL_SQNO,*/ --20220815源系统提供更改
                     IBO.DEAL_SQNO AS DEAL_SQNO,
                     CONNECT_BY_ROOT(IBO.DEAL_SQNO) AS /*DEAL_SQNO*/ ORI_DEAL_SQNO --20220815源系统提供更改
                FROM RRP_MDL.O_IOL_CTMS_FBS_V_IBO_DEAL IBO
               START WITH NVL(DEAL_LINK_SQNO, 0) = 0
              --CONNECT BY PRIOR IBO.DEAL_LINK_SQNO = IBO.DEAL_SQNO) TMP_DATA
              CONNECT BY PRIOR IBO.DEAL_SQNO = IBO.DEAL_LINK_SQNO) TMP_DATA  --20220815源系统提供更改
       GROUP BY TMP_DATA.ORI_DEAL_SQNO)
    SELECT '896821'                                                  AS NBJGH --内部机构号
          ,'B1194H244050001'                                         AS JRXKZH --金融许可证号
          ,'广东华兴银行股份有限公司总行'                            AS YXJGMC --银行机构名称
          ,CASE WHEN T1.IBO_TYPE = '0' AND T1.DEAL_DIR = '1'
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
                WHEN T1.IBO_TYPE = '0' AND T1.DEAL_DIR = '-1'
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
                WHEN T1.IBO_TYPE = '4' AND T1.COLLATERAL_METHOD = '质押'
                THEN DECODE(T1.DEAL_DIR,'1','21110201','11110201')
                WHEN T1.IBO_TYPE = '4' AND T1.COLLATERAL_METHOD = '买断'
                THEN DECODE(T1.DEAL_DIR,'1','21110201','11110201')
            END                                                      AS MXKMBH --明细科目编号   --modify by tangan at 20221031
          ,NULL                                                      AS MXKMMC --明细科目名称--直接根据上面的明细科目编号，再统一关联总账科目表取最好
          ,'银行账户'                                                AS JYZHLX --账户类型
          ,NVL(T1.CLIENT_DEAL_SQNO,TO_CHAR(T1.DEAL_SQNO))||'_'|| '1' AS JYBH --交易编号
          ,T1.COUNTER_PARTY_ID || '_' || T1.DEAL_SQNO                AS JRGJBH --金融工具编号
          ,T1.COUNTER_PARTY_SCNAME || '_' ||
           CASE WHEN T1.IBO_TYPE = '0' THEN DECODE(T1.DEAL_DIR,'1','同业拆入','拆放同业')
                WHEN T1.IBO_TYPE = '4' AND T1.COLLATERAL_METHOD = '质押'
                THEN DECODE(T1.DEAL_DIR,'1','质押式正回购','质押式逆回购')
                WHEN T1.IBO_TYPE = '4' AND T1.COLLATERAL_METHOD = '买断'
                THEN DECODE(T1.DEAL_DIR,'1','买断式正回购','买断式逆回购')
            END                                                      AS JRGJMC --金融工具名称
          ,'同业往来'                                                AS YEDL --业务大类
          ,CASE WHEN T1.IBO_TYPE = '0' THEN DECODE(T1.DEAL_DIR,'1','拆入','拆出')
                WHEN T1.IBO_TYPE = '4' THEN DECODE(T1.DEAL_DIR,'1','卖出回购','买入返售')
            END                                                      AS YEZL --业务中类
          ,CASE WHEN T1.IBO_TYPE = '0' AND T1.DEAL_DIR = '1'
                     AND T3.INTERBANKTYPE IN ('境内银行业存款类金融机构','境内银行业非存款类金融机构','境外银行')
                THEN '拆入银行金融机构'
                WHEN T1.IBO_TYPE = '0' AND T1.DEAL_DIR = '1' THEN '拆入非银行金融机构'
                WHEN T1.IBO_TYPE = '0' AND T1.DEAL_DIR = '-1'
                     AND T3.INTERBANKTYPE IN ('境内银行业存款类金融机构','境内银行业非存款类金融机构','境外银行')
                THEN '拆出银行金融机构'
                WHEN T1.IBO_TYPE = '0' AND T1.DEAL_DIR = '-1' THEN '拆出非银行金融机构'
                WHEN T1.IBO_TYPE = '4' THEN DECODE(T1.DEAL_DIR,'1','卖出回购证券','买入返售证券')
            END                                                      AS YEXL --业务小类
          ,CASE WHEN T1.IBO_TYPE = '0'
                THEN DECODE(T1.DEAL_DIR,'1','同业拆入','拆放同业')
                WHEN T1.IBO_TYPE = '4' AND T1.COLLATERAL_METHOD = '质押'
                THEN DECODE(T1.DEAL_DIR,'1','质押式正回购','质押式逆回购')
                WHEN T1.IBO_TYPE = '4' AND T1.COLLATERAL_METHOD = '买断'
                THEN DECODE(T1.DEAL_DIR,'1','买断式正回购','买断式逆回购')
            END                                                      AS CPMC --产品名称
          ,DECODE(T1.DEAL_DIR,'1','卖出','买入')                     AS JYFX --交易方向
          ,T1.CRNCY_CODE                                             AS MYBJBZ --合约币种
          ,ABS(T1.FIRST_AMNT)                                        AS MYBJJE --合约金额
          ,T1.RATE                                                   AS NHLL --年化利率
          ,TO_CHAR(T1.VALUE_DATE,'YYYYMMDD')                         AS JYRQ --交易日期
          ,TO_CHAR(T1.VALUE_DATE,'YYYYMMDD')                         AS HTYDRQ --合同起始日期
          ,TO_CHAR(T1.MATURITY_DATE,'YYYYMMDD')                      AS HTDQRQ --合同到期日期
          ,NVL(SP.BENIFIT_BANK_ACCNT, SR.BENIFIT_BANK_ACCNT)         AS BFQSZH --本方清算账号
          ,NULL                                                      AS JYDSLB --交易对手类别 资金系统没有
          ,TRIM(T3.LABEL)                                            AS ECIF_CODE --ECIF客户号，用于与ECIF系统关联
          ,NULL                                                      AS JYDSMC --交易名称
          ,NULL                                                      AS JYDSPJ --交易对手评级
          ,NULL                                                      AS JYDSPJJG --交易对手评级机构
          ,NVL(TRIM(CP.BENIFIT_BANK_ACCNT),TRIM(CR.BENIFIT_BANK_ACCNT)) AS JYDSZH --交易对手账号
          ,NVL(TRIM(CP.ACCOUNT_BANK_BIC),TRIM(CR.ACCOUNT_BANK_BIC))  AS JYDSKHHH --交易对手开户行号
          ,NVL(TRIM(CP.ACCOUNT_BANK_DESC),TRIM(CR.ACCOUNT_BANK_DESC))AS JYDSKHHM --交易对手开户行名
          ,'否'                                                      AS WTGLBZ --委托管理标志
          ,NULL                                                      AS SPRGH --审批人工号
          ,TRIM(T1.DEALER)                                           AS JYYGH  --经办人工号 --MOD BY LIP 20220901
          --,NULL                                                      AS JYYGH --经办人工号 --源表缺失字段，暂时置空
          ,NULL                                                      AS BBZ --备注
          ,V_MONTH_END_DATEID                                        AS CJRQ --采集日期
          ,'外币拆借/外币回购'                                       AS DATA_SRC_DESC --数据来源中文
          ,'AC'                                                      AS ZCSFL --资产三分类代码 --ADD BY LIP 20250415
      FROM RRP_MDL.O_IOL_CTMS_FBS_V_IBO_DEAL T1
     INNER JOIN MAX_DEAL_SQNO T2
        ON T2.LAST_DEAL_SQNO = T1.DEAL_SQNO
     INNER JOIN RRP_MDL.O_IOL_CTMS_FBS_V_COUNTERPARTY T3
        ON T3.COUNTERPARTY_SEQ = T1.COUNTER_PARTY_ID
     INNER JOIN RRP_MDL.O_IOL_CTMS_FBS_V_DEAL_SETTLE_PATH T4
        ON T4.DEAL_SQNO = T1.DEAL_SQNO
      LEFT JOIN RRP_MDL.O_IOL_CTMS_FBS_V_SWT_SETTLE_PATH SP
        ON SP.INFR_SRNO = T4.SELF_PAY
      LEFT JOIN RRP_MDL.O_IOL_CTMS_FBS_V_SWT_SETTLE_PATH SR
        ON SR.INFR_SRNO = T4.SELF_RECEIVE
      LEFT JOIN RRP_MDL.O_IOL_CTMS_FBS_V_SWT_SETTLE_PATH CP
        ON CP.INFR_SRNO = T4.CP_PAY
      LEFT JOIN RRP_MDL.O_IOL_CTMS_FBS_V_SWT_SETTLE_PATH CR
        ON CR.INFR_SRNO = T4.CP_RECEIVE
     WHERE T1.DEAL_STATUS <> 'D' --ADD 20220815 源系统提供 LAIHAIQIANG
       AND TO_CHAR(T1.VALUE_DATE,'YYYYMMDD') >= V_MONTH_START_DATEID
       AND TO_CHAR(T1.VALUE_DATE,'YYYYMMDD') <= V_MONTH_END_DATEID;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

   --自营资金交易信息表_外币拆借/外币回购2
    V_STEP      := 6;
    V_STEP_DESC := '自营资金交易信息表_外币拆借/外币回购2';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_1003_ZYZJJYXXB_ZJ
      (NBJGH --内部机构号
      ,JRXKZH --金融许可证号
      ,YHJGMC --明细科目编号
      ,MXKMBH --银行机构名称
      ,MXKMMC --明细科目名称
      ,JYZHLX --账户类型
      ,JYBH --交易编号
      ,JRGJBH --金融工具编号
      ,JRGJMC --金融工具名称
      ,YEDL --业务大类
      ,YWZL --业务中类
      ,YWXL --业务小类
      ,CPMC --产品名称
      ,JYFX --交易方向
      ,MYBJBZ --合约币种
      ,MYBJJE --合约币种
      ,NHLL --年化利率
      ,JYRQ --交易日期
      ,HTYDRQ --合同起始日期
      ,HTDQRQ --合同到期日期
      ,BFQSZH --本方清算账号
      ,JYDSLB --交易对手类别 资金系统没有
      ,ECIF_CODE --ECIF客户号，用于与ECIF系统关联
      ,JYDSMC --交易对手名称
      ,JYDSPJ --交易对手评级
      ,JYDSPJJG --交易对手评级机构
      ,JYDSZH --交易对手账号
      ,JYDSKHHH --交易对手开户行号
      ,JYDSKHHM --交易对手开户行号
      ,WTGLBZ --委托管理标志
      ,SPRGH --审批人工号
      ,JYYGH --经办人工号
      ,BBZ --备注
      ,CJRQ --采集日期
      ,DATA_SRC_DESC --数据来源中文
      ,ZCSFL --资产三分类代码 --ADD BY LIP 20250415
      )
      WITH MAX_DEAL_SQNO AS (
      SELECT ORI_DEAL_SQNO,MAX(DEAL_SQNO) AS LAST_DEAL_SQNO
        FROM (SELECT /*IBO.DEAL_SQNO AS ORI_DEAL_SQNO,*/ --20220815源系统提供更改
                     IBO.DEAL_SQNO AS DEAL_SQNO,
                     CONNECT_BY_ROOT(IBO.DEAL_SQNO) AS /*DEAL_SQNO*/ ORI_DEAL_SQNO --20220815源系统提供更改
                FROM RRP_MDL.O_IOL_CTMS_FBS_V_IBO_DEAL IBO
               START WITH NVL(DEAL_LINK_SQNO, 0) = 0
               --CONNECT BY PRIOR IBO.DEAL_LINK_SQNO = IBO.DEAL_SQNO) TMP_DATA
              CONNECT BY PRIOR IBO.DEAL_SQNO = IBO.DEAL_LINK_SQNO) TMP_DATA --20220815源系统提供更改
       GROUP BY TMP_DATA.ORI_DEAL_SQNO)
    SELECT '896821'                                                  AS NBJGH --内部机构号
          ,'B1194H244050001'                                         AS JRXKZH --金融许可证号
          ,'广东华兴银行股份有限公司总行'                            AS YXJGMC --银行机构名称
          ,CASE WHEN T1.IBO_TYPE = '0' AND T1.DEAL_DIR = '1'
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
                WHEN T1.IBO_TYPE = '0' AND T1.DEAL_DIR = '-1'
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
                WHEN T1.IBO_TYPE = '4' AND T1.COLLATERAL_METHOD = '质押'
                THEN DECODE(T1.DEAL_DIR,'1','21110201','11110201')
                WHEN T1.IBO_TYPE = '4' AND T1.COLLATERAL_METHOD = '买断'
                THEN DECODE(T1.DEAL_DIR,'1','21110201','11110201')
            END                                                      AS MXKMBH --明细科目编号   --modify by tangan at 20221031
          ,NULL                                                      AS MXKMMC --明细科目名称 --直接根据上面的明细科目编号，再统一关联总账科目表取最好
          ,'银行账户'                                                AS JYZHLX --账户类型
          ,NVL(T1.CLIENT_DEAL_SQNO,TO_CHAR(T1.DEAL_SQNO))||'_' ||'0' AS JYBH --交易编号
          ,T1.COUNTER_PARTY_ID || '_' || T1.DEAL_SQNO                AS JRGJBH --金融工具编号
          ,T1.COUNTER_PARTY_SCNAME || '_' ||
           CASE WHEN T1.IBO_TYPE = '0' THEN DECODE(T1.DEAL_DIR,'1','同业拆入','拆放同业')
                WHEN T1.IBO_TYPE = '4' AND T1.COLLATERAL_METHOD = '质押' THEN DECODE(T1.DEAL_DIR,'1','质押式正回购','质押式逆回购')
                WHEN T1.IBO_TYPE = '4' AND T1.COLLATERAL_METHOD = '买断' THEN DECODE(T1.DEAL_DIR,'1','买断式正回购','买断式逆回购')
            END                                                      AS JRGJMC --金融工具名称
          ,'同业往来'                                                AS YEDL --业务大类
          ,CASE WHEN T1.IBO_TYPE = '0' THEN DECODE(T1.DEAL_DIR,'1','拆入','拆出')
                WHEN T1.IBO_TYPE = '4' THEN DECODE(T1.DEAL_DIR,'1','卖出回购','买入返售')
            END                                                      AS YEZL --业务中类
          ,CASE WHEN T1.IBO_TYPE = '0' AND T1.DEAL_DIR = '1' AND
                     T3.INTERBANKTYPE IN ('境内银行业存款类金融机构','境内银行业非存款类金融机构','境外银行')
                THEN '拆入银行金融机构'
                WHEN T1.IBO_TYPE = '0' AND T1.DEAL_DIR = '1' THEN '拆入非银行金融机构'
                WHEN T1.IBO_TYPE = '0' AND T1.DEAL_DIR = '-1' AND
                     T3.INTERBANKTYPE IN ('境内银行业存款类金融机构','境内银行业非存款类金融机构','境外银行')
                THEN '拆出银行金融机构'
                WHEN T1.IBO_TYPE = '0' AND T1.DEAL_DIR = '-1' THEN '拆出非银行金融机构'
                WHEN T1.IBO_TYPE = '4' THEN DECODE(T1.DEAL_DIR,'1','卖出回购证券','买入返售证券')
            END                                                      AS YEXL --业务小类
          ,CASE WHEN T1.IBO_TYPE = '0' THEN DECODE(T1.DEAL_DIR,'1','同业拆入','拆放同业')
                WHEN T1.IBO_TYPE = '4' AND T1.COLLATERAL_METHOD = '质押'
                THEN DECODE(T1.DEAL_DIR,'1','质押式正回购','质押式逆回购')
                WHEN T1.IBO_TYPE = '4' AND T1.COLLATERAL_METHOD = '买断'
                THEN DECODE(T1.DEAL_DIR,'1','买断式正回购','买断式逆回购')
            END                                                      AS CPMC --产品名称
          ,DECODE(T1.DEAL_DIR,'-1','卖出','买入')                    AS JYFX --交易方向
          ,T1.CRNCY_CODE                                             AS MYBJBZ --合约币种
          ,ABS(T1.FIRST_AMNT)                                        AS MYBJJE --合约金额
          ,T1.RATE                                                   AS NHLL --年化利率
          ,TO_CHAR(T1.MATURITY_DATE,'YYYYMMDD')                      AS JYRQ --交易日期
          ,TO_CHAR(T1.VALUE_DATE,'YYYYMMDD')                         AS HTYDRQ --合同起始日期
          ,TO_CHAR(T1.MATURITY_DATE,'YYYYMMDD')                      AS HTDQRQ --合同到期日期
          ,NVL(SP.BENIFIT_BANK_ACCNT, SR.BENIFIT_BANK_ACCNT)         AS BFQSZH --本方清算账号
          ,NULL                                                      AS JYDSLB --交易对手类别 资金系统没有
          ,TRIM(T3.LABEL)                                            AS ECIF_CODE --ECIF客户号，用于与ECIF系统关联
          ,NULL                                                      AS JYDSMC --交易对手名称
          ,NULL                                                      AS JYDSPJ --交易对手评级
          ,NULL                                                      AS JYDSPJJG --交易对手评级机构
          ,NVL(TRIM(CP.BENIFIT_BANK_ACCNT),TRIM(CR.BENIFIT_BANK_ACCNT)) AS JYDSZH --交易对手账号
          ,NVL(TRIM(CP.ACCOUNT_BANK_BIC),TRIM(CR.ACCOUNT_BANK_BIC))  AS JYDSKHHH --交易对手开户行号
          ,NVL(TRIM(CP.ACCOUNT_BANK_DESC),TRIM(CR.ACCOUNT_BANK_DESC))AS JYDSKHHM --交易对手开户行名
          ,'否'                                                      AS WTGLBZ --委托关联标志
          ,NULL                                                      AS SPRGH
          ,TRIM(T1.DEALER)                                           AS JYYGH  --经办人工号 --MOD BY LIP 20220901
          --,NULL                                                      AS JYYGH --经办人工号 --源表字段空暂时置空
          ,NULL                                                      AS BBZ --备注
          ,V_MONTH_END_DATEID                                        AS CJRQ --采集日期
          ,'外币拆借/外币回购'                                       AS DATA_SRC_DESC --数据来源中文
          ,'AC'                                                      AS ZCSFL --资产三分类代码 --ADD BY LIP 20250415
      FROM RRP_MDL.O_IOL_CTMS_FBS_V_IBO_DEAL T1
     INNER JOIN MAX_DEAL_SQNO T2
        ON T2.LAST_DEAL_SQNO = T1.DEAL_SQNO
     INNER JOIN RRP_MDL.O_IOL_CTMS_FBS_V_COUNTERPARTY T3
        ON T3.COUNTERPARTY_SEQ = T1.COUNTER_PARTY_ID
     INNER JOIN RRP_MDL.O_IOL_CTMS_FBS_V_DEAL_SETTLE_PATH T4
        ON T4.DEAL_SQNO = T1.DEAL_SQNO
      LEFT JOIN RRP_MDL.O_IOL_CTMS_FBS_V_SWT_SETTLE_PATH SP
        ON SP.INFR_SRNO = T4.SELF_PAY
      LEFT JOIN RRP_MDL.O_IOL_CTMS_FBS_V_SWT_SETTLE_PATH SR
        ON T4.SELF_RECEIVE = SR.INFR_SRNO
      LEFT JOIN RRP_MDL.O_IOL_CTMS_FBS_V_SWT_SETTLE_PATH CP
        ON T4.CP_PAY = CP.INFR_SRNO
      LEFT JOIN RRP_MDL.O_IOL_CTMS_FBS_V_SWT_SETTLE_PATH CR
        ON T4.CP_RECEIVE = CR.INFR_SRNO
     WHERE TO_CHAR(T1.MATURITY_DATE,'YYYYMMDD') >= V_MONTH_START_DATEID
       AND TO_CHAR(T1.MATURITY_DATE,'YYYYMMDD') <= V_MONTH_END_DATEID;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --自营资金交易信息表_债券及同业存单投资
    V_STEP      := 7;
    V_STEP_DESC := '自营资金交易信息表_债券及同业存单投资';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_1003_ZYZJJYXXB_ZJ
      (NBJGH --内部机构号
      ,JRXKZH --金融许可证号
      ,YHJGMC --明细科目编号
      ,MXKMBH --银行机构名称
      ,MXKMMC --明细科目名称
      ,JYZHLX --账户类型
      ,JYBH --交易编号
      ,JRGJBH --金融工具编号
      ,JRGJMC --金融工具名称
      ,YEDL --业务大类
      ,YWZL --业务中类
      ,YWXL --业务小类
      ,CPMC --产品名称
      ,JYFX --交易方向
      ,MYBJBZ --合约币种
      ,MYBJJE --合约币种
      ,NHLL --年化利率
      ,JYRQ --交易日期
      ,HTYDRQ --合同起始日期
      ,HTDQRQ --合同到期日期
      ,BFQSZH --本方清算账号
      ,JYDSLB --交易对手类别 资金系统没有
      ,ECIF_CODE --ECIF客户号，用于与ECIF系统关联
      ,JYDSMC --交易对手名称
      ,JYDSPJ --交易对手评级
      ,JYDSPJJG --交易对手评级机构
      ,JYDSZH --交易对手账号
      ,JYDSKHHH --交易对手开户行号
      ,JYDSKHHM --交易对手开户行号
      ,WTGLBZ --委托管理标志
      ,SPRGH --审批人工号
      ,JYYGH --经办人工号
      ,BBZ --备注
      ,CJRQ --采集日期
      ,DATA_SRC_DESC --数据来源中文
      ,ZCSFL --资产三分类代码 --ADD BY LIP 20250415
      )
    SELECT M.DEPARTMENTID                                            AS NBJGH --内部机构号
          ,'B1194H244050001'                                         AS JRXKZH --金融许可证号
          ,'广东华兴银行股份有限公司总行'                            AS YXJGMC --银行机构名称
          /*,CASE WHEN T2.ASSETTYPE_ID_DEFAULT = '1'
                THEN CASE WHEN T4.ISSUER IN ('中华人民共和国铁道部','中国铁路总公司','中国国家铁路集团有限公司') THEN '1101011501'
                          WHEN T4.ISSUER IN ('中国进出口银行','中国农业发展银行','国家开发银行') OR T4.SECURITY_TYPE_NEW = '8'
                          THEN '1101011301'
                          WHEN T4.SECURITY_TYPE_NEW IN ('61','C1','C2','C3','C4','C5','C6','7','U','9','L','X') THEN '1101011401'
                          WHEN T4.SECURITY_TYPE_NEW = '1' THEN '1101011101'
                          WHEN T4.SECURITY_TYPE_NEW = '5' THEN '1101011201'
                          WHEN T4.ISSUER = '中央汇金投资有限责任公司' OR T4.SECURITY_TYPE_NEW IN ('N','6','O','P','V','4','E','L1','D','J')
                          THEN '1101011601'
                          WHEN T4.SECURITY_TYPE_NEW = 'M' THEN '1101011701'
                          WHEN T4.SECURITY_TYPE_NEW = 'W' THEN '1101011901'
                          WHEN T4.SECURITY_TYPE_NEW = 'Z' THEN '1101012001'
                          ELSE '1101011801'
                      END
                WHEN T2.ASSETTYPE_ID_DEFAULT = '2'
                THEN CASE WHEN T4.ISSUER IN ('中华人民共和国铁道部','中国铁路总公司','中国国家铁路集团有限公司') THEN '15031501'
                          WHEN T4.ISSUER IN ('中国进出口银行','中国农业发展银行','国家开发银行') OR T4.SECURITY_TYPE_NEW = '8'
                          THEN '15031301'
                          WHEN T4.SECURITY_TYPE_NEW IN ('61','C1','C2','C3','C4','C5','C6','7','U','9','L','X') THEN '15031401'
                          WHEN T4.SECURITY_TYPE_NEW = '1' THEN '15031101'
                          WHEN T4.SECURITY_TYPE_NEW = '5' THEN '15031201'
                          WHEN T4.ISSUER IN ('中央汇金投资有限责任公司') OR T4.SECURITY_TYPE_NEW IN ('N','6','O','P','V','4','E','L1','D','J')
                          THEN '15031601'
                          WHEN T4.SECURITY_TYPE_NEW = 'M' THEN '15031701'
                          WHEN T4.SECURITY_TYPE_NEW = 'W' THEN '15032001'
                          WHEN T4.SECURITY_TYPE_NEW = 'Z' THEN '15032501'
                          ELSE '15031801'
                      END
                WHEN T2.ASSETTYPE_ID_DEFAULT = '3'
                THEN CASE WHEN T4.ISSUER IN ('中华人民共和国铁道部','中国铁路总公司','中国国家铁路集团有限公司') THEN '15011501'
                          WHEN T4.ISSUER IN ('中国进出口银行','中国农业发展银行','国家开发银行') OR T4.SECURITY_TYPE_NEW = '8'
                          THEN '15011301'
                          WHEN T4.SECURITY_TYPE_NEW IN ('61','C1','C2','C3','C4','C5','C6','7','U','9','L','X') THEN '15011401'
                          WHEN T4.SECURITY_TYPE_NEW = '1' THEN '15011101'
                          WHEN T4.SECURITY_TYPE_NEW = '5' THEN '15011201'
                          WHEN T4.ISSUER IN ('中央汇金投资有限责任公司') OR T4.SECURITY_TYPE_NEW IN ('N','6','O','P','V','4','E','L1','D','J')
                          THEN '15011601'
                          WHEN T4.SECURITY_TYPE_NEW = 'M' THEN '15011701'
                          WHEN T4.SECURITY_TYPE_NEW = 'W' THEN '15011901'
                          WHEN T4.SECURITY_TYPE_NEW = 'Z' THEN '15012001'
                          ELSE '15011801'
                      END
            END                                                      AS MXKMBH --明细科目编号*/
          ,CASE WHEN T2.ASSETTYPE_ID_DEFAULT = '1' --CD1588 交易类
                THEN CASE /*WHEN T4.ISSUER IN ('中华人民共和国铁道部','中国铁路总公司','中国国家铁路集团有限公司') THEN '11010101'
                          WHEN T4.ISSUER IN ('中国进出口银行','中国农业发展银行','国家开发银行') OR T4.SECURITY_TYPE_NEW = '8'
                          THEN '11010101'
                          WHEN T4.SECURITY_TYPE_NEW IN ('61','C1','C2','C3','C4','C5','C6','7','U','9','L','X','C9') THEN '11010101'
                          WHEN T4.SECURITY_TYPE_NEW = '1' THEN '11010101'
                          WHEN T4.SECURITY_TYPE_NEW = '5' THEN '11010101'
                          WHEN T4.ISSUER = '中央汇金投资有限责任公司' OR T4.SECURITY_TYPE_NEW IN ('N','6','O','P','V','4','E','L1','D','J')
                          THEN '11010101'
                          WHEN T4.SECURITY_TYPE_NEW = 'M' THEN '11010101'*/
                          --MOD BY LIP 20250512 新一代后只有这四种科目的映射
                          WHEN T4.SECURITY_TYPE_NEW = 'W' THEN '11010201'
                          WHEN T4.SECURITY_TYPE_NEW IN ('L','L1') THEN '11010301' --ADD BY LIP 20250509 根据上游反馈调整
                          WHEN T4.SECURITY_TYPE_NEW = 'Z' THEN '11010401'
                          --ELSE '11019901'
                          ELSE '11010101' --MOD BY LIP 20250509 根据上游反馈调整
                      END
                WHEN T2.ASSETTYPE_ID_DEFAULT = '2' --CD1588 可供出售类
                THEN CASE /*WHEN T4.ISSUER IN ('中华人民共和国铁道部','中国铁路总公司','中国国家铁路集团有限公司') THEN '15030101'
                          WHEN T4.ISSUER IN ('中国进出口银行','中国农业发展银行','国家开发银行') OR T4.SECURITY_TYPE_NEW = '8'
                          THEN '15030101'
                          WHEN T4.SECURITY_TYPE_NEW IN ('61','C1','C2','C3','C4','C5','C6','7','U','9','L','X','C9') --MOD BY LIP 20240830 增加C9
                          THEN '15030101'
                          WHEN T4.SECURITY_TYPE_NEW = '1' THEN '15030101'
                          WHEN T4.SECURITY_TYPE_NEW = '5' THEN '15030101'
                          WHEN T4.ISSUER IN ('中央汇金投资有限责任公司')
                               OR T4.SECURITY_TYPE_NEW IN ('N','6','O','P','V','4','E','L1','D','J')
                          THEN '15030101'
                          WHEN T4.SECURITY_TYPE_NEW = 'M' THEN '15030101'*/
                          --MOD BY LIP 20250512 新一代后只有这四种科目的映射
                          WHEN T4.SECURITY_TYPE_NEW = 'W' THEN '15030201'
                          WHEN T4.SECURITY_TYPE_NEW IN ('L','L1') THEN '15030301' --ADD BY LIP 20250509 根据上游反馈调整
                          WHEN T4.SECURITY_TYPE_NEW = 'Z' THEN '15030401'
                          WHEN T4.SECURITY_TYPE_NEW IN ('S','F') THEN '15030101' --MOD BY LIP 20241010 15030101 计入其他综合收益的债券面值 --MOD BY LIP 20250506 增加F的映射
                          --ELSE '15039901'
                          ELSE '15030101' --MOD BY LIP 20250509 根据上游反馈调整
                      END
                WHEN T2.ASSETTYPE_ID_DEFAULT = '3' --CD1588 持有至到期类
                --THEN CASE WHEN T4.ISSUER IN ('中华人民共和国铁道部','中国铁路总公司','中国国家铁路集团有限公司') THEN '15011501'
                THEN CASE /*WHEN T4.ISSUER IN ('中华人民共和国铁道部','中国铁路总公司','中国国家铁路集团有限公司') THEN '15010101'
                          WHEN T4.ISSUER IN ('中国进出口银行','中国农业发展银行','国家开发银行') OR T4.SECURITY_TYPE_NEW = '8'
                          THEN '15010101'
                          WHEN T4.SECURITY_TYPE_NEW IN ('61','C1','C2','C3','C4','C5','C6','7','U','9','L','X','C9') THEN '15010101'
                          WHEN T4.SECURITY_TYPE_NEW = '1' THEN '15010101'
                          WHEN T4.SECURITY_TYPE_NEW = '5' THEN '15010101'
                          WHEN T4.ISSUER IN ('中央汇金投资有限责任公司') OR T4.SECURITY_TYPE_NEW IN ('N','6','O','P','V','4','E','L1','D','J')
                          THEN '15010101'
                          WHEN T4.SECURITY_TYPE_NEW = 'M' THEN '15010101'*/
                          --MOD BY LIP 20250512 新一代后只有这四种科目的映射
                          WHEN T4.SECURITY_TYPE_NEW = 'W' THEN '15010201'
                          WHEN T4.SECURITY_TYPE_NEW IN ('L','L1') THEN '15010301' --ADD BY LIP 20250509 根据上游反馈调整
                          WHEN T4.SECURITY_TYPE_NEW = 'Z' THEN '15010401'
                          ELSE '15010101'
                      END
            END                                                      AS MXKMBH --明细科目编号 --MODI
          ,''                                                        AS MXKMMC --明细科目名称
          ,DECODE(T3.CONTROLFACTOR,'NT','交易账户','银行账户')       AS JYZHLX --账户类型
          ,T1.SERIAL_NUMBER                                          AS JYBH --交易编号
           --,T1.REF_NUMBER                                            AS JYBH --交易编号
          ,NVL(T8.EXTRA_CODE, T1.BONDSCODE)                          AS JRGJBH --金融工具编号
          ,T1.BONDSNAME                                              AS JRGJMC --金融工具名称
          ,CASE WHEN T4.SECURITY_TYPE_NEW = 'W' THEN '同业往来'
                ELSE '债券投资与同业投资'
            END                                                      AS YEDL --业务大类
          ,CASE WHEN T4.SECURITY_TYPE_NEW = 'W' THEN '同业存单'
                ELSE '债券投资'
            END                                                      AS YEZL --业务中类
          ,CASE WHEN T4.SECURITY_TYPE_NEW = 'W' THEN '同业存单投资'
                WHEN T4.SECURITY_TYPE_NEW = '1' THEN '国债'
                WHEN T4.SECURITY_TYPE_NEW = 'M' THEN '地方政府债'
                WHEN T4.SECURITY_TYPE_NEW = '5' THEN '央票'
                WHEN T4.SECURITY_TYPE_NEW = 'Q' THEN '政府支持机构债'
                WHEN T4.ISSUER IN ('中国进出口银行','中国农业发展银行','国家开发银行') OR T4.SECURITY_TYPE_NEW = '8' THEN '政策性金融债'
                WHEN T4.SECURITY_TYPE_NEW IN ('61','C1','C2','C3','C4','C5','C6','C9','7','U','9','L','X','Y') THEN '商业性金融债'
                WHEN T4.SECURITY_TYPE_NEW IN ('N','6','O','P','V','4','E','G','D','J','I','H') THEN '非金融企业债券'
                WHEN T4.SECURITY_TYPE_NEW = 'L' THEN '资产支持证券（信贷资产证券化）'
                WHEN T4.SECURITY_TYPE_NEW = 'L1' THEN '资产支持证券（资产支持票据）'
                WHEN T4.SECURITY_TYPE_NEW IN ('F','FL','FG','S') THEN '外国债券' --MOD BY LIP 20241017 增加S的映射
                ELSE '其他-银行自定义'
            END                                                      AS YEXL --业务小类
          ,T1.BONDSNAME                                              AS CPMC --产品名称
          ,DECODE(T1.BUYORSELL,'B','买入','卖出')                    AS JYFX --交易方向
          ,T4.CCY                                                    AS MYBJBZ --合约币种
          ,T1.SETTLEAMOUNT                                           AS MYBJBZ --合约金额
          ,ROUND(T1.YIELDTOMATURITY, 4)                              AS NHLL --年化利率
          ,TRIM(T1.SETTLEDATE)                                       AS JYRQ --交易日期
          ,TRIM(T1.SETTLEDATE)                                       AS HTYDRQ --合同起始日期
          ,TRIM(T4.MATURITY_DATE)                                    AS HTDQRQ --合同到期日期
           --,NVL(T5.SELF_CASH_ACC_NO,T6.SELF_CASH_ACC_NO)             AS BFQSZH --本方清算账号
          ,T5.CASH_ACC_NO                                            AS BFQSZH --本方清算账号
          ,NULL                                                      AS JYDSLB --交易对手类别 资金系统没有
          /*,TRIM(T7.LABEL)                                            AS ECIF_CODE --ECIF客户号，用于与ECIF系统关联
          ,T7.CPTYS_NAME                                             AS JYDSMC --交易对手名称*/
          --MOD BY LIP 20241126
          ,NVL(T9.ECIF_CODE,TRIM(T7.LABEL))                          AS ECIF_CODE --ECIF客户号，用于与ECIF系统关联
          ,NVL(T9.JYDSMC,TRIM(T7.CPTYS_NAME))                        AS JYDSMC --交易对手名称
          ,NULL                                                      AS JYDSPJ --交易对手评级
          ,NULL                                                      AS JYDSPJJG --交易对手评级机构
           --,NVL(T5.CPTY_CASH_ACC_NO,T6.CPTY_CASH_ACC_NO)             AS JYDSZH   --交易对手账号   --原系统已注释
           --,NVL(T5.CPTY_CASH_ACC_BANK_EX,T6.CPTY_CASH_ACC_BANK_EX)   AS JYDSKHHH   --交易对手开户行号  --原系统已注释
           --,NVL(T5.CPTY_CASH_ACC_BANK,T6.CPTY_CASH_ACC_BANK)         AS JYDSKHHM   --交易对手开户行号  --原系统已注释
          /*,T6.CASH_ACC_NO                                            AS JYDSZH --交易对手账号
          ,T6.CASH_ACC_BANK_EX                                       AS JYDSKHHH --交易对手开户行号
          ,T6.CASH_ACC_BANK                                          AS JYDSKHHM --交易对手开户行号*/
          --MOD BY LIP 20241126
          /*,NVL(T9.JYDSZH,TRIM(T6.CASH_ACC_NO))                       AS JYDSZH --交易对手账号
          ,NVL(T9.JYDSKHHH,TRIM(T6.CASH_ACC_BANK_EX))                AS JYDSKHHH --交易对手开户行号
          ,NVL(T9.JYDSKHHM,TRIM(T6.CASH_ACC_BANK))                   AS JYDSKHHM --交易对手开户行号*/
          --MOD BY LIP 20251223 根据一表通调研情况调整
          ,CASE WHEN T4.CCY <> 'CNY' THEN TRIM(T6.BOND_ACC_NO)
                ELSE NVL(T9.JYDSZH,TRIM(T6.CASH_ACC_NO))
            END                                                      AS JYDSZH --交易对手账号
          ,CASE WHEN T4.CCY <> 'CNY' THEN TRIM(T6.BOND_SWIFT_CODE)
                ELSE NVL(T9.JYDSKHHH,TRIM(T6.CASH_ACC_BANK_EX))
            END                                                      AS JYDSKHHH --交易对手开户行号
          ,CASE --WHEN T4.CCY <> 'CNY' THEN TRIM(T6.BOND_ESCROW_OPENING_BANK)
                WHEN T4.CCY <> 'CNY' THEN TRIM(T6.BOND_OWNER) --托管账号开户人 --MOD BY LIP 20260116
                ELSE NVL(T9.JYDSKHHM,TRIM(T6.CASH_ACC_BANK))
            END                                                      AS JYDSKHHM --交易对手开户行号
          ,'否'                                                      AS WTGLBZ --委托管理标志
          ,NULL                                                      AS SPRGH --审批人工号
          ,T1.DN_DEALER                                              AS JYYGH --经办人工号
          ,NULL                                                      AS BBZ --备注
          ,V_MONTH_END_DATEID                                        AS CJRQ --采集日期
          ,'债券及同业存单投资'                                      AS DATA_SRC_DESC --数据来源中文
          ,CASE WHEN T1.KEEPFOLDER_SHORTNAME = '债券发行' THEN 'AC'
                ELSE DECODE(T1.CLASSFYNAME,'交易性金融资产','FVTPL','可供出售金融资产','FVOCI','AC')
            END                                                      AS ZCSFL --资产三分类代码 --ADD BY LIP 20250415
      FROM RRP_MDL.O_IOL_CTMS_TBS_V_BONDSDEALS T1
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_ADDONPORTFOLIO T2
        ON T2.PORTFOLIO_ID = T1.PORTFOLIO_ID
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_KEEPFOLDER T3
        ON T3.KEEPFOLDER_ID = T1.KEEPFOLDER_ID
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_INTERFACE_PORTF_DEPART_MAPPING M
        ON M.KEEPFOLDER_ID = T3.KEEPFOLDER_ID
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_V_SECURITY T4
        ON T4.SECURITY_CODE = T1.BONDSCODE
      --LEFT JOIN CUSTOMER.VS_PAYMENT_TRSI_BONDSDEALS T5 ON T1.SERIAL_NUMBER  = T5.SERIAL_NUMBER --原系统已注释
      --LEFT JOIN CUSTOMER.VS_PAYMENT_TRSI_UNDERWRITE T6 ON T1.SERIAL_NUMBER = T6.SERIAL_NUMBER --原系统已注释
      LEFT JOIN RRP_MDL.O_IOL_CTMS_WTRADE_TR_SI T5
        ON T5.SERIAL_NUMBER = T1.SERIAL_NUMBER
       AND T5.BS = T1.BUYORSELL
      LEFT JOIN RRP_MDL.O_IOL_CTMS_WTRADE_TR_SI T6
        ON T6.SERIAL_NUMBER = T1.SERIAL_NUMBER
       AND T6.BS <> T1.BUYORSELL
      LEFT JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_CPTYS T7
        ON T7.KEY_SRC = T1.CPTYS_ID
      LEFT JOIN RRP_MDL.O_IOL_CTMS_TBS_SECURITY_EXTRA_CODE T8
        ON T8.SECURITY_CODE = T1.BONDSCODE
      LEFT JOIN RRP_EAST.EAST5_1003_ZYZJJYXXB_ZJ_DFXX T9 --转自营的交易对手 --ADD BY LIP 20241126
        ON T9.JYBH = T1.SERIAL_NUMBER
       AND T9.RN = 1
     WHERE SUBSTR(T1.SERIAL_NUMBER, 0, 2) = 'BO'
       AND T1.SOURCE NOT IN ('3','B','V','L','E','I','J') --MOD BY 徐银鹏 20240517 增加排除码值 I J
       AND T1.SETTLEDATE >= V_MONTH_START_DATEID
       AND T1.SETTLEDATE <= V_MONTH_END_DATEID;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

   --自营资金交易信息表_债券及同业存单投资2
    V_STEP      := 8;
    V_STEP_DESC :='自营资金交易信息表_债券及同业存单投资2';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_1003_ZYZJJYXXB_ZJ
      (NBJGH --内部机构号
      ,JRXKZH --金融许可证号
      ,YHJGMC --明细科目编号
      ,MXKMBH --银行机构名称
      ,MXKMMC --明细科目名称
      ,JYZHLX --账户类型
      ,JYBH --交易编号
      ,JRGJBH --金融工具编号
      ,JRGJMC --金融工具名称
      ,YEDL --业务大类
      ,YWZL --业务中类
      ,YWXL --业务小类
      ,CPMC --产品名称
      ,JYFX --交易方向
      ,MYBJBZ --合约币种
      ,MYBJJE --合约币种
      ,NHLL --年化利率
      ,JYRQ --交易日期
      ,HTYDRQ --合同起始日期
      ,HTDQRQ --合同到期日期
      ,BFQSZH --本方清算账号
      ,JYDSLB --交易对手类别 资金系统没有
      ,ECIF_CODE --ECIF客户号，用于与ECIF系统关联
      ,JYDSMC --交易对手名称
      ,JYDSPJ --交易对手评级
      ,JYDSPJJG --交易对手评级机构
      ,JYDSZH --交易对手账号
      ,JYDSKHHH --交易对手开户行号
      ,JYDSKHHM --交易对手开户行号
      ,WTGLBZ --委托管理标志
      ,SPRGH --审批人工号
      ,JYYGH --经办人工号
      ,BBZ --备注
      ,CJRQ --采集日期
      ,DATA_SRC_DESC --数据来源中文
      ,ZCSFL --资产三分类代码 --ADD BY LIP 20250415
      )
    SELECT M.DEPARTMENTID                                            AS NBJGH --内部机构号
          ,'B1194H244050001'                                         AS JRXKZH --金融许可证号
          ,'广东华兴银行股份有限公司总行'                            AS YXJGMC --银行机构名称
          ,CASE WHEN T1.ASSETTYPE = '交易性金融资产'
                THEN CASE --MOD BY LIP 20250512 新一代后只有这四种科目的映射
                          WHEN T4.SECURITY_TYPE_NEW = 'W' THEN '11010201'
                          WHEN T4.SECURITY_TYPE_NEW IN ('L','L1') THEN '11010301' --ADD BY LIP 20250509 根据上游反馈调整
                          WHEN T4.SECURITY_TYPE_NEW = 'Z' THEN '11010401'
                          --ELSE '11019901'
                          ELSE '11010101' --MOD BY LIP 20250509 根据上游反馈调整
                      END
                WHEN T1.ASSETTYPE = '可供出售金融资产'
                THEN CASE WHEN T4.SECURITY_TYPE_NEW = 'W' THEN '15030201'
                          WHEN T4.SECURITY_TYPE_NEW IN ('L','L1') THEN '15030301' --ADD BY LIP 20250509 根据上游反馈调整
                          WHEN T4.SECURITY_TYPE_NEW = 'Z' THEN '15030401'
                          WHEN T4.SECURITY_TYPE_NEW = 'S' THEN '15030101' --MOD BY LIP 20241010 15030101 计入其他综合收益的债券面值
                          --ELSE '15039901'
                          ELSE '15030101' --MOD BY LIP 20250509 根据上游反馈调整
                      END
                WHEN T1.ASSETTYPE = '持有至到期投资'
                THEN CASE --MOD BY LIP 20250512 新一代后只有这四种科目的映射
                          WHEN T4.SECURITY_TYPE_NEW = 'W' THEN '15010201'
                          WHEN T4.SECURITY_TYPE_NEW = 'Z' THEN '15010401'
                          WHEN T4.SECURITY_TYPE_NEW IN ('L','L1') THEN '15010301' --ADD BY LIP 20250509 根据上游反馈调整
                          ELSE '15010101'
                      END
            END                                                      AS MXKMBH --明细科目编号   modify by LHQ 20221102
          ,NULL                                                      AS MXKMMC --明细科目名称
          ,DECODE(T3.CONTROLFACTOR,'NT','交易账户','银行账户')       AS JYZHLX --账户类型
          ,TO_CHAR(T1.DEAL_NAME || '_' || T1.DEAL_ID)                AS JYBH --交易编号
           --,T1.REF_NUMBER                                            AS JYBH  --交易编号
          ,NVL(T8.EXTRA_CODE, T1.BONDSCODE)                          AS JRGJBH --金融工具编号
          ,T4.SECURITY_NAME                                          AS JRGJMC --金融工具名称
          ,CASE WHEN T4.SECURITY_TYPE_NEW = 'W' THEN '同业往来'
                ELSE '债券投资与同业投资'
            END                                                      AS YEDL --业务大类
          ,CASE WHEN T4.SECURITY_TYPE_NEW = 'W' THEN '同业存单'
                ELSE '债券投资'
            END                                                      AS YEZL --业务中类
          ,CASE WHEN T4.SECURITY_TYPE_NEW = 'W' THEN '同业存单投资'
                WHEN T4.SECURITY_TYPE_NEW = '1' THEN '国债'
                WHEN T4.SECURITY_TYPE_NEW = 'M' THEN '地方政府债'
                WHEN T4.SECURITY_TYPE_NEW = '5' THEN '央票'
                WHEN T4.SECURITY_TYPE_NEW = 'Q' THEN '政府支持机构债'
                WHEN T4.ISSUER IN ('中国进出口银行','中国农业发展银行','国家开发银行') OR T4.SECURITY_TYPE_NEW = '8' THEN '政策性金融债'
                WHEN T4.SECURITY_TYPE_NEW IN ('61','C1','C2','C3','C4','C5','C6','C9','7','U','9','L','X','Y') THEN '商业性金融债'
                WHEN T4.SECURITY_TYPE_NEW IN ('N','6','O','P','V','4','E','G','D','J','I','H') THEN '非金融企业债券'
                WHEN T4.SECURITY_TYPE_NEW = 'L' THEN '资产支持证券（信贷资产证券化）'
                WHEN T4.SECURITY_TYPE_NEW = 'L1' THEN '资产支持证券（资产支持票据）'
                WHEN T4.SECURITY_TYPE_NEW IN ('F','FL','FG','S') THEN '外国债券' --MOD BY LIP 20241017 增加S的映射
                ELSE '其他-银行自定义'
            END                                                      AS YEXL --业务小类
          ,T4.SECURITY_NAME                                          AS CPMC --产品名称
          ,'卖出'                                                    AS JYFX --交易方向
          ,T4.CCY                                                    AS MYBJBZ --合约币种
          ,T1.PRINCIPALAMOUNT + T1.INTERESTAMOUNT                    AS MYBJJE --合约金额
          ,DECODE(T4.AUTION_RATE,0,T4.FIXED_RATE,T4.AUTION_RATE)     AS NHLL --年化利率
          ,TRIM(T1.ACT_PAYDATE)                                      AS JYRQ --交易日期
          ,TRIM(T1.ACT_PAYDATE)                                      AS HTYDRQ --合同起始日期
          ,GREATEST(TRIM(T4.MATURITY_DATE),TRIM(T1.ACT_PAYDATE))     AS HTDQRQ --合同到期日期  --MODIFY BY XYP AT 20230608
           --,NVL(T5.SELF_CASH_ACC_NO,T6.SELF_CASH_ACC_NO)             AS BFQSZH --本方清算账号
          ,'800001011003020003'                                      AS BFQSZH --本方清算账号
          ,NULL                                                      AS JYDSLB --交易对手类别 资金系统没有
          ,TRIM(T7.LABEL)                                            AS ECIF_CODE --ECIF客户号，用于与ECIF系统关联
          ,T7.CPTYS_NAME                                             AS JYDSMC --交易对手名称
          ,NULL                                                      AS JYDSPJ --交易对手评级
          ,NULL                                                      AS JYDSPJJG --交易对手评级机构
          /*,NULL                                                      AS JYDSZH --交易对手账号
          ,NULL                                                      AS JYDSKHHH --交易对手行号
          ,NULL                                                      AS JYDSKHHM --交易对手行名*/
          --MOD BY LIP 20260116 参考一表通调整
          ,CASE WHEN T4.CCY <> 'CNY' THEN TRIM(T6.BOND_ACC_NO)
                ELSE NVL(T9.JYDSZH,TRIM(T6.CASH_ACC_NO))
            END                                                      AS JYDSZH --交易对手账号
          ,CASE WHEN T4.CCY <> 'CNY' THEN TRIM(T6.BOND_SWIFT_CODE)
                ELSE NVL(T9.JYDSKHHH,TRIM(T6.CASH_ACC_BANK_EX))
            END                                                      AS JYDSKHHH --交易对手行号
          ,CASE WHEN T4.CCY <> 'CNY' THEN TRIM(T6.BOND_OWNER) --托管账号开户人
                ELSE NVL(T9.JYDSKHHM,TRIM(T6.CASH_ACC_BANK))
            END                                                      AS JYDSKHHM --交易对手行名
          ,'否'                                                      AS WTGLBZ --委托管理标志
          ,NULL                                                      AS SPRGH --审批人工号
          ,NULL                                                      AS JYYGH --经办人工号
          ,NULL                                                      AS BBZ --备注
          ,V_MONTH_END_DATEID                                        AS CJRQ --采集日期
          ,'债券及同业存单投资'                                      AS DATA_SRC_DESC --数据来源中文
          ,DECODE(T1.ASSETTYPE,'交易性金融资产','FVTPL','可供出售金融资产','FVOCI','AC') AS ZCSFL --资产三分类代码 --ADD BY LIP 20250415
      FROM RRP_MDL.O_IOL_CTMS_TBS_V_COUPONDEALS T1
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_KEEPFOLDER T3
        ON T3.KEEPFOLDER_ID = T1.KEEPFOLDER_ID
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_INTERFACE_PORTF_DEPART_MAPPING M
        ON M.KEEPFOLDER_ID = T3.KEEPFOLDER_ID
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_V_SECURITY T4
        ON T4.SECURITY_CODE = T1.BONDSCODE
      LEFT JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_CPTYS T7
        ON TRIM(T7.ISSUER_NAME) = TRIM(T4.ISSUER)
       AND T7.ISLINK_SRC = 'Y' --MODIFY BY XYP AT 20230608
      LEFT JOIN RRP_MDL.O_IOL_CTMS_TBS_SECURITY_EXTRA_CODE T8
        ON T8.SECURITY_CODE = T1.BONDSCODE
      --根据最新一笔取出来的CASH_ACC_NO依旧存在空值，修改逻辑取非空的一笔 --ADD BY LIP 20260116 根据一表通逻辑调整
      LEFT JOIN (SELECT T2.BONDSCODE,T2.SERIAL_NUMBER
                       ,T6.CASH_ACC_NO
                       ,T6.CASH_ACC_BANK_EX
                       ,T6.CASH_ACC_BANK
                       ,T6.BOND_ACC_NO
                       ,T6.BOND_SWIFT_CODE
                       ,T6.BOND_ESCROW_OPENING_BANK
                       ,T6.BOND_OWNER
                       ,ROW_NUMBER() OVER(PARTITION BY T2.BONDSCODE ORDER BY T2.SETTLEDATE ASC) RN
                   FROM RRP_MDL.O_IOL_CTMS_TBS_V_BONDSDEALS T2
                   LEFT JOIN RRP_MDL.O_IOL_CTMS_WTRADE_TR_SI T6
                     ON T6.SERIAL_NUMBER = T2.SERIAL_NUMBER
                    AND T6.BS <> T2.BUYORSELL
                  WHERE TRIM(T6.CASH_ACC_NO) IS NOT NULL) T6
        ON T6.BONDSCODE = T1.BONDSCODE
       AND T6.RN = 1
      LEFT JOIN RRP_EAST.EAST5_1003_ZYZJJYXXB_ZJ_DFXX T9 --转自营的交易对手
        ON T9.JYBH = T6.SERIAL_NUMBER
       AND T9.RN = 1
     WHERE T1.ASSETTYPE IN ('交易性金融资产','可供出售金融资产','持有至到期投资')
       AND T1.PRINCIPALAMOUNT > 0
       AND T1.ACT_PAYDATE >= V_MONTH_START_DATEID
       AND T1.ACT_PAYDATE <= V_MONTH_END_DATEID;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --自营资金交易信息表_本币同业拆借
    V_STEP      := 9;
    V_STEP_DESC := '自营资金交易信息表_本币同业拆借';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_1003_ZYZJJYXXB_ZJ
      (NBJGH         --内部机构号
      ,JRXKZH        --金融许可证号
      ,YHJGMC        --银行机构名称
      ,MXKMBH        --明细科目编号
      ,MXKMMC        --明细科目名称
      ,JYZHLX        --账户类型
      ,JYBH          --交易编号
      ,JRGJBH        --金融工具编号
      ,JRGJMC        --金融工具名称
      ,YEDL          --业务大类
      ,YWZL          --业务中类
      ,YWXL          --业务小类
      ,CPMC          --产品名称
      ,JYFX          --交易方向
      ,MYBJBZ        --合约币种
      ,MYBJJE        --合约金额
      ,NHLL          --年化利率
      ,JYRQ          --交易日期
      ,HTYDRQ        --合同起始日期
      ,HTDQRQ        --合同到期日期
      ,BFQSZH        --本方清算账号
      ,JYDSLB        --交易对手类别 资金系统没有
      ,ECIF_CODE     --ECIF客户号，用于与ECIF系统关联
      ,JYDSMC        --交易对手名称
      ,JYDSPJ        --交易对手评级
      ,JYDSPJJG      --交易对手评级机构
      ,JYDSZH        --交易对手账号
      ,JYDSKHHH      --交易对手开户行号
      ,JYDSKHHM      --交易对手开户行号
      ,WTGLBZ        --委托管理标志
      ,SPRGH         --审批人工号
      ,JYYGH         --经办人工号
      ,BBZ           --备注
      ,CJRQ          --采集日期
      ,DATA_SRC_DESC --数据来源中文
      ,ZCSFL --资产三分类代码 --ADD BY LIP 20250415
      )
    SELECT M.DEPARTMENTID                                            AS NBJGH --内部机构号
          ,'B1194H244050001'                                         AS JRXKZH --金融许可证号
          ,'广东华兴银行股份有限公司总行'                            AS YXJGMC --银行机构名称
          ,CASE WHEN T1.BUYORSELL = 'B'
                THEN DECODE(T5.COMMONATTS_SHORTNAME,'拆入境内银行业存款类金融机构','20030101',
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
                ELSE DECODE(T5.COMMONATTS_SHORTNAME,--'拆放境内银行款项','13020101',
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
            END                                                      AS MXKMBH --明细科目编号 --MOD BY TA 20221031
          ,NULL                                                      AS MXKMMC --明细科目名称 --直接根据上面的明细科目编号，再统一关联总账科目表取最好
          ,DECODE(T2.CONTROLFACTOR,'NT','交易账户','银行账户')       AS JYZHLX --账户类型
          ,T1.SERIAL_NUMBER||'_'||'1'                                AS JYBH --交易编号
          ,T1.CPTYS_ID||'_'||T1.SERIAL_NUMBER                        AS JRGJBH --金融工具编号
          ,T1.CPTYS_SHORT_NAME||'_'||DECODE(T1.BUYORSELL,'B','同业拆入','拆放同业') AS JRGJMC --金融工具名称
          ,'同业往来'                                                AS YEDL --业务大类
          ,DECODE(T1.BUYORSELL,'B','拆入','拆出')                    AS YEZL --业务中类
          ,CASE WHEN T1.BUYORSELL = 'B'
                 --AND T5.COMMONATTS_SHORTNAME IN ('拆入境内银行业存款类金融机构','拆入境内银行业非存款类金融机构','拆入境外银行款项')
                 AND T5.COMMONATTS_SHORTNAME IN ('拆入境内银行业存款类金融机构','拆入境内银行业非存款类金融机构','拆入境外银行') --MOD BY LIP 20250707
                THEN '拆入银行金融机构'
                WHEN T1.BUYORSELL = 'B' THEN '拆入非银行金融机构'
                --WHEN T1.BUYORSELL = 'S' AND T5.COMMONATTS_SHORTNAME IN ('拆放境内银行款项','拆放境外银行款项')
                WHEN T1.BUYORSELL = 'S' AND T5.COMMONATTS_SHORTNAME IN ('拆放境内银行业存款类金融机构','拆放境外银行') --MOD BY LIP 20250707
                THEN '拆出银行金融机构'
                ELSE '拆出非银行金融机构'
            END                                                      AS YWXL --业务小类
          ,DECODE(T1.BUYORSELL,'B','同业拆入','拆放同业')            AS CPMC --产品名称
          ,DECODE(T1.BUYORSELL,'B','卖出','买入')                    AS JYFX --交易方向
          ,'CNY'                                                     AS MYBJBZ --合约币种
          ,T1.AMOUNT                                                 AS MYBJJE --合约金额
          ,T1.REPO_RATE                                              AS NHLL --年化利率
          ,TRIM(T1.VALUE_DATE)                                       AS JYRQ --交易日期
          ,TRIM(T1.VALUE_DATE)                                       AS HTYDRQ --合同起始日期
          ,TRIM(T1.MATURITY_DATE)                                    AS HTDQRQ --合同到期日期
          ,SELFSI.CASH_ACC_NO                                        AS BFQSZH --本方清算账号
          ,NULL                                                      AS JYDSLB --交易对手类别 资金系统没有
          ,TRIM(T3.LABEL)                                            AS ECIF_CODE --ECIF客户号，用于与ECIF系统关联
          ,NULL                                                      AS JYDSMC --交易对手名称
          ,NULL                                                      AS JYDSPJ --交易对手评级
          ,NULL                                                      AS JYDSPJJG --交易对手评级机构
          ,CPTYSI.CASH_ACC_NO                                        AS JYDSZH --交易对手账号
          ,CPTYSI.CASH_ACC_BANK_EX                                   AS JYDSKHHH --交易对手开户行号
          ,CPTYSI.CASH_ACC_BANK                                      AS JYDSKHHM --交易对手开户行号
          ,'否'                                                      AS WTGLBZ --委托管理标志
          ,NULL                                                      AS SPRGH --审批人工号
          ,T1.DN_DEALER                                              AS JYYGH --经办人工号
          ,NULL                                                      AS BBZ --备注
          ,V_MONTH_END_DATEID                                        AS CJRQ --采集日期
          ,'本币同业拆借'                                            AS DATA_SRC_DESC --数据来源中文
          ,'AC'                                                      AS ZCSFL --资产三分类代码 --ADD BY LIP 20250415
      FROM RRP_MDL.O_IOL_CTMS_TBS_V_IAMDEALS T1
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_KEEPFOLDER T2
        ON T2.KEEPFOLDER_ID = T1.KEEPFOLDER_ID
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_INTERFACE_PORTF_DEPART_MAPPING M
        ON M.KEEPFOLDER_ID = T2.KEEPFOLDER_ID
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_CPTYS T3
        ON T3.KEY_SRC = T1.CPTYS_ID
      LEFT JOIN RRP_MDL.O_IOL_CTMS_WTRADE_TR_SI SELFSI
        ON SELFSI.SERIAL_NUMBER = T1.SERIAL_NUMBER
       AND SELFSI.BS = T1.BUYORSELL
      LEFT JOIN RRP_MDL.O_IOL_CTMS_WTRADE_TR_SI CPTYSI
        ON CPTYSI.SERIAL_NUMBER = T1.SERIAL_NUMBER
       AND CPTYSI.BS <> T1.BUYORSELL
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_CPTYATTSMAP T4
        ON T4.CPTYS_ID = T3.CPTYS_ID
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_COMMONATTS T5
        ON T5.COMMONATTS_ID = T4.COMMONATTS_ID
       AND T5.COMMONATTS_ID_PARENT = DECODE(T1.BUYORSELL,'B','11','2')
     WHERE T1.VALUE_DATE >= V_MONTH_START_DATEID
       AND T1.VALUE_DATE <= V_MONTH_END_DATEID;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --自营资金交易信息表_本币同业拆借2
    V_STEP      := 10;
    V_STEP_DESC := '自营资金交易信息表_本币同业拆借2';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_1003_ZYZJJYXXB_ZJ
      (NBJGH         --内部机构号
      ,JRXKZH        --金融许可证号
      ,YHJGMC        --银行机构名称
      ,MXKMBH        --明细科目编号
      ,MXKMMC        --明细科目名称
      ,JYZHLX        --账户类型
      ,JYBH          --交易编号
      ,JRGJBH        --金融工具编号
      ,JRGJMC        --金融工具名称
      ,YEDL          --业务大类
      ,YWZL          --业务中类
      ,YWXL          --业务小类
      ,CPMC          --产品名称
      ,JYFX          --交易方向
      ,MYBJBZ        --合约币种
      ,MYBJJE        --合约币种
      ,NHLL          --年化利率
      ,JYRQ          --交易日期
      ,HTYDRQ        --合同起始日期
      ,HTDQRQ        --合同到期日期
      ,BFQSZH        --本方清算账号
      ,JYDSLB        --交易对手类别 资金系统没有
      ,ECIF_CODE     --ECIF客户号，用于与ECIF系统关联
      ,JYDSMC        --交易对手名称
      ,JYDSPJ        --交易对手评级
      ,JYDSPJJG      --交易对手评级机构
      ,JYDSZH        --交易对手账号
      ,JYDSKHHH      --交易对手开户行号
      ,JYDSKHHM      --交易对手开户行名
      ,WTGLBZ        --委托管理标志
      ,SPRGH         --审批人工号
      ,JYYGH         --经办人工号
      ,BBZ           --备注
      ,CJRQ          --采集日期
      ,DATA_SRC_DESC --数据来源中文
      ,ZCSFL --资产三分类代码 --ADD BY LIP 20250415
      )
    SELECT M.DEPARTMENTID                                            AS NBJGH --内部机构号
          ,'B1194H244050001'                                         AS JRXKZH --金融许可证号
          ,'广东华兴银行股份有限公司总行'                            AS YXJGMC --银行机构名称
          ,CASE WHEN T1.BUYORSELL = 'B'
                THEN DECODE(T5.COMMONATTS_SHORTNAME,'拆入境内银行业存款类金融机构','20030101',
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
                ELSE DECODE(T5.COMMONATTS_SHORTNAME,--'拆放境内银行款项','13020101',
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
            END                                                      AS MXKMBH --明细科目编号 --MODIFY BY TANGAN AT 20221031
          ,NULL                                                      AS MXKMMC --直接根据上面的明细科目编号，再统一关联总账科目表取最好 --明细科目名称
          ,DECODE(T2.CONTROLFACTOR,'NT','交易账户','银行账户')       AS JYZHLX --账户类型
          ,T1.SERIAL_NUMBER||'_'||'0'                                AS JYBH --交易编号
          ,T1.CPTYS_ID||'_'||T1.SERIAL_NUMBER                        AS JRGJBH --金融工具编号
          ,T1.CPTYS_SHORT_NAME||'_'||DECODE(T1.BUYORSELL,'B','同业拆入','拆放同业') AS JRGJMC --金融工具名称
          ,'同业往来'                                                AS YEDL --业务大类
          ,DECODE(T1.BUYORSELL,'B','拆入','拆出')                    AS YEZL --业务中类
          ,CASE WHEN T1.BUYORSELL = 'B'
                  --AND T5.COMMONATTS_SHORTNAME IN ('拆入境内银行业存款类金融机构','拆入境内银行业非存款类金融机构','拆入境外银行款项')
                  AND T5.COMMONATTS_SHORTNAME IN ('拆入境内银行业存款类金融机构','拆入境内银行业非存款类金融机构','拆入境外银行') --MOD BY LIP 20250707
                THEN '拆入银行金融机构'
                WHEN T1.BUYORSELL = 'B' THEN '拆入非银行金融机构'
                --WHEN T1.BUYORSELL = 'S' AND T5.COMMONATTS_SHORTNAME IN ('拆放境内银行款项','拆放境外银行款项')
                WHEN T1.BUYORSELL = 'S' AND T5.COMMONATTS_SHORTNAME IN ('拆放境内银行业存款类金融机构','拆放境外银行') --MOD BY LIP 20250707
                THEN '拆出银行金融机构'
                ELSE '拆出非银行金融机构'
            END                                                      AS YWXL --业务小类
          ,DECODE(T1.BUYORSELL,'B','同业拆入','拆放同业')            AS CPMC --产品名称
          ,DECODE(T1.BUYORSELL,'S','卖出','买入')                    AS JYFX --交易方向
          ,'CNY'                                                     AS MYBJBZ --合约币种
          ,T1.AMOUNT                                                 AS MYBJJE --合约金额
          ,T1.REPO_RATE                                              AS NHLL --年化利率
          ,TRIM(T1.MATURITY_DATE)                                    AS JYRQ --交易日期
          ,TRIM(T1.VALUE_DATE)                                       AS HTYDRQ --合同起始日期
          ,TRIM(T1.MATURITY_DATE)                                    AS HTDQRQ --合同到期日期
          ,SELFSI.CASH_ACC_NO                                        AS BFQSZH --本方清算账号
          ,NULL                                                      AS JYDSLB --交易对手类别 资金系统没有
          ,TRIM(T3.LABEL)                                            AS ECIF_CODE --ECIF客户号，用于与ECIF系统关联
          ,NULL                                                      AS JYDSMC --交易对手名称
          ,NULL                                                      AS JYDSPJ --交易对手评级
          ,NULL                                                      AS JYDSPJJG --交易对手评级机构
          ,CPTYSI.CASH_ACC_NO                                        AS JYDSZH --交易对手账号
          ,CPTYSI.CASH_ACC_BANK_EX                                   AS JYDSKHHH --交易对手开户行号
          ,CPTYSI.CASH_ACC_BANK                                      AS JYDSKHHM --交易对手开户行号
          ,'否'                                                      AS WTGLBZ --委托管理标志
          ,NULL                                                      AS SPRGH --审批人工号
          ,T1.DN_DEALER                                              AS JYYGH --经办人工号
          ,NULL                                                      AS BBZ --备注
          ,V_MONTH_END_DATEID                                        AS CJRQ --采集日期
          ,'本币同业拆借'                                            AS DATA_SRC_DESC --数据来源中文
          ,'AC'                                                      AS ZCSFL --资产三分类代码 --ADD BY LIP 20250415
      FROM RRP_MDL.O_IOL_CTMS_TBS_V_IAMDEALS T1
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_KEEPFOLDER T2
        ON T2.KEEPFOLDER_ID = T1.KEEPFOLDER_ID
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_INTERFACE_PORTF_DEPART_MAPPING M
        ON M.KEEPFOLDER_ID = T2.KEEPFOLDER_ID
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_CPTYS T3
        ON T3.KEY_SRC = T1.CPTYS_ID
      LEFT JOIN RRP_MDL.O_IOL_CTMS_WTRADE_TR_SI SELFSI
        ON SELFSI.SERIAL_NUMBER = T1.SERIAL_NUMBER
       AND SELFSI.BS = T1.BUYORSELL
      LEFT JOIN RRP_MDL.O_IOL_CTMS_WTRADE_TR_SI CPTYSI
        ON CPTYSI.SERIAL_NUMBER = T1.SERIAL_NUMBER
       AND CPTYSI.BS <> T1.BUYORSELL
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_CPTYATTSMAP T4 --8月版本数仓接入
        ON T4.CPTYS_ID = T3.CPTYS_ID
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_COMMONATTS T5
        ON T5.COMMONATTS_ID = T4.COMMONATTS_ID
       AND T5.COMMONATTS_ID_PARENT = DECODE(T1.BUYORSELL,'B','11','2')
     WHERE T1.MATURITY_DATE >= V_MONTH_START_DATEID
       AND T1.MATURITY_DATE <= V_MONTH_END_DATEID;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP      := 11;
    V_STEP_DESC := '自营资金交易信息表_本币债券发行';
    V_STARTTIME := SYSDATE;
    --自营资金交易信息表_本币债券发行
    INSERT INTO RRP_EAST.EAST5_1003_ZYZJJYXXB_ZJ
      (NBJGH --内部机构号
      ,JRXKZH --金融许可证号
      ,YHJGMC --明细科目编号
      ,MXKMBH --银行机构名称
      ,MXKMMC --明细科目名称
      ,JYZHLX --账户类型
      ,JYBH --交易编号
      ,JRGJBH --金融工具编号
      ,JRGJMC --金融工具名称
      ,YEDL --业务大类
      ,YWZL --业务中类
      ,YWXL --业务小类
      ,CPMC --产品名称
      ,JYFX --交易方向
      ,MYBJBZ --合约币种
      ,MYBJJE --合约币种
      ,NHLL --年化利率
      ,JYRQ --交易日期
      ,HTYDRQ --合同起始日期
      ,HTDQRQ --合同到期日期
      ,BFQSZH --本方清算账号
      ,JYDSLB --交易对手类别 资金系统没有
      ,ECIF_CODE --ECIF客户号，用于与ECIF系统关联
      ,JYDSMC --交易对手名称
      ,JYDSPJ --交易对手评级
      ,JYDSPJJG --交易对手评级机构
      ,JYDSZH --交易对手账号
      ,JYDSKHHH --交易对手开户行号
      ,JYDSKHHM --交易对手开户行号
      ,WTGLBZ --委托管理标志
      ,SPRGH --审批人工号
      ,JYYGH --经办人工号
      ,BBZ --备注
      ,CJRQ --采集日期
      ,DATA_SRC_DESC --数据来源中文
      ,ZCSFL --资产三分类代码 --ADD BY LIP 20250415
      )
    SELECT M.DEPARTMENTID                                            AS NBJGH --内部机构号
          ,'B1194H244050001'                                         AS JRXKZH --金融许可证号
          ,'广东华兴银行股份有限公司总行'                            AS YXJGMC --银行机构名称
          ,DECODE(T4.SECURITY_TYPE_NEW,'Y','44010101','9','25020201','25020101') AS MXKMBH --明细科目编号
          ,NULL                                                      AS MXKMMC --直接根据上面的明细科目编号，再统一关联总账科目表取最好  --明细科目名称
          ,DECODE(T3.CONTROLFACTOR,'NT','交易账户','银行账户')       AS JYZHLX --账户类型
          ,T1.SERIAL_NUMBER                                          AS JYBH --交易编号
           --,T1.REF_NUMBER                                            AS JYBH --交易编号
          ,NVL(T8.EXTRA_CODE,T1.BONDSCODE)                           AS JRGJBH --金融工具编号
          ,T1.BONDSNAME                                              AS JRGJMC --金融工具名称
          ,'同业往来'                                                AS YEDL --业务大类
          ,'债券发行'                                                AS YEZL --业务中类
          ,DECODE(T4.SECURITY_TYPE_NEW,'Y','银行永续债','9','商业银行债','X','银行次级债','其他-银行自定义') AS YEXL --业务小类
          ,T1.BONDSNAME                                              AS CPMC --产品名称
          ,DECODE(T1.BUYORSELL,'B','买入','卖出')                    AS JYFX --交易方向
          ,T4.CCY                                                    AS MYBJBZ --合约币种
          ,T1.NOMINAL                                                AS MYBJBZ --合约金额
          ,ROUND(T1.YIELDTOMATURITY,4)                               AS NHLL --年化利率
          ,TRIM(T1.SETTLEDATE)                                       AS JYRQ --交易日期
          ,TRIM(T1.SETTLEDATE)                                       AS HTYDRQ --合同起始日期
          ,TRIM(T4.MATURITY_DATE)                                    AS HTDQRQ --合同到期日期
          --,NVL(T5.SELF_CASH_ACC_NO,T6.SELF_CASH_ACC_NO)              AS BFQSZH --本方清算账号
          ,'800001011003020003'                                      AS BFQSZH --本方清算账号
          ,NULL                                                      AS JYDSLB --交易对手类别 资金系统没有
          ,TRIM(T7.LABEL)                                            AS ECIF_CODE --ECIF客户号，用于与ECIF系统关联
          ,T7.CPTYS_NAME                                             AS JYDSMC --交易对手名称
          ,NULL                                                      AS JYDSPJ --交易对手评级
          ,NULL                                                      AS JYDSPJJG --交易对手评级机构
          --,NVL(T5.CPTY_CASH_ACC_NO,T6.CPTY_CASH_ACC_NO)              AS JYDSZH --交易对手账号
          --,NVL(T5.CPTY_CASH_ACC_BANK_EX,T6.CPTY_CASH_ACC_BANK_EX)    AS JYDSKHHH --交易对手开户行号
          --,NVL(T5.CPTY_CASH_ACC_BANK,T6.CPTY_CASH_ACC_BANK)          AS JYDSKHHM --交易对手开户行号
          ,T6.CASH_ACC_NO                                            AS JYDSZH   --交易对手账号
          ,T6.CASH_ACC_BANK_EX                                       AS JYDSKHHH --交易对手开户行号
          ,T6.CASH_ACC_BANK                                          AS JYDSKHHM --交易对手开户行号
          ,'否'                                                      AS WTGLBZ --委托管理标志
          ,NULL                                                      AS SPRGH --审批人工号
          ,T1.DN_DEALER                                              AS JYYGH --经办人工号
          ,NULL                                                      AS BBZ --备注
          ,V_MONTH_END_DATEID                                        AS CJRQ --采集日期
          ,'本币债券发行'                                            AS DATA_SRC_DESC --数据来源中文
          ,CASE WHEN T1.KEEPFOLDER_SHORTNAME = '债券发行' THEN 'AC'
                ELSE DECODE(T1.CLASSFYNAME,'交易性金融资产','FVTPL','可供出售金融资产','FVOCI','AC')
            END                                                      AS  ZCSFL --资产三分类代码 --ADD BY LIP 20250415
      FROM RRP_MDL.O_IOL_CTMS_TBS_V_BONDSDEALS T1
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_ADDONPORTFOLIO T2
        ON T2.PORTFOLIO_ID = T1.PORTFOLIO_ID
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_KEEPFOLDER T3
        ON T3.KEEPFOLDER_ID = T1.KEEPFOLDER_ID
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_INTERFACE_PORTF_DEPART_MAPPING M
        ON M.KEEPFOLDER_ID = T3.KEEPFOLDER_ID
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_V_SECURITY T4
        ON T4.SECURITY_CODE = T1.BONDSCODE
      LEFT JOIN RRP_MDL.O_IOL_CTMS_WTRADE_TR_SI T5
        ON T5.SERIAL_NUMBER = T1.SERIAL_NUMBER
       AND T5.BS = T1.BUYORSELL
      LEFT JOIN RRP_MDL.O_IOL_CTMS_WTRADE_TR_SI T6
        ON T6.SERIAL_NUMBER = T1.SERIAL_NUMBER
       AND T6.BS <> T1.BUYORSELL
      LEFT JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_CPTYS T7
        ON T7.KEY_SRC = T1.CPTYS_ID
      LEFT JOIN RRP_MDL.O_IOL_CTMS_TBS_SECURITY_EXTRA_CODE T8
        ON T8.SECURITY_CODE = T1.BONDSCODE
     WHERE SUBSTR(T1.SERIAL_NUMBER,0,2) = 'BO'
       AND T1.SOURCE = 'V'
       AND T1.SETTLEDATE >= V_MONTH_START_DATEID
       AND T1.SETTLEDATE <= V_MONTH_END_DATEID;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP      := 12;
    V_STEP_DESC :='自营资金交易信息表_本币债券借贷';
    V_STARTTIME := SYSDATE;
    --自营资金交易信息表_本币债券借贷
    INSERT INTO RRP_EAST.EAST5_1003_ZYZJJYXXB_ZJ
      (NBJGH --内部机构号
      ,JRXKZH --金融许可证号
      ,YHJGMC --明细科目编号
      ,MXKMBH --银行机构名称
      ,MXKMMC --明细科目名称
      ,JYZHLX --账户类型
      ,JYBH --交易编号
      ,JRGJBH --金融工具编号
      ,JRGJMC --金融工具名称
      ,YEDL --业务大类
      ,YWZL --业务中类
      ,YWXL --业务小类
      ,CPMC --产品名称
      ,JYFX --交易方向
      ,MYBJBZ --合约币种
      ,MYBJJE --合约币种
      ,NHLL --年化利率
      ,JYRQ --交易日期
      ,HTYDRQ --合同起始日期
      ,HTDQRQ --合同到期日期
      ,BFQSZH --本方清算账号
      ,JYDSLB --交易对手类别 资金系统没有
      ,ECIF_CODE --ECIF客户号，用于与ECIF系统关联
      ,JYDSMC --交易对手名称
      ,JYDSPJ --交易对手评级
      ,JYDSPJJG --交易对手评级机构
      ,JYDSZH --交易对手账号
      ,JYDSKHHH --交易对手开户行号
      ,JYDSKHHM --交易对手开户行号
      ,WTGLBZ --委托管理标志
      ,SPRGH --审批人工号
      ,JYYGH --经办人工号
      ,BBZ --备注
      ,CJRQ --采集日期
      ,DATA_SRC_DESC --数据来源中文
      ,ZCSFL --资产三分类代码 --ADD BY LIP 20250415
      )
    SELECT M.DEPARTMENTID                                            AS NBJGH --内部机构号
          ,'B1194H244050001'                                         AS JRXKZH --金融许可证号
          ,'广东华兴银行股份有限公司总行'                            AS YXJGMC --银行机构名称
          --,DECODE(T1.BUYORSELL,'B','81210201','81210211')            AS MXKMBH --明细科目编号
          ,DECODE(T1.BUYORSELL,'B','81200101','81200102')            AS MXKMBH --明细科目编号 --MODIFY BY TANGAN AT 20221031
          ,NULL                                                      AS MXKMMC --直接根据上面的明细科目编号，再统一关联总账科目表取最好  --明细科目名称
          ,DECODE(T2.CONTROLFACTOR,'NT','交易账户','银行账户')       AS JYZHLX --账户类型
          ,T1.SERIAL_NUMBER || '_' || '1'                            AS JYBH --交易编号
          ,T1.CPTYS_ID || '_' || T1.SERIAL_NUMBER                    AS JRGJBH --金融工具编号
          ,T1.CPTYS_SHORT_NAME || '_' || DECODE(T1.BUYORSELL,'B','债券借入','债券借出') AS JRGJMC --金融工具名称
          ,'同业往来'                                                AS YEDL --业务大类
          ,'其他'                                                    AS YEZL --业务中类
          ,'债券借贷'                                                AS YWXL --业务小类
          ,DECODE(T1.BUYORSELL,'B','债券借入','债券借出')            AS CPMC --产品名称
          ,DECODE(T1.BUYORSELL,'B','买入','卖出')                    AS JYFX --交易方向
          ,'CNY'                                                     AS MYBJBZ --合约币种
          ,T1.AMOUNT                                                 AS MYBJJE --合约金额
          ,T1.TRADE_RATE                                             AS NHLL --年化利率
          ,TRIM(T1.VALUE_DATE)                                       AS JYRQ --交易日期
          ,TRIM(T1.VALUE_DATE)                                       AS HTYDRQ --合同起始日期
          ,TRIM(T1.MATURITY_DATE)                                    AS HTDQRQ --合同到期日期
          ,SELFSI.CASH_ACC_NO                                        AS BFQSZH --本方清算账号
          ,NULL                                                      AS JYDSLB --交易对手类别 资金系统没有
          ,TRIM(T3.LABEL)                                            AS ECIF_CODE --ECIF客户号，用于与ECIF系统关联
          ,NULL                                                      AS JYDSMC --交易对手名称
          ,NULL                                                      AS JYDSPJ --交易对手评级
          ,NULL                                                      AS JYDSPJJG --交易对手评级机构
          ,CPTYSI.CASH_ACC_NO                                        AS JYDSZH --交易对手账号
          ,CPTYSI.CASH_ACC_BANK_EX                                   AS JYDSKHHH --交易对手开户行号
          ,CPTYSI.CASH_ACC_BANK                                      AS JYDSKHHM --交易对手开户行号
          ,'否'                                                      AS WTGLBZ --委托管理标志
          ,NULL                                                      AS SPRGH --审批人工号
          ,T1.DN_DEALER                                              AS JYYGH --经办人工号
          ,NULL                                                      AS BBZ --备注
          ,V_MONTH_END_DATEID                                        AS CJRQ --采集日期
          ,'本币债券借贷'                                            AS DATA_SRC_DESC --数据来源中文
          ,'AC'                                                      AS ZCSFL --资产三分类代码 --ADD BY LIP 20250415
      FROM RRP_MDL.O_IOL_CTMS_TBS_V_WTRADE_LEND T1
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_KEEPFOLDER T2
        ON T2.KEEPFOLDER_ID = T1.KEEPFOLDER_ID
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_INTERFACE_PORTF_DEPART_MAPPING M
        ON M.KEEPFOLDER_ID = T2.KEEPFOLDER_ID
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_CPTYS T3
        ON T3.KEY_SRC = T1.CPTYS_ID
      LEFT JOIN RRP_MDL.O_IOL_CTMS_WTRADE_TR_SI SELFSI
        ON SELFSI.SERIAL_NUMBER = T1.SERIAL_NUMBER
       AND SELFSI.BS = T1.BUYORSELL
      LEFT JOIN RRP_MDL.O_IOL_CTMS_WTRADE_TR_SI CPTYSI
        ON CPTYSI.SERIAL_NUMBER = T1.SERIAL_NUMBER
       AND CPTYSI.BS <> T1.BUYORSELL
     WHERE T1.VALUE_DATE >= V_MONTH_START_DATEID
       AND T1.VALUE_DATE <= V_MONTH_END_DATEID;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --自营资金交易信息表_本币债券借贷2
    V_STEP      := 13;
    V_STEP_DESC := '自营资金交易信息表_本币债券借贷2';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_1003_ZYZJJYXXB_ZJ
      (NBJGH --内部机构号
      ,JRXKZH --金融许可证号
      ,YHJGMC --明细科目编号
      ,MXKMBH --银行机构名称
      ,MXKMMC --明细科目名称
      ,JYZHLX --账户类型
      ,JYBH --交易编号
      ,JRGJBH --金融工具编号
      ,JRGJMC --金融工具名称
      ,YEDL --业务大类
      ,YWZL --业务中类
      ,YWXL --业务小类
      ,CPMC --产品名称
      ,JYFX --交易方向
      ,MYBJBZ --合约币种
      ,MYBJJE --合约币种
      ,NHLL --年化利率
      ,JYRQ --交易日期
      ,HTYDRQ --合同起始日期
      ,HTDQRQ --合同到期日期
      ,BFQSZH --本方清算账号
      ,JYDSLB --交易对手类别 资金系统没有
      ,ECIF_CODE --ECIF客户号，用于与ECIF系统关联
      ,JYDSMC --交易对手名称
      ,JYDSPJ --交易对手评级
      ,JYDSPJJG --交易对手评级机构
      ,JYDSZH --交易对手账号
      ,JYDSKHHH --交易对手开户行号
      ,JYDSKHHM --交易对手开户行号
      ,WTGLBZ --委托管理标志
      ,SPRGH --审批人工号
      ,JYYGH --经办人工号
      ,BBZ --备注
      ,CJRQ --采集日期
      ,DATA_SRC_DESC --数据来源中文
      ,ZCSFL --资产三分类代码 --ADD BY LIP 20250415
      )
    SELECT M.DEPARTMENTID                                            AS NBJGH --内部机构号
          ,'B1194H244050001'                                         AS JRXKZH --金融许可证号
          ,'广东华兴银行股份有限公司总行'                            AS YXJGMC --银行机构名称
          --,DECODE(T1.BUYORSELL,'B','81210201','81210211')            AS MXKMBH --明细科目编号
          ,DECODE(T1.BUYORSELL,'B','81200101','81200102')            AS MXKMBH --明细科目编号  --modify by tangan at 20221031
          ,NULL                                                      AS MXKMMC --直接根据上面的明细科目编号，再统一关联总账科目表取最好  --明细科目名称
          ,DECODE(T2.CONTROLFACTOR,'NT','交易账户','银行账户')       AS JYZHLX --账户类型
          ,T1.SERIAL_NUMBER || '_' || '0'                            AS JYBH --交易编号
          ,T1.CPTYS_ID || '_' || T1.SERIAL_NUMBER                    AS JRGJBH --金融工具编号
          ,T1.CPTYS_SHORT_NAME || '_' || DECODE(T1.BUYORSELL,'B','债券借入','债券借出') AS JRGJMC --金融工具名称
          ,'同业往来'                                                AS YEDL --业务大类
          ,'其他'                                                    AS YEZL --业务中类
          ,'债券借贷'                                                AS YWXL --业务小类
          ,DECODE(T1.BUYORSELL,'B','债券借入到期','债券借出到期')    AS CPMC --产品名称
          ,DECODE(T1.BUYORSELL,'S','买入','卖出')                    AS JYFX --交易方向
          ,'CNY'                                                     AS MYBJBZ --合约币种
          ,T1.AMOUNT                                                 AS MYBJJE --合约金额
          ,T1.TRADE_RATE                                             AS NHLL --年化利率
          ,TRIM(T1.MATURITY_DATE)                                    AS JYRQ --交易日期
          ,TRIM(T1.VALUE_DATE)                                       AS HTYDRQ --合同起始日期
          ,TRIM(T1.MATURITY_DATE)                                    AS HTDQRQ --合同到期日期
          ,SELFSI.CASH_ACC_NO                                        AS BFQSZH --本方清算账号
          ,NULL                                                      AS JYDSLB --交易对手类别 资金系统没有
          ,TRIM(T3.LABEL)                                            AS ECIF_CODE --ECIF客户号，用于与ECIF系统关联
          ,NULL                                                      AS JYDSMC --交易对手名称
          ,NULL                                                      AS JYDSPJ --交易对手评级
          ,NULL                                                      AS JYDSPJJG --交易对手评级机构
          ,CPTYSI.CASH_ACC_NO                                        AS JYDSZH --交易对手账号
          ,CPTYSI.CASH_ACC_BANK_EX                                   AS JYDSKHHH --交易对手开户行号
          ,CPTYSI.CASH_ACC_BANK                                      AS JYDSKHHM --交易对手开户行号
          ,'否'                                                      AS WTGLBZ --委托管理标志
          ,NULL                                                      AS SPRGH --审批人工号
          ,T1.DN_DEALER                                              AS JYYGH --经办人工号
          ,NULL                                                      AS BBZ --备注
          ,V_MONTH_END_DATEID                                        AS CJRQ --采集日期
          ,'本币债券借贷'                                            AS DATA_SRC_DESC --数据来源中文
          ,'AC'                                                      AS ZCSFL --资产三分类代码 --ADD BY LIP 20250415
      FROM RRP_MDL.O_IOL_CTMS_TBS_V_WTRADE_LEND T1
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_KEEPFOLDER T2
        ON T2.KEEPFOLDER_ID = T1.KEEPFOLDER_ID
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_INTERFACE_PORTF_DEPART_MAPPING M
        ON M.KEEPFOLDER_ID = T2.KEEPFOLDER_ID
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_CPTYS T3
        ON T3.KEY_SRC = T1.CPTYS_ID
      LEFT JOIN RRP_MDL.O_IOL_CTMS_WTRADE_TR_SI SELFSI
        ON SELFSI.SERIAL_NUMBER = T1.SERIAL_NUMBER
       AND SELFSI.BS = T1.BUYORSELL
      LEFT JOIN RRP_MDL.O_IOL_CTMS_WTRADE_TR_SI CPTYSI
        ON CPTYSI.SERIAL_NUMBER = T1.SERIAL_NUMBER
       AND CPTYSI.BS <> T1.BUYORSELL
     WHERE T1.MATURITY_DATE >= TRIM(V_MONTH_START_DATEID) --modify by tangan at 20221226
       AND T1.MATURITY_DATE <= V_MONTH_END_DATEID;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP      := 14;
    V_STEP_DESC := '自营资金交易信息表_本币质押式回购';
    V_STARTTIME := SYSDATE;
    --自营资金交易信息表_本币质押式回购
    INSERT INTO RRP_EAST.EAST5_1003_ZYZJJYXXB_ZJ
      (NBJGH --内部机构号
      ,JRXKZH --金融许可证号
      ,YHJGMC --明细科目编号
      ,MXKMBH --银行机构名称
      ,MXKMMC --明细科目名称
      ,JYZHLX --账户类型
      ,JYBH --交易编号
      ,JRGJBH --金融工具编号
      ,JRGJMC --金融工具名称
      ,YEDL --业务大类
      ,YWZL --业务中类
      ,YWXL --业务小类
      ,CPMC --产品名称
      ,JYFX --交易方向
      ,MYBJBZ --合约币种
      ,MYBJJE --合约币种
      ,NHLL --年化利率
      ,JYRQ --交易日期
      ,HTYDRQ --合同起始日期
      ,HTDQRQ --合同到期日期
      ,BFQSZH --本方清算账号
      ,JYDSLB --交易对手类别 资金系统没有
      ,ECIF_CODE --ECIF客户号，用于与ECIF系统关联
      ,JYDSMC --交易对手名称
      ,JYDSPJ --交易对手评级
      ,JYDSPJJG --交易对手评级机构
      ,JYDSZH --交易对手账号
      ,JYDSKHHH --交易对手开户行号
      ,JYDSKHHM --交易对手开户行号
      ,WTGLBZ --委托管理标志
      ,SPRGH --审批人工号
      ,JYYGH --经办人工号
      ,BBZ --备注
      ,CJRQ --采集日期
      ,DATA_SRC_DESC --数据来源中文
      ,ZCSFL --资产三分类代码 --ADD BY LIP 20250415
      )
    SELECT M.DEPARTMENTID                                            AS NBJGH --内部机构号
          ,'B1194H244050001'                                         AS JRXKZH --金融许可证号
          ,'广东华兴银行股份有限公司总行'                            AS YXJGMC --银行机构名称
          /*,DECODE(T1.BUYORSELL,'B','2111050102','1111040102')        AS MXKMBH --明细科目编号
          ,DECODE(T1.BUYORSELL,'B','卖出回购债券（质押式）','买入返售债券（质押式）') AS MXKMMC --明细科目名称*/
          ,DECODE(T1.BUYORSELL,'B','21110201','11110201')            AS MXKMBH --明细科目编号  --modify by tangan at 20221031
          ,DECODE(T1.BUYORSELL,'B','卖出回购债券成本','买入返售债券成本') AS MXKMMC --明细科目名称  --modify by tangan at 20221031
          ,DECODE(T2.CONTROLFACTOR,'NT','交易账户','银行账户')       AS JYZHLX --账户类型
          ,T1.SERIAL_NUMBER || '_' || '1'                            AS JYBH --交易编号
          ,T1.CPTYS_ID || '_' || T1.SERIAL_NUMBER                    AS JRGJBH --金融工具编号
          ,T1.CPTYS_SHORT_NAME || '_' || DECODE(T1.BUYORSELL,'B','质押式正回购','质押式逆回购') AS JRGJMC --金融工具名称
          ,'同业往来'                                                AS YEDL --业务大类
          ,DECODE(T1.BUYORSELL,'B','卖出回购','买入返售')            AS YEZL --业务中类
          ,DECODE(T1.BUYORSELL,'B','卖出回购证券','买入返售证券')    AS YEXL --业务小类
          ,DECODE(T1.BUYORSELL,'B','质押式正回购','质押式逆回购')    AS CPMC --产品名称
          ,DECODE(T1.BUYORSELL,'B','卖出','买入')                    AS JYFX --交易方向
          ,'CNY'                                                     AS MYBJBZ --合约币种
          ,T1.AMOUNT                                                 AS MYBJJE --合约金额
          ,T1.TRADE_RATE                                             AS NHLL --年化利率
          ,TRIM(T1.VALUE_DATE)                                       AS JYRQ --交易日期
          ,TRIM(T1.VALUE_DATE)                                       AS HTYDRQ --合同起始日期
          ,TRIM(T1.MATURITY_DATE)                                    AS HTDQRQ --合同到期日期
          ,SELFSI.CASH_ACC_NO                                        AS BFQSZH --本方清算账号
          ,NULL                                                      AS JYDSLB --交易对手类别 资金系统没有
          ,TRIM(T3.LABEL)                                            AS ECIF_CODE --ECIF客户号，用于与ECIF系统关联
          ,NULL                                                      AS JYDSMC --交易对手名称
          ,NULL                                                      AS JYDSPJ --交易对手评级
          ,NULL                                                      AS JYDSPJJG --交易对手评级机构
          ,CPTYSI.CASH_ACC_NO                                        AS JYDSZH --交易对手账号
          ,CPTYSI.CASH_ACC_BANK_EX                                   AS JYDSKHHH --交易对手开户行号
          ,CPTYSI.CASH_ACC_BANK                                      AS JYDSKHHM --交易对手开户行号
          ,'否'                                                      AS WTGLBZ --委托管理标志
          ,NULL                                                      AS SPRGH --审批人工号
          ,TRIM(T1.DN_DEALER)                                        AS JYYGH --经办人工号 --MOD BY LIP 20220901
          --,NULL                                                      AS JYYGH --经办人工号 等数仓9月版供数 --源表无字段，暂时置空
          ,NULL                                                      AS BBZ --备注
          ,V_MONTH_END_DATEID                                        AS CJRQ --采集日期
          ,'本币质押式回购'                                          AS DATA_SRC_DESC --数据来源中文
          ,'AC'                                                      AS ZCSFL --资产三分类代码 --ADD BY LIP 20250415
      FROM RRP_MDL.O_IOL_CTMS_TBS_V_LDREPODEALS T1
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_KEEPFOLDER T2
        ON T2.KEEPFOLDER_ID = T1.KEEPFOLDER_ID
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_INTERFACE_PORTF_DEPART_MAPPING M
        ON M.KEEPFOLDER_ID = T2.KEEPFOLDER_ID
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_CPTYS T3
        ON T3.KEY_SRC = T1.CPTYS_ID
      LEFT JOIN RRP_MDL.O_IOL_CTMS_WTRADE_TR_SI SELFSI
        ON SELFSI.SERIAL_NUMBER = T1.SERIAL_NUMBER
       AND SELFSI.BS = T1.BUYORSELL
      LEFT JOIN RRP_MDL.O_IOL_CTMS_WTRADE_TR_SI CPTYSI
        ON CPTYSI.SERIAL_NUMBER = T1.SERIAL_NUMBER
       AND CPTYSI.BS <> T1.BUYORSELL
     WHERE T1.VALUE_DATE >= V_MONTH_START_DATEID
       AND T1.VALUE_DATE <= V_MONTH_END_DATEID;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --自营资金交易信息表_本币质押式回购2
    V_STEP      := 15;
    V_STEP_DESC := '自营资金交易信息表_本币质押式回购2';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_1003_ZYZJJYXXB_ZJ
      (NBJGH --内部机构号
      ,JRXKZH --金融许可证号
      ,YHJGMC --明细科目编号
      ,MXKMBH --银行机构名称
      ,MXKMMC --明细科目名称
      ,JYZHLX --账户类型
      ,JYBH --交易编号
      ,JRGJBH --金融工具编号
      ,JRGJMC --金融工具名称
      ,YEDL --业务大类
      ,YWZL --业务中类
      ,YWXL --业务小类
      ,CPMC --产品名称
      ,JYFX --交易方向
      ,MYBJBZ --合约币种
      ,MYBJJE --合约币种
      ,NHLL --年化利率
      ,JYRQ --交易日期
      ,HTYDRQ --合同起始日期
      ,HTDQRQ --合同到期日期
      ,BFQSZH --本方清算账号
      ,JYDSLB --交易对手类别 资金系统没有
      ,ECIF_CODE --ECIF客户号，用于与ECIF系统关联
      ,JYDSMC --交易对手名称
      ,JYDSPJ --交易对手评级
      ,JYDSPJJG --交易对手评级机构
      ,JYDSZH --交易对手账号
      ,JYDSKHHH --交易对手开户行号
      ,JYDSKHHM --交易对手开户行号
      ,WTGLBZ --委托管理标志
      ,SPRGH --审批人工号
      ,JYYGH --经办人工号
      ,BBZ --备注
      ,CJRQ --采集日期
      ,DATA_SRC_DESC --数据来源中文
      ,ZCSFL --资产三分类代码 --ADD BY LIP 20250415
      )
    SELECT M.DEPARTMENTID                                            AS NBJGH --内部机构号
          ,'B1194H244050001'                                         AS JRXKZH --金融许可证号
          ,'广东华兴银行股份有限公司总行'                            AS YXJGMC --银行机构名称
          /* ,DECODE(T1.BUYORSELL,'B','2111050102','1111040102')       AS MXKMBH --明细科目编号
          ,DECODE(T1.BUYORSELL,'B','卖出回购债券（质押式）','买入返售债券（质押式）') AS MXKMMC --明细科目名称*/
          ,DECODE(T1.BUYORSELL,'B','21110201','11110201')            AS MXKMBH --明细科目编号  --modify by tangan at 20221031
          ,DECODE(T1.BUYORSELL,'B','卖出回购债券成本','买入返售债券成本') AS MXKMMC --明细科目名称  --modify by tangan at 20221031
          ,DECODE(T2.CONTROLFACTOR,'NT','交易账户','银行账户')       AS JYZHLX --账户类型
          ,T1.SERIAL_NUMBER || '_' || '0'                            AS JYBH --交易编号
          ,T1.CPTYS_ID || '_' || T1.SERIAL_NUMBER                    AS JRGJBH --金融工具编号
          ,T1.CPTYS_SHORT_NAME || '_' ||DECODE(T1.BUYORSELL,'B','质押式正回购','质押式逆回购') AS JRGJMC --金融工具名称
          ,'同业往来'                                                AS YEDL --业务大类
          ,DECODE(T1.BUYORSELL,'B','卖出回购','买入返售')            AS YEZL --业务中类
          ,DECODE(T1.BUYORSELL,'B','卖出回购证券','买入返售证券')    AS YEXL --业务小类
          ,DECODE(T1.BUYORSELL,'B','质押式正回购','质押式逆回购')    AS CPMC --产品名称
          ,DECODE(T1.BUYORSELL,'S','卖出','买入')                    AS JYFX --交易方向
          ,'CNY'                                                     AS MYBJBZ --合约币种
          ,T1.AMOUNT                                                 AS MYBJJE --合约金额
          ,T1.TRADE_RATE                                             AS NHLL --年化利率
          ,TRIM(T1.MATURITY_DATE)                                    AS JYRQ --交易日期
          ,TRIM(T1.VALUE_DATE)                                       AS HTYDRQ --合同起始日期
          ,TRIM(T1.MATURITY_DATE)                                    AS HTDQRQ --合同到期日期
          ,SELFSI.CASH_ACC_NO                                        AS BFQSZH --本方清算账号
          ,NULL                                                      AS JYDSLB --交易对手类别 资金系统没有
          ,TRIM(T3.LABEL)                                            AS ECIF_CODE --ECIF客户号，用于与ECIF系统关联
          ,NULL                                                      AS JYDSLB --交易对手类别 资金系统没有
          ,NULL                                                      AS JYDSPJ --交易对手评级
          ,NULL                                                      AS JYDSPJJG --交易对手评级机构
          ,CPTYSI.CASH_ACC_NO                                        AS JYDSZH --交易对手账号
          ,CPTYSI.CASH_ACC_BANK_EX                                   AS JYDSKHHH --交易对手开户行号
          ,CPTYSI.CASH_ACC_BANK                                      AS JYDSKHHM --交易对手开户行号
          ,'否'                                                      AS WTGLBZ --委托管理标志
          ,NULL                                                      AS SPRGH --审批人工号
          ,TRIM(T1.DN_DEALER)                                        AS JYYGH --经办人工号 --MOD BY LIP 20220901
          --,NULL                                                      AS JYYGH --经办人工号 --等数仓9月版供数
          ,NULL                                                      AS BBZ --备注
          ,V_MONTH_END_DATEID                                        AS CJRQ --采集日期
          ,'本币质押式回购'                                          AS DATA_SRC_DESC --数据来源中文
          ,'AC'                                                      AS ZCSFL --资产三分类代码 --ADD BY LIP 20250415
      FROM RRP_MDL.O_IOL_CTMS_TBS_V_LDREPODEALS T1
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_KEEPFOLDER T2
        ON T2.KEEPFOLDER_ID = T1.KEEPFOLDER_ID
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_INTERFACE_PORTF_DEPART_MAPPING M
        ON M.KEEPFOLDER_ID = T2.KEEPFOLDER_ID
     INNER JOIN RRP_MDL.O_IOL_CTMS_TBS_VS_CPTYS T3
        ON T3.KEY_SRC = T1.CPTYS_ID
      LEFT JOIN RRP_MDL.O_IOL_CTMS_WTRADE_TR_SI SELFSI
        ON SELFSI.SERIAL_NUMBER = T1.SERIAL_NUMBER
       AND SELFSI.BS = T1.BUYORSELL
      LEFT JOIN RRP_MDL.O_IOL_CTMS_WTRADE_TR_SI CPTYSI
        ON CPTYSI.SERIAL_NUMBER = T1.SERIAL_NUMBER
       AND CPTYSI.BS <> T1.BUYORSELL
     WHERE T1.MATURITY_DATE >= V_MONTH_START_DATEID
       AND T1.MATURITY_DATE <= V_MONTH_END_DATEID;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP      := 16;
    V_STEP_DESC := '自营资金交易信息表_同业系统';
    V_STARTTIME := SYSDATE;
    --自营资金交易信息表_同业系统
    INSERT INTO RRP_EAST.EAST5_1003_ZYZJJYXXB_TY
      (NBJGH --内部机构号
      ,JRXKZH --金融许可证号
      ,YHJGMC --银行机构名称
      ,MXKMBH --明细科目编号
      ,MXKMMC --明细科目名称
      ,JYZHLX --账户类型
      ,JYBH --交易编号
      ,JRGJBH --金融工具编号
      ,JRGJMC --金融工具名称
      ,YEDL --业务大类
      ,YWZL --业务中类
      ,YWXL --业务小类
      ,CPMC --产品名称
      ,JYFX --交易方向
      ,MYBJBZ --合约币种
      ,MYBJJE --合约金额
      ,NHLL --年化利率
      ,JYRQ --交易日期
      ,HTYDRQ --合同起始日期
      ,HTDQRQ --合同到期日期
      ,BFQSZH --本方清算账号
      ,JYDSLB --交易对手类别
      ,JYDSMC --交易对手名称
      ,JYDSHXKHH --交易对手核心客户号
      ,JYDSPJ --交易对手评级
      ,JYDSPJJG --交易对手评级机构
      ,JYDSZH --交易对手账号
      ,JYDSKHHH --交易对手开户行号
      ,JYDSKHHM --交易对手开户行名
      ,WTGLBZ --委托管理标志
      ,SPRGH --审批人工号
      ,JYYGH --经办人工号
      ,BBZ --备注
      ,CJRQ --采集日期
      ,DATA_SRC_DESC --数据来源中文
      ,ZCSFL --资产三分类代码 --ADD BY LIP 20250415
      )
      WITH PARAMS AS (
      SELECT TO_CHAR(TO_DATE(V_MONTH_START_DATEID,'YYYYMMDD'),'YYYY-MM-DD') BEGDATE,
             TO_CHAR(TO_DATE(V_MONTH_END_DATEID,'YYYYMMDD'),'YYYY-MM-DD') ENDDATE FROM DUAL),
      SUBJ_VIEW AS (
      SELECT MAX(EN.SUBJ_CODE) SUBJ_CODE,
             CASE WHEN TRD.REF_TYPE = 4 THEN V.TRADE_ID
                  WHEN V.TRD_TYPE = '0201100' THEN V.TRADE_ID
                  ELSE COALESCE(PV.TRADE_ID, V.TRADE_ID)
              END TRADE_ID,
             MAX(EN.CORE_ACCT_NAME) CORE_ACCT_NAME,
             CASE WHEN TRD.REF_TYPE = 4 THEN V.INST_ID --下行匹配不去父指令
                  WHEN V.TRD_TYPE = '0201100' THEN V.INST_ID --承销注册多投组不取父交易
                  WHEN V.TRD_TYPE = '0702241' THEN V.INST_ID --债券基金分红转投资不取父交易
                  ELSE COALESCE(PV.INST_ID, V.INST_ID)
              END INST_ID
        FROM (SELECT *
                FROM RRP_MDL.O_IOL_IBMS_TTRD_BOOKKEEPING_ENTRY
               WHERE ENTRY_DATE >= (SELECT BEGDATE FROM PARAMS)
                 AND ENTRY_DATE <= (SELECT ENDDATE FROM PARAMS)
              UNION ALL
              SELECT *
                FROM RRP_MDL.O_IOL_IBMS_TTRD_BOOKKEEPING_ENTRY_HIS
               WHERE ENTRY_DATE >= (SELECT BEGDATE FROM PARAMS)
                 AND ENTRY_DATE <= (SELECT ENDDATE FROM PARAMS)) EN
        LEFT JOIN RRP_MDL.O_IOL_IBMS_VTRD_SET_INSTRUCTION_SECU SE
          ON EN.INST_ID = DECODE(SE.SECU_INST_SETGRP_ID,0,SE.SECU_INST_ID,-1,TRIM(SE.SECU_INST_ID),NULL,SE.SECU_INST_ID,SE.SECU_INST_SETGRP_ID)
        LEFT JOIN RRP_MDL.O_IOL_IBMS_VTRD_SET_INSTRUCTION_CASH CA
          ON EN.INST_ID = DECODE(CA.CASH_INST_SETGRP_ID,0,CA.CASH_INST_ID,-1,TRIM(CA.CASH_INST_ID),NULL,CA.CASH_INST_ID,CA.CASH_INST_SETGRP_ID)
        LEFT JOIN RRP_MDL.O_IOL_IBMS_VTRD_SET_INSTRUCTION V
          ON COALESCE(SE.INST_ID,CA.INST_ID) = V.INST_ID
        LEFT JOIN RRP_MDL.O_IOL_IBMS_VTRD_SET_INSTRUCTION PV
          ON PV.INST_ID = V.INST_GRP_ID
        LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_OTC_TRADE TRD
          ON TRD.INTORDID = PV.TRADE_ID
        LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_OTC_TRADE CTRD
          ON CTRD.INTORDID = V.TRADE_ID
        LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_ACCOUNTING_ENTRY_DEF D
          ON D.ACTING_CODE = EN.SUBJ_CODE
       WHERE D.GZB_TYPE = '1'
         AND EN.STATE = 1
         AND EN.GRP_FLOW_ID = -1
         AND V.STATE = 999
         AND V.TRD_TYPE NOT IN ('0150301','0150300') --交易所质押式回购资金交割数据过滤掉
       GROUP BY CASE WHEN TRD.REF_TYPE = 4 THEN V.TRADE_ID
                     WHEN V.TRD_TYPE = '0201100' THEN V.TRADE_ID
                     ELSE COALESCE(PV.TRADE_ID,V.TRADE_ID)
                 END,
                CASE WHEN TRD.REF_TYPE = 4 THEN V.INST_ID --下行匹配不去父指令
                     WHEN V.TRD_TYPE = '0201100' THEN V.INST_ID --承销注册多投组不取父交易
                     WHEN V.TRD_TYPE = '0702241' THEN V.INST_ID --债券基金分红转投资不取父交易
                     ELSE COALESCE(PV.INST_ID,V.INST_ID)
                END),
      CHG_MAIN AS (
      SELECT INST_ID,TRADE_ID,INST_TYPE,I_CODE,A_TYPE,M_TYPE,CHG_DATE,EXTRA_DIM,SECU_ACCT_ID,REF_CASH_INST_ID,
             REAL_SET_DATE,TRD_TYPE,BORS,TRADE_GRP_ID,ACCOUNT_USER,OPERATOR_ID,CD_TRADE_ID,
             SUM(REAL_CP) REAL_CP,
             SUM(SECU_AMOUNT) SECU_AMOUNT
        FROM (SELECT A.*
                FROM (SELECT CASE WHEN TRD.REF_TYPE = 4 THEN V.INST_ID --下行匹配不去父指令
                                  WHEN V.TRD_TYPE = '0201100' THEN V.INST_ID --承销注册多投组不取父交易
                                  WHEN V.TRD_TYPE = '0702241' THEN V.INST_ID --债券基金分红转投资不取父交易
                                  ELSE COALESCE(PV.INST_ID, V.INST_ID)
                              END INST_ID,
                             CASE WHEN TRD.REF_TYPE = 4 THEN V.TRADE_ID
                                  WHEN V.TRD_TYPE = '0201100' THEN V.TRADE_ID
                                  ELSE COALESCE(PV.TRADE_ID, V.TRADE_ID)
                              END TRADE_ID,
                             CASE WHEN TRD.REF_TYPE = 4 THEN V.INST_TYPE
                                  WHEN V.TRD_TYPE = '0201100' THEN V.INST_TYPE
                                  ELSE COALESCE(PV.INST_TYPE, V.INST_TYPE)
                              END INST_TYPE,
                             C.I_CODE,C.A_TYPE,C.M_TYPE,C.CHG_DATE,C.EXTRA_DIM,C.SECU_ACCT_ID,C.TRADE_GRP_ID,
                             CASE WHEN TRD.REF_TYPE = 4 THEN V.REF_CASH_INST_ID
                                  WHEN V.TRD_TYPE = '0201100' THEN V.REF_CASH_INST_ID
                                  ELSE COALESCE(PV.REF_CASH_INST_ID, V.REF_CASH_INST_ID)
                             END REF_CASH_INST_ID,
                             CASE WHEN TRD.REF_TYPE = 4 THEN V.REAL_SET_DATE
                                  --WHEN V.TRD_TYPE = '0201100' THEN V.REAL_SET_DATE
                                  --MOD BY LIP 20240423 根据上游提供的口径调整
                                  WHEN V.TRD_TYPE IN ('0201100','0706080_L','0700080_L','0702080_L') THEN V.REAL_SET_DATE
                                  WHEN FV.TRD_TYPE IN ('0702080','0700111','0700080','0706080') THEN FV.REAL_SET_DATE
                                  ELSE COALESCE(PV.REAL_SET_DATE, V.REAL_SET_DATE)
                              END REAL_SET_DATE,
                             CASE WHEN TRD.REF_TYPE = 4 THEN V.TRD_TYPE
                                  WHEN V.TRD_TYPE = '0201100' THEN V.TRD_TYPE
                                  ELSE COALESCE(PV.TRD_TYPE, V.TRD_TYPE)
                              END TRD_TYPE,
                             CASE WHEN C.REAL_CP + C.DUE_CP + C.REAL_AMOUNT + C.DUE_AMOUNT > 0 THEN 'B'
                                  ELSE 'S'
                              END BORS,
                             ABS(CASE WHEN S.P_TYPE IN ('2000','0202') THEN C.REAL_AMOUNT + C.DUE_AMOUNT
                                      WHEN V.TRD_TYPE = '0700111_F' THEN C.REAL_CP + C.DUE_CP - C.PRFT_TRD
                                      WHEN V.TRD_TYPE IN ('0150301_L','0150300_L') THEN C.REAL_AMOUNT + C.DUE_AMOUNT
                                      ELSE C.REAL_CP + C.DUE_CP
                                  END) REAL_CP,
                             ABS(SE.REAL_AI + SE.REAL_CP) SECU_AMOUNT,
                             V.ACCOUNT_USER,
                             V.OPERATOR_ID,
                             CASE WHEN V.TRD_TYPE IN ('0000081','0000300','0000200') AND S.P_CLASS = '同业存单' THEN C.TRADE_ID
                                  ELSE NULL
                              END CD_TRADE_ID
                        FROM (SELECT CHG_TYPE,INST_ID,I_CODE,A_TYPE,M_TYPE,ERASE_REF_CHG_ID,ESTD_OR_REAL,PRFT_TRD,
                                     C.CHG_DATE,C.EXTRA_DIM,C.SECU_ACCT_ID,C.TRADE_GRP_ID,C.REAL_CP,C.DUE_CP,C.REAL_AMOUNT,
                                     C.DUE_AMOUNT,C.TRADE_ID
                                FROM RRP_MDL.O_IOL_IBMS_TTRD_ACCOUNTING_SECU_CHG C
                              UNION ALL
                              SELECT CHG_TYPE,INST_ID,I_CODE,A_TYPE,M_TYPE,ERASE_REF_CHG_ID,ESTD_OR_REAL,PRFT_TRD,
                                     C.CHG_DATE,C.EXTRA_DIM,C.SECU_ACCT_ID,C.TRADE_GRP_ID,C.REAL_CP,C.DUE_CP,C.REAL_AMOUNT,
                                     C.DUE_AMOUNT,C.TRADE_ID
                                FROM RRP_MDL.O_IOL_IBMS_TTRD_ACCOUNTING_SECU_CHG_HIS C
                               WHERE CHG_DATE >= (SELECT BEGDATE FROM PARAMS)) C
                        LEFT JOIN RRP_MDL.O_IOL_IBMS_VTRD_SET_INSTRUCTION_SECU SE
                          ON SE.SECU_INST_ID = C.INST_ID
                        LEFT JOIN RRP_MDL.O_IOL_IBMS_VTRD_SET_INSTRUCTION V
                          ON V.INST_ID = SE.INST_ID
                        LEFT JOIN RRP_MDL.O_IOL_IBMS_VTRD_SET_INSTRUCTION FV
                          ON FV.TRADE_ID = V.TRADE_ID
                         AND FV.TRD_TYPE IN ('0702080','0700111','0700080','0706080')
                         AND V.TRD_TYPE LIKE FV.TRD_TYPE || '\__' ESCAPE '\'
                         AND FV.STATE = 999
                        LEFT JOIN RRP_MDL.O_IOL_IBMS_VTRD_SET_INSTRUCTION PV
                          ON PV.INST_ID = V.INST_GRP_ID
                        LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_OTC_TRADE TRD
                          ON TRD.INTORDID = PV.TRADE_ID
                        LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_OTC_TRADE CTRD
                          ON CTRD.INTORDID = V.TRADE_ID
                        LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_INSTRUMENT S
                          ON S.I_CODE = C.I_CODE
                         AND S.A_TYPE = C.A_TYPE
                         AND S.M_TYPE = C.M_TYPE
                       WHERE 1 = 1
                         AND V.STATE = 999
                         AND C.ERASE_REF_CHG_ID = -1
                         AND C.ESTD_OR_REAL = 'R'
                         AND (V.TRD_TYPE LIKE '____0%' OR  V.TRD_TYPE LIKE '____1%' OR V.TRD_TYPE LIKE '____2%' OR
                              V.TRD_TYPE LIKE '____3%' OR V.TRD_TYPE IN ('0100531','0170531','0121531','0125531','0125530'))
                         AND C.REAL_CP + C.DUE_CP + C.REAL_AMOUNT + C.DUE_AMOUNT <> 0
                         AND C.CHG_TYPE <> 'UN_OVER_DUE_90'
                         AND V.TRD_TYPE NOT IN ('0000061','X002000','0706071','0706070','0706251','0150301','0150300') --交易所质押式回购资金交割数据过滤掉
                      ) A
               INNER JOIN PARAMS P
                  ON 1 = 1
               WHERE A.REAL_SET_DATE >= P.BEGDATE
                 AND A.REAL_SET_DATE <= P.ENDDATE
              UNION ALL
              SELECT A.*
                FROM (SELECT CASE WHEN TRD.REF_TYPE = 4 THEN V.INST_ID --下行匹配不去父指令
                                  WHEN V.TRD_TYPE = '0201100' THEN V.INST_ID --承销注册多投组不取父交易
                                  ELSE COALESCE(PV.INST_ID, V.INST_ID)
                              END INST_ID,
                             CASE WHEN TRD.REF_TYPE = 4 THEN V.TRADE_ID
                                  WHEN V.TRD_TYPE = '0201100' THEN V.TRADE_ID
                                  ELSE COALESCE(PV.TRADE_ID, V.TRADE_ID)
                              END TRADE_ID,
                             CASE WHEN TRD.REF_TYPE = 4 THEN V.INST_TYPE
                                  WHEN V.TRD_TYPE = '0201100' THEN V.INST_TYPE
                                  ELSE COALESCE(PV.INST_TYPE, V.INST_TYPE)
                              END INST_TYPE,
                             C.I_CODE,C.A_TYPE,C.M_TYPE,C.CHG_DATE,C.EXTRA_DIM,C.SECU_ACCT_ID,C.TRADE_GRP_ID,
                             CASE WHEN TRD.REF_TYPE = 4 THEN V.REF_CASH_INST_ID
                                  WHEN V.TRD_TYPE = '0201100' THEN V.REF_CASH_INST_ID
                                  ELSE COALESCE(PV.REF_CASH_INST_ID, V.REF_CASH_INST_ID)
                              END REF_CASH_INST_ID,
                             CASE WHEN TRD.REF_TYPE = 4 THEN V.REAL_SET_DATE
                                  WHEN V.TRD_TYPE = '0201100' THEN V.REAL_SET_DATE
                                  WHEN FV.TRD_TYPE IN ('0702080','0700111','0700080','0706080') THEN FV.REAL_SET_DATE
                                  ELSE COALESCE(PV.REAL_SET_DATE, V.REAL_SET_DATE)
                              END REAL_SET_DATE,
                             CASE WHEN TRD.REF_TYPE = 4 THEN V.TRD_TYPE
                                  WHEN V.TRD_TYPE = '0201100' THEN V.TRD_TYPE
                                  ELSE COALESCE(PV.TRD_TYPE, V.TRD_TYPE)
                              END TRD_TYPE,
                             'B' BORS,
                             ABS(C.PRFT_TRD) REAL_CP,
                             0 SECU_AMOUNT,
                             V.ACCOUNT_USER,
                             V.OPERATOR_ID,
                             NULL CD_TRADE_ID
                        FROM (SELECT INST_ID,I_CODE,M_TYPE,A_TYPE,ERASE_REF_CHG_ID,ESTD_OR_REAL,PRFT_TRD,C.CHG_DATE,C.EXTRA_DIM,
                                     C.SECU_ACCT_ID,C.TRADE_GRP_ID
                                FROM RRP_MDL.O_IOL_IBMS_TTRD_ACCOUNTING_SECU_CHG C
                              UNION ALL
                              SELECT INST_ID,I_CODE,M_TYPE,A_TYPE,ERASE_REF_CHG_ID,ESTD_OR_REAL,PRFT_TRD,C.CHG_DATE,C.EXTRA_DIM,
                                     C.SECU_ACCT_ID,C.TRADE_GRP_ID
                                FROM RRP_MDL.O_IOL_IBMS_TTRD_ACCOUNTING_SECU_CHG_HIS C
                               WHERE CHG_DATE >= (SELECT BEGDATE FROM PARAMS)) C
                        LEFT JOIN RRP_MDL.O_IOL_IBMS_VTRD_SET_INSTRUCTION_SECU SE
                          ON SE.SECU_INST_ID = C.INST_ID
                        LEFT JOIN RRP_MDL.O_IOL_IBMS_VTRD_SET_INSTRUCTION V
                          ON V.INST_ID = SE.INST_ID
                        LEFT JOIN RRP_MDL.O_IOL_IBMS_VTRD_SET_INSTRUCTION FV
                          ON FV.TRADE_ID = V.TRADE_ID
                         AND FV.TRD_TYPE IN ('0702080','0700111','0700080','0706080')
                         AND V.TRD_TYPE LIKE FV.TRD_TYPE || '\__' ESCAPE '\'
                         AND FV.STATE = 999
                        LEFT JOIN RRP_MDL.O_IOL_IBMS_VTRD_SET_INSTRUCTION PV
                          ON PV.INST_ID = V.INST_GRP_ID
                        LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_OTC_TRADE TRD
                          ON TRD.INTORDID = PV.TRADE_ID
                        LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_OTC_TRADE CTRD
                          ON CTRD.INTORDID = V.TRADE_ID
                        LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_INSTRUMENT S
                          ON S.I_CODE = C.I_CODE
                         AND S.A_TYPE = C.A_TYPE
                         AND S.M_TYPE = C.M_TYPE
                       WHERE 1 = 1
                         AND V.STATE = 999
                         AND C.ERASE_REF_CHG_ID = -1
                         AND C.ESTD_OR_REAL = 'R'
                         AND V.TRD_TYPE = '0700111_F'
                         AND C.PRFT_TRD <> 0) A
               INNER JOIN PARAMS P
                  ON 1 = 1
               WHERE A.REAL_SET_DATE >= P.BEGDATE
                 AND A.REAL_SET_DATE <= P.ENDDATE)
       GROUP BY INST_ID,TRADE_ID,INST_TYPE,I_CODE,A_TYPE,M_TYPE,CHG_DATE,EXTRA_DIM,SECU_ACCT_ID,REF_CASH_INST_ID,
                REAL_SET_DATE,TRD_TYPE,BORS,ACCOUNT_USER,OPERATOR_ID,TRADE_GRP_ID,CD_TRADE_ID),
      ZHLXVIEW AS
       (SELECT *
          FROM (SELECT SECU_ACCID,TRADE_GRP_ID,I_CODE,A_TYPE,M_TYPE,CREDIT_SECU_TYPE,
                       ROW_NUMBER() OVER(PARTITION BY SECU_ACCID, TRADE_GRP_ID, I_CODE, A_TYPE, M_TYPE ORDER BY SETDATE DESC) FK
                  FROM (SELECT TRD.SECU_ACCID,
                               COALESCE(TRD.TRADE_GRP_ID,'-1') TRADE_GRP_ID,
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
                            ON TRD.I_CODE = S.I_CODE
                           AND TRD.A_TYPE = S.A_TYPE
                           AND TRD.M_TYPE = S.M_TYPE
                         WHERE TRD.ORDSTATUS = 4
                           AND TRD.INSSTATUS = 999
                           AND TRD.CREDIT_SECU_TYPE IS NOT NULL
                           AND TRD.SETDATE <= (SELECT ENDDATE FROM PARAMS)) TRD)
         WHERE FK = 1)
    SELECT INST.ORG_ID                                                 AS NBJGH, --内部机构号
           NULL                                                        AS JRXKZH, --金融许可证号
           NULL                                                        AS YHJGMC, --银行机构名称
           COALESCE(SV.SUBJ_CODE, MSV.SUBJ_CODE)                       AS MXKMBH, --明细科目编号
           COALESCE(SV.CORE_ACCT_NAME, MSV.CORE_ACCT_NAME)             AS MXKMMC, --明细科目名称
           --DECODE(COALESCE(ZV.CREDIT_SECU_TYPE, T.CREDIT_SECU_TYPE),'Bank','银行账簿','Trade','交易账簿') AS ZHLX, --账户类型
           --MODIFY BY LIP 20220826 根据校验账户类型非空时应填 银行账户、交易账户 修改
           DECODE(COALESCE(TRIM(ZV.CREDIT_SECU_TYPE), TRIM(T.CREDIT_SECU_TYPE)),'Bank','银行账户','Trade','交易账户') AS ZHLX, --账户类型
           CASE WHEN C.INST_TYPE = 2 OR C.INST_TYPE <= -100 THEN TO_CHAR(C.INST_ID)
                WHEN C.TRD_TYPE IN ('0702241','0700241','0150301_L','0150300_L') THEN TO_CHAR(C.INST_ID)
                ELSE T.INTORDID
           END                                                         AS JYBH, --交易编号
           COALESCE(TB.I_CODE, S.I_CODE) || COALESCE(TB.A_TYPE, S.A_TYPE) ||
           COALESCE(TB.M_TYPE, S.M_TYPE) || INST.ORG_ID ||
           CASE WHEN S.P_CLASS = '同业存单' AND NT.TRDTYPE = '0000081' THEN TO_CHAR(NRD.PARTYID)
                ELSE ''
            END                                                        AS JRGJBH, --金融工具编号
           COALESCE(TB.B_NAME, S.I_NAME)                               AS JRGJMC, --金融工具名称
           ST.LTYPE                                                    AS YWDL, --业务大类
           ST.MTYPE                                                    AS YWZL, --业务中类
           ST.STYPE                                                    AS YWXL, --业务小类
           COALESCE(TB.B_NAME, S.I_NAME)                               AS CPMC, --产品名称
           CASE WHEN T.TRDTYPE = '2000100' THEN '买入' --ADD BY LIP 20250715
                WHEN T.TRDTYPE = '2000101' THEN '卖出' --ADD BY LIP 20250715
                WHEN C.BORS = 'B' THEN '买入'
                WHEN C.BORS = 'S' THEN '卖出'
            END                                                        AS JYFX, --交易方向
           S.CURRENCY                                                  AS MYBJBZ, --合约币种
           ROUND(ABS(CASE WHEN S.P_TYPE IN ('0703','0706') AND C.TRD_TYPE = '0702241' THEN C.REAL_CP
                          WHEN TB.P_CLASS = '同业存单' AND C.TRD_TYPE IN ('0000300','0000020') THEN C.REAL_CP
                          WHEN TB.P_CLASS = '同业存单' AND C.TRD_TYPE IN ('0000081') THEN NT.ORDAMOUNT
                          WHEN C.TRD_TYPE = '0000201' THEN C.SECU_AMOUNT
                          WHEN S.P_TYPE IN ('0000','1100','1200') AND (C.INST_TYPE = 2 OR C.INST_TYPE <= -100) THEN VSIC.AMOUNT
                          WHEN S.P_TYPE IN ('0703','0706','0000','1100','1200') THEN T.ORDAMOUNT
                          ELSE C.REAL_CP
                      END), 2)                                         AS MYBJJE, --合约金额
           ROUND(CASE WHEN TB.P_CLASS = '同业存单' AND C.TRD_TYPE IN ('0000081','0000300','0000020')
                      THEN COALESCE(NCD.ANNUAL_RATE, S.COUPON * 100)
                      ELSE DECODE(S.COUPON_TYPE,'2', AD.AD_ACTUALRATE, S.COUPON) * 100
                  END, 4)                                              AS NHLL, --年化利率
           REPLACE(TRIM(C.REAL_SET_DATE),'-','')                       AS CHG_DATE, --交易日期
           REPLACE(CASE WHEN S.P_TYPE IN ('0000','1100','1200') THEN TRIM(S.START_DATE)
                        WHEN S.P_TYPE IN ('0703','0706') THEN TRIM(TF.F_DATE)
                        WHEN S.P_TYPE IN ('0700') THEN NVL(TRIM(C.REAL_SET_DATE),'9999-12-31')
                        ELSE TRIM(S.START_DATE)
                     END,'-','')                                       AS HTYDRQ, --合同起始日期
           REPLACE(CASE WHEN S.P_TYPE IN ('0000','1100','1200') THEN TRIM(S.MTR_DATE)
                        WHEN S.P_TYPE IN ('0703','0706') THEN '9999-12-31'
                        WHEN S.P_TYPE IN ('0700') AND TEQ.OPEN_TYPE = '2' THEN TRIM(TEQ.CLOSING_END_DATE)
                        ELSE TRIM(S.MTR_DATE)
                    END,'-','')                                        AS HTDQRQ, --合同到期日期
           COALESCE(TRIM(CE.EXHACC),'800001011003020003')              AS BFQSZH, --本方清算账号
           NULL                                                        AS JYDSLB, --交易对手类别
           CASE WHEN C.TRD_TYPE IN ('0000201','0000301') THEN ISI.I_FULLNAME
                ELSE PIN.I_FULLNAME
            END                                                        AS JYDSMC, --交易对手名称
           CASE WHEN C.TRD_TYPE IN ('0000201','0000301') THEN ISI.CORE_SYS_CUSTOMER_CODE
                ELSE PIN.CORE_SYS_CUSTOMER_CODE
            END                                                        AS JYDSHXKHH, --交易对手核心客户号
           NULL                                                        AS JYDSPJ, --交易对手评级
           NULL                                                        AS JYDSPJJG, --交易对手评级机构
           COALESCE(TRIM(VSIC.PARTY_ACCT_CODE), TRIM(T.PARTY_ACCT_CODE)) AS JYDSZH, --交易对手账号
           COALESCE(TRIM(VSIC.PARTY_BANK_CODE), TRIM(T.PARTY_BANK_CODE)) AS JYDSKHHH, --交易对手开户行号
           COALESCE(TRIM(VSIC.PARTY_BANK_NAME), TRIM(T.PARTY_BANK_NAME)) AS JYDSKHHM, --交易对手开户行名
           CASE WHEN S.P_TYPE IN ('0000','1100','1200','2000') THEN '否' --MOD BY LIP 20250715 增加 2000 的映射
                WHEN S.P_TYPE IN ('0703','0706') THEN '是'
                WHEN S.P_TYPE IN ('0700','0170') THEN DECODE(ME.MANAGEMENT_MODE,'0','否','1','是')
            END                                                        AS WTGLBZ, --委托管理标志
           COALESCE(TRIM(AU.EMPLOYEE_CARD_NO), TRIM(AUM.EMPLOYEE_CARD_NO)) AS SPRGH, --审批人工号
           OU.EMPLOYEE_CARD_NO                                         AS JYYGH, --经办人工号
           NULL                                                        AS BZH, --备注
           REPLACE(P.ENDDATE,'-','')                                   AS CJRQ, --采集日期
           '同业系统'                                                  AS DATA_SRC_DESC,--数据来源中文
           DECODE(AC.I9_CLASS,1,'AC',2,'FVOCI',4,'FVTPL')              AS ZCSFL --资产三分类代码 --ADD BY LIP 20250410
      FROM CHG_MAIN C
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_OTC_TRADE T
        ON T.INTORDID = C.TRADE_ID
      LEFT JOIN PARAMS P
        ON 1 = 1
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_ACC_SECU ACC
        ON ACC.ACCID = C.SECU_ACCT_ID
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_INSTITUTION INST
        ON INST.I_ID = ACC.I_ID
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_INSTITUTION PIN
        ON PIN.I_ID = T.PARTYID
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_AUTH_USER AU
        ON TO_CHAR(AU.USER_ID) = C.ACCOUNT_USER
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_AUTH_USER OU
        ON OU.USER_ID = C.OPERATOR_ID
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_AUTH_USER AUM
        ON AUM.USER_NAME = C.ACCOUNT_USER
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_INSTRUMENT S
        ON S.I_CODE = C.I_CODE
       AND S.A_TYPE = C.A_TYPE
       AND S.M_TYPE = C.M_TYPE
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TBND TB
        ON TB.I_CODE = C.I_CODE
       AND TB.A_TYPE = C.A_TYPE
       AND TB.M_TYPE = C.M_TYPE
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_INSTITUTION ISI
        ON ISI.I_ID = TB.ISSUER_ID
      LEFT JOIN RRP_MDL.O_IOL_IBMS_VTRD_INSTRUMENT_FUND_MAPPING VM
        ON VM.I_CODE = C.I_CODE
       AND VM.A_TYPE = C.A_TYPE
       AND VM.M_TYPE = C.M_TYPE
      --LEFT JOIN SM_TYPE ST
      LEFT JOIN RRP_EAST.ADD_EAST5_ZYZJYW_YWXL_MAPPING ST --自营资金同业业务种类映射 MOD BY LIP 20241126 维护成参数表
        ON ST.PROD_CODE = VM.PROD_CODE
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_EQUITY TEQ
        ON TEQ.I_CODE = C.I_CODE
       AND TEQ.A_TYPE = C.A_TYPE
       AND TEQ.M_TYPE = C.M_TYPE
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TFND TF
        ON TF.I_CODE = C.I_CODE
       AND TF.A_TYPE = C.A_TYPE
       AND TF.M_TYPE = C.M_TYPE
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_ACCTG_ACCOUNT_TYPE AC
        ON AC.TYPEID = ACC.ACTING_TYPE
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TBSI_ACCRUALDETAIL AD
        ON AD.I_CODE = C.I_CODE
       AND AD.A_TYPE = C.A_TYPE
       AND AD.M_TYPE = C.M_TYPE
       AND AD.AD_STARTDATE <= C.CHG_DATE
       AND AD.AD_ENDDATE > C.CHG_DATE
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_CASHLB_MANAGE_ELE ME
        ON ME.I_CODE = C.I_CODE
       AND ME.A_TYPE = C.A_TYPE
       AND ME.M_TYPE = C.M_TYPE
       AND ME.START_DT <= TO_DATE(V_MONTH_END_DATEID,'YYYYMMDD') --MODIFY BY TANGAN AT 20221224
       AND ME.END_DT > TO_DATE(V_MONTH_END_DATEID,'YYYYMMDD') --MODIFY BY TANGAN AT 20221224
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_ACC_CASH_EXT CE
        ON CE.ACCID = T.CASH_EXT_ACCID
      LEFT JOIN (SELECT DISTINCT TRADE_ID, SUBJ_CODE, CORE_ACCT_NAME
                   FROM SUBJ_VIEW) SV
        ON SV.TRADE_ID = C.TRADE_ID
       AND C.INST_TYPE > -100
       AND C.INST_TYPE <> 2
       AND C.TRD_TYPE NOT IN ('0150300_L','0150301_L')
      LEFT JOIN (SELECT DISTINCT INST_ID,SUBJ_CODE,CORE_ACCT_NAME FROM SUBJ_VIEW) MSV
        ON MSV.INST_ID = C.INST_ID
       AND (C.INST_TYPE = 2 OR C.INST_TYPE <= -100 OR C.TRD_TYPE IN ('0150300_L','0150301_L'))
      LEFT JOIN RRP_MDL.O_IOL_IBMS_VTRD_SET_INSTRUCTION_CASH VSIC
        ON VSIC.CASH_INST_ID = C.REF_CASH_INST_ID
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_OTC_TRADE NT
        ON NT.INTORDID = C.CD_TRADE_ID
      --LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_NCD_RESULT_DETAILS NRD
      LEFT JOIN RRP_MDL.O_IOL_IBMS_VTRD_NCD_RESULT_DETAILS NRD --MOD BY LIP 20240429 根据同业反馈，调整取数表
        ON NRD.SYSORDID = NT.REF_SYSORDID
       AND NRD.REF_SYSORDID = NT.SYSORDID
       AND NRD.I_CODE = C.I_CODE
       AND NRD.A_TYPE = C.A_TYPE
       AND NRD.M_TYPE = C.M_TYPE
      LEFT JOIN ZHLXVIEW ZV
        ON ZV.I_CODE = C.I_CODE
       AND ZV.A_TYPE = C.A_TYPE
       AND ZV.M_TYPE = C.M_TYPE
       AND ZV.SECU_ACCID = C.SECU_ACCT_ID
       AND ZV.TRADE_GRP_ID = C.TRADE_GRP_ID
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_OTC_NCD NCD
        ON NCD.I_CODE = NRD.I_CODE
       AND NCD.A_TYPE = NRD.A_TYPE
       AND NCD.M_TYPE = NRD.M_TYPE
     WHERE (S.P_TYPE IN ('0000','1100','1200','0201','0202','0158','0150','0700','0703','0706','0170','0125','0121','0179') --ADD BY LIP 20240219 增加'0179'银团同业借款数据
           OR T.TRDTYPE IN ('2000100','2000101')); --2000100债券借入,2000101 债券借出

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --更新自营资金资金部分的交易对手客户号 --MOD BY LIP 20250417
    V_STEP      := V_STEP + 1;
    V_STEP_DESC := '更新自营资金资金部分的交易对手客户号';
    V_STARTTIME := SYSDATE;
    MERGE INTO (SELECT * FROM RRP_EAST.EAST5_1003_ZYZJJYXXB_ZJ WHERE TRIM(JYDSMC) IS NOT NULL AND TRIM(ECIF_CODE) IS NULL) TA
    USING (SELECT CUST_ID,CUST_NAME,ROW_NUMBER() OVER(PARTITION BY CUST_NAME ORDER BY OPEN_ACCT_DT DESC) RN
             FROM RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO
            WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) TB
       ON (TB.CUST_NAME = TRIM(TA.JYDSMC) AND TB.RN = 1)
     WHEN MATCHED THEN UPDATE SET
       TA.ECIF_CODE = TB.CUST_ID;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --自营资金交易信息表_资金
    V_STEP      := V_STEP + 1;
    V_STEP_DESC := '自营资金交易信息表_资金';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_1003_ZYZJJYXXB_ZJ_R
      (RID --数据主键
      ,NBJGH --内部机构号
      ,JRXKZH --金融许可证号
      ,YHJGMC --银行机构名称
      ,MXKMBH --明细科目编号
      ,MXKMMC --明细科目名称
      ,JYZHLX --账户类型
      ,JYBH --交易编号
      ,JRGJBH --金融工具编号
      ,JRGJMC --金融工具名称
      ,YEDL --业务大类
      ,YWZL --业务中类
      ,YWXL --业务小类
      ,CPMC --产品名称
      ,JYFX --交易方向
      ,MYBJBZ --合约币种
      ,MYBJJE --合约金额
      ,NHLL --年化利率
      ,JYRQ --交易日期
      ,HTYDRQ --合同起始日期
      ,HTDQRQ --合同到期日期
      ,BFQSZH --本方清算账号
      ,JYDSLB --交易对手类别
      ,JYDSMC --交易对手名称
      ,JYDSPJ --交易对手评级
      ,JYDSPJJG --交易对手评级机构
      ,JYDSZH --交易对手账号
      ,JYDSKHHH --交易对手开户行号
      ,JYDSKHHM --交易对手开户行名
      ,WTGLBZ --委托管理标志
      ,SPRGH --审批人工号
      ,JYYGH --经办人工号
      ,BBZ --备注
      ,CJRQ --采集日期
      ,DEPT_NO --部门编号
      ,SRC_SYS_ID --来源系统ID
      ,ISSUED_NO --填报机构
      ,ORG_NO --报送机构
      ,ADDRESS --归属地
      ,JYDSMC_ORIG --交易对手名称脱敏（前）
      ,GSFZJG --归属分支机构
      ,DATA_SRC_DESC --数据来源中文
      ,ZCSFL --资产三分类代码 --ADD BY LIP 20250415
      )
    WITH CLEAK_INFO AS (
    SELECT CLERK_ID,CLERK_NAME,
           ROW_NUMBER() OVER(PARTITION BY CLERK_NAME ORDER BY EMPYT_DT DESC,EMPLY_STATUS_CD) RN --CD1596
      FROM RRP_MDL.O_ICL_CMM_CLERK_INFO
     WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
    SELECT SYS_GUID()                                                AS RID,
           NVL(TRIM(B0.ORG_ID1),'896')                               AS NBJGH,
           B.FIN_PERMIT_NO                                           AS JRXKZH,
           B.ORG_NM                                                  AS YHJGMC,
           SUBSTR(A.MXKMBH,1,8)                                      AS MXKMBH,
           NVL(TRIM(C.SUBJ_NM),C1.SUBJ_NM)                           AS MXKMMC,
           A.JYZHLX                                                  AS JYZHLX,
           A.JYBH                                                    AS JYBH,
           A.JRGJBH                                                  AS JRGJBH,
           A.JRGJMC                                                  AS JRGJMC,
           A.YEDL                                                    AS YEDL,
           A.YWZL                                                    AS YWZL,
           A.YWXL                                                    AS YWXL,
           A.CPMC                                                    AS CPMC,
           A.JYFX                                                    AS JYFX,
           A.MYBJBZ                                                  AS MYBJBZ,
           A.MYBJJE                                                  AS MYBJJE,
           A.NHLL                                                    AS NHLL,
           TRIM(A.JYRQ)                                              AS JYRQ,
           TRIM(A.HTYDRQ)                                            AS HTYDRQ,
           TRIM(A.HTDQRQ)                                            AS HTDQRQ,
           A.BFQSZH                                                  AS BFQSZH,
           CASE WHEN NVL(TRIM(E.TAR_VALUE_CODE),H.TAR_VALUE_CODE) IS NOT NULL
                THEN NVL(TRIM(E.TAR_VALUE_NAME),H.TAR_VALUE_NAME) --MOD BY LIP 20250324 根据业务提供的映射口径调整
                /*WHEN (CASE WHEN (NVL(TRIM(D.RG_CD),F.RG_CD) IN ('810000','820000','710000') OR
                                 NVL(NVL(TRIM(D.INVTOR_CTY_CD),TRIM(F.INVTOR_CTY_CD)),'1111') NOT IN ('CHN','XXX','1111'))
                           THEN 'Y'
                           ELSE 'N'
                       END) = 'Y' AND NVL(TRIM(E.TAR_VALUE_CODE),H.TAR_VALUE_CODE) IS NOT NULL
                THEN '境外金融机构'
                WHEN SUBSTR(NVL(TRIM(E.TAR_VALUE_CODE),H.SRC_VALUE_CODE),1,1) IN ('C','D')
                THEN '银行业金融机构'*/
                WHEN (NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) LIKE '%银行%' OR
                      NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) LIKE '%农村信用合作%' OR
                      NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) LIKE '%农商%' OR
                      NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) LIKE '%农联社%' OR
                      NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) LIKE '%农村信用联社%') AND
                      NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) NOT LIKE '%理财%' AND
                      NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) NOT LIKE '%信托%' AND
                      NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) NOT LIKE '%基金%' AND
                      NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) NOT LIKE '%系列%' AND
                      NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) NOT LIKE '%资管%' AND
                      NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) NOT LIKE '%计划%' AND
                      NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) NOT LIKE '%号%'
                THEN '银行业金融机构'
                WHEN NVL(TRIM(E.TAR_VALUE_CODE),H.TAR_VALUE_CODE) IS NOT NULL OR
                     NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) LIKE '%理财%' OR
                     NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) LIKE '%信托%' OR
                     NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) LIKE '%基金%' OR
                     NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) LIKE '%系列%' OR
                     NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) LIKE '%资管%' OR
                     NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) LIKE '%计划%' OR
                     NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) LIKE '%号%' OR
                     NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) LIKE '%证券%'  --MOD BY LIP 20240923
                THEN '非银行业金融机构'
                WHEN NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) LIKE '%保险%' OR
                     NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) LIKE '%人寿%'
                THEN '非银行业金融机构'
                WHEN NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) LIKE '%政府%' OR
                     NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) LIKE '%财政%'
                THEN '政府机关'
                WHEN NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) IS NOT NULL
                THEN '公司客户'
                ELSE NULL
            END                                                      AS JYDSLB,
           NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC)    AS JYDSMC,
           A.JYDSPJ                                                  AS JYDSPJ,
           A.JYDSPJJG                                                AS JYDSPJJG,
           A.JYDSZH                                                  AS JYDSZH,
           A.JYDSKHHH                                                AS JYDSKHHH,
           A.JYDSKHHM                                                AS JYDSKHHM,
           A.WTGLBZ                                                  AS WTGLBZ,
           CASE WHEN A.JYRQ < '20190308' THEN '01100171'
                WHEN A.JYRQ >= '20190308' AND A.JYRQ < '20200803' THEN '00110904'
                WHEN A.JYRQ >= '20200803' AND A.JYRQ < '20210720' THEN '00200831'
                WHEN A.JYRQ >= '20210720' AND A.JYRQ < '20210801' THEN '00140767'
                WHEN A.JYRQ >= '20210801' THEN '00200802'
            END                                                      AS SPRGH,
           CASE WHEN A.YWZL = '债券投资' AND A.MYBJBZ = 'USD' THEN '00070911'
                WHEN T13.CLERK_ID IS NOT NULL THEN T13.CLERK_ID --MOD BY LIP 20241114
                WHEN A.JYYGH LIKE '%jy1@hxbank%' THEN '00070911'
                WHEN A.JYYGH LIKE '%pzx.dealer@gdhx%' OR A.JYYGH LIKE '%潘志煊%' THEN '00070679'
                WHEN A.JYYGH LIKE '%qww0001@gdhx%' OR A.JYYGH LIKE '%祁文伟%' THEN '00070783'
                WHEN A.JYYGH LIKE '%yy.song@gdhx%' OR A.JYYGH LIKE '%宋颖颖%' THEN '00070973'
                WHEN A.JYYGH LIKE '%zsd.dealer@gdhx%' OR A.JYYGH LIKE '%卓穗东%' THEN '00070544'
                WHEN A.JYYGH LIKE '%s.huang@gdhx%' OR A.JYYGH LIKE '%黄山%' THEN '00070976'
                WHEN A.JYYGH LIKE '%lmx@gdhx%' OR A.JYYGH LIKE '%林明鑫%' THEN '00070911'
                WHEN A.JYYGH LIKE '%lsy0001%' OR A.JYYGH LIKE '%陆赛一%' THEN '00070078'
                WHEN A.JYYGH LIKE '%slh0001%' OR A.JYYGH LIKE '%石丽华%' THEN '00070258'
                WHEN A.JYYGH LIKE '%155181%' OR A.JYYGH LIKE '%潘志煊%' THEN  '00070679'
                WHEN A.JYYGH LIKE '%dyt0001%' OR A.JYYGH LIKE '%董运图%' THEN  '00070723'
                WHEN A.JYYGH LIKE '%mls0002%' OR A.JYYGH LIKE '%孟令姝%' THEN  '00070778'
                WHEN A.JYYGH LIKE '%zsd0001%' OR A.JYYGH LIKE '%卓穗东%' THEN  '00070544'
                WHEN A.JYYGH LIKE '%pengwei0001%' OR A.JYYGH LIKE '%彭薇%' THEN  '00070079'
                WHEN A.JYYGH LIKE '%panlong0001%' OR A.JYYGH LIKE '%盘龙%' THEN  '00070779'
                WHEN A.JYYGH LIKE '%qww0001%' OR A.JYYGH LIKE '%祁文伟%' THEN  '00070783'
                WHEN A.JYYGH LIKE '%chengongyin123%' OR A.JYYGH LIKE '%陈功垠%' THEN  '00070780'
                WHEN A.JYYGH LIKE '%yyp001%' OR A.JYYGH LIKE '%叶奕鹏%' THEN  '00070805'
                WHEN A.JYYGH LIKE '%hjx0001%' OR A.JYYGH LIKE '%黄俊兴%' THEN  '00070806'
                WHEN A.JYYGH LIKE '%mj0001%' OR A.JYYGH LIKE '%马娟%' THEN  '00240743'
                WHEN A.JYYGH LIKE '%jinying1989%' OR A.JYYGH LIKE '%金瑛%' THEN  '00260849'
                WHEN A.JYYGH LIKE '%hct0001%' OR A.JYYGH LIKE '%王成涛%' THEN  '00261008'
                WHEN A.JYYGH LIKE '%wenyu%' OR A.JYYGH LIKE '%黄文瑜%' THEN  '00070792'
                WHEN A.JYYGH LIKE '%余云雨%' THEN  '00070786'
                WHEN A.JYYGH LIKE '%HUangshan001%' OR A.JYYGH LIKE '%黄山%' THEN '00070976'
                WHEN A.JYYGH LIKE '%李丽娜%' THEN '00030186' --ADD BY LIP 20230714
                WHEN A.JYYGH LIKE '%王蓉%' THEN '00070889' --ADD BY LIP 20240118
                ELSE A.JYYGH
            END                                                      AS JYYGH,
           A.BBZ                                                     AS BBZ,
           TO_CHAR(LAST_DAY(TO_DATE(A.JYRQ,'YYYYMMDD')),'YYYYMMDD')  AS CJRQ,
           '000'                                                     AS DEPT_NO,
           '01'                                                      AS SRC_SYS_ID,
           A.NBJGH                                                   AS ISSUED_NO,
           '000000'                                                  AS ORG_NO,
           ''                                                        AS ADDRESS,
           --A.JYDSMC                                                  AS JYDSMC_ORIG,
           NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC)    AS JYDSMC_ORIG,
           B.GSFZJG                                                  AS GSFZJG,
           A.DATA_SRC_DESC                                           AS DATA_SRC_DESC, --数据来源中文
           A.ZCSFL                                                   AS ZCSFL --资产三分类代码 --ADD BY LIP 20250415
      FROM RRP_EAST.EAST5_1003_ZYZJJYXXB_ZJ A
      LEFT JOIN RRP_MDL.ORG_CONFIG B0 --机构映射表
        ON B0.ORG_ID = A.NBJGH
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(TRIM(B0.ORG_ID1),'896')
       AND B.DATA_DT = V_MONTH_END_DATEID
      LEFT JOIN RRP_MDL.M_GL_INFO C --总账会计科目信息表
        ON C.SUBJ_ID = SUBSTR(A.MXKMBH,1,8) --科目报送到三级
       AND C.DATA_DT = TO_CHAR(LAST_DAY(TO_DATE(A.JYRQ,'YYYYMMDD')),'YYYYMMDD')
      LEFT JOIN RRP_MDL.M_GL_INFO C1 --总账会计科目信息表
        ON C1.SUBJ_ID = SUBSTR(A.MXKMBH,1,8) --科目报送到三级
       AND C1.DATA_DT = V_MONTH_END_DATEID
      LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO D --对公客户基本信息
        ON D.CUST_ID = TRIM(A.ECIF_CODE)
       AND D.ETL_DT = V_DATE
      LEFT JOIN RRP_MDL.CODE_MAP E --MOD BY LIP 20250324 根据业务提供的映射调整
        ON E.SRC_VALUE_CODE = D.NATNAL_ECON_DEPT_TYPE_CD
       AND E.SRC_CLASS_CODE = 'CD1418' --国民经济部门类型代码
       AND E.TAR_CLASS_CODE = 'C0060' --交易对手类别
       AND E.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.O_IML_PTY_SPV_CUST_INFO G --SPV客户信息
        ON G.SPV_CUST_ID = TRIM(A.ECIF_CODE)
       AND G.START_DT <= V_DATE
       --AND G.END_DT >= V_DATE
       AND G.END_DT > V_DATE
      LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO F --对公客户基本信息
        ON F.CUST_ID = TRIM(G.PARTY_ID)
       AND F.ETL_DT = V_DATE
      LEFT JOIN RRP_MDL.CODE_MAP H --MOD BY LIP 20250324 根据业务提供的映射调整
        ON H.SRC_VALUE_CODE = F.NATNAL_ECON_DEPT_TYPE_CD
       AND H.SRC_CLASS_CODE = 'CD1418' --国民经济部门类型代码
       AND H.TAR_CLASS_CODE = 'C0060' --交易对手类别
       AND H.MOD_FLG = 'EAST'
      LEFT JOIN CLEAK_INFO T13
        ON T13.CLERK_NAME = NVL(SUBSTR(A.JYYGH,1,INSTR(A.JYYGH,'(') -1),A.JYYGH)
       AND T13.RN = 1
    WHERE A.CJRQ = V_MONTH_END_DATEID;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --更新自营资金同业部分的交易对手客户号 --MOD BY LIP 20250417
    V_STEP      := V_STEP + 1;
    V_STEP_DESC := '更新自营资金同业部分的交易对手客户号';
    V_STARTTIME := SYSDATE;
    MERGE INTO (SELECT * FROM RRP_EAST.EAST5_1003_ZYZJJYXXB_TY WHERE TRIM(JYDSMC) IS NOT NULL AND TRIM(JYDSHXKHH) IS NULL) TA
    USING (SELECT CUST_ID,CUST_NAME,ROW_NUMBER() OVER(PARTITION BY CUST_NAME ORDER BY OPEN_ACCT_DT DESC) RN
             FROM RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO
            WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) TB
       ON (TB.CUST_NAME = TRIM(TA.JYDSMC) AND TB.RN = 1)
     WHEN MATCHED THEN UPDATE SET
       TA.JYDSHXKHH = TB.CUST_ID;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP      := V_STEP + 1;
    V_STEP_DESC := '自营资金交易信息表_同业存单发行卖出交易对手';
    V_STARTTIME := SYSDATE;
    --自营资金交易信息表_同业存单发行卖出交易对手
    EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_EAST.EAST5_1003_ZYZJJYXXB_TY_DFXX';
    INSERT INTO RRP_EAST.EAST5_1003_ZYZJJYXXB_TY_DFXX
      (JYBH        --交易编号
      ,JYDSMC      --交易对手名称
      ,RANK_RN     --排序
      ,ZS          --总数
      ,JYRQ        --交易日期
      ,TRAN_AMT    --交易金额
      ,JYDSZH      --交易对手账号
      ,JYDSKHHH    --交易对手开户行号
      ,JYDSKHHM    --交易对手开户行名
      ,RANK_RNN    --排序
      )
    SELECT TA.JYBH                                    AS JYBH,             --交易编号
           TA.JYDSMC                                  AS JYDSMC,           --交易对手名称
           CASE WHEN T.PAYER_NAME = TA.JYDSMC THEN '1'
                WHEN T.PAYER_OPEN_BANK_NAME = TA.JYDSMC THEN '2'
                WHEN SUBSTR(T.PAYER_NAME,1,10) = SUBSTR(TA.JYDSMC,1,10) THEN '3'
                WHEN SUBSTR(T.PAYER_OPEN_BANK_NAME,1,10) = SUBSTR(TA.JYDSMC,1,10) THEN '4'
                WHEN SUBSTR(T.PAYER_NAME,1,4) = SUBSTR(TA.JYDSMC,1,4) THEN '5'
            END                                       AS RANK_RN,          --排序
            COUNT(TA.JYBH) OVER(PARTITION BY TA.JYBH) AS ZS,               --总数
            T.TRAN_DT                                 AS JYRQ,             --交易日期
            T.TRAN_AMT                                AS TRAN_AMT,         --交易金额
            T.PAYER_ACCT_NUM                          AS JYDSZH,           --交易对手账号
            T.PAYER_OPEN_BANK_NO                      AS JYDSKHHH,         --交易对手开户行号
            T.PAYER_OPEN_BANK_NAME                    AS JYDSKHHM,         --交易对手开户行名
            ROW_NUMBER() OVER(PARTITION BY TA.JYBH ORDER BY
            CASE WHEN T.PAYER_NAME = TA.JYDSMC THEN '1'
                 WHEN T.PAYER_OPEN_BANK_NAME = TA.JYDSMC THEN '2'
                 WHEN SUBSTR(T.PAYER_NAME,1,10) = SUBSTR(TA.JYDSMC,1,10) THEN '3'
                 WHEN SUBSTR(T.PAYER_OPEN_BANK_NAME,1,10) = SUBSTR(TA.JYDSMC,1,10) THEN '4'
                 WHEN SUBSTR(T.PAYER_NAME,1,4) = SUBSTR(TA.JYDSMC,1,4) THEN '5'
            END)                                     AS RANK_RNN    --排序
       FROM RRP_MDL.O_ICL_CMM_PBC_PASS_TRAN_FLOW T
      INNER JOIN RRP_EAST.EAST5_1003_ZYZJJYXXB_TY TA
         ON TO_DATE(TA.JYRQ,'YYYYMMDD') = T.TRAN_DT
        AND TA.MYBJJE = T.TRAN_AMT
        AND TA.YWXL = '同业存单发行'
        AND TA.JYFX = '卖出'
        AND TA.CJRQ = V_MONTH_END_DATEID
      WHERE T.ERR_INFO = 'SUCCESS'
        AND T.ETL_DT >= TRUNC(TO_DATE(V_MONTH_END_DATEID,'YYYYMMDD'),'MM')
        AND T.ETL_DT <= TO_DATE(V_MONTH_END_DATEID,'YYYYMMDD');

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP      := V_STEP + 1;
    V_STEP_DESC := '自营资金交易信息表_同业';
    V_STARTTIME := SYSDATE;
    --自营资金交易信息表_同业
    INSERT INTO RRP_EAST.EAST5_1003_ZYZJJYXXB_TY_R
      (RID --数据主键
      ,NBJGH --内部机构号
      ,JRXKZH --金融许可证号
      ,YHJGMC --银行机构名称
      ,MXKMBH --明细科目编号
      ,MXKMMC --明细科目名称
      ,JYZHLX --账户类型
      ,JYBH --交易编号
      ,JRGJBH --金融工具编号
      ,JRGJMC --金融工具名称
      ,YEDL --业务大类
      ,YWZL --业务中类
      ,YWXL --业务小类
      ,CPMC --产品名称
      ,JYFX --交易方向
      ,MYBJBZ --合约币种
      ,MYBJJE --合约金额
      ,NHLL --年化利率
      ,JYRQ --交易日期
      ,HTYDRQ --合同起始日期
      ,HTDQRQ --合同到期日期
      ,BFQSZH --本方清算账号
      ,JYDSLB --交易对手类别
      ,JYDSMC --交易对手名称
      ,JYDSPJ --交易对手评级
      ,JYDSPJJG --交易对手评级机构
      ,JYDSZH --交易对手账号
      ,JYDSKHHH --交易对手开户行号
      ,JYDSKHHM --交易对手开户行名
      ,WTGLBZ --委托管理标志
      ,SPRGH --审批人工号
      ,JYYGH --经办人工号
      ,BBZ --备注
      ,CJRQ --采集日期
      ,DEPT_NO --部门编号
      ,SRC_SYS_ID --来源系统ID
      ,ISSUED_NO --填报机构
      ,ORG_NO --报送机构
      ,ADDRESS --归属地
      ,JYDSMC_ORIG --交易对手名称脱敏（前）
      ,GSFZJG --归属分支机构
      ,DATA_SRC_DESC --数据来源中文
      ,ZCSFL --资产三分类代码 --ADD BY LIP 20250415
      )
    SELECT SYS_GUID()                                                AS RID --数据主键
          ,NVL(TRIM(B1.ORG_ID1),'896')                               AS NBJGH --内部机构号
          ,B.FIN_PERMIT_NO                                           AS JRXKZH --金融许可证号
          ,B.ORG_NM                                                  AS YHJGMC --银行机构名称
          ,SUBSTR(A.MXKMBH,1,8)                                      AS MXKMBH --明细科目编号
          ,NVL(TRIM(C.SUBJ_NM),C1.SUBJ_NM)                           AS MXKMMC --明细科目名称
          ,NVL(TRIM(A.JYZHLX),'银行账户')                            AS JYZHLX --账户类型
          ,A.JYBH                                                    AS JYBH --交易编号
          ,A.JRGJBH                                                  AS JRGJBH --金融工具编号
          ,A.JRGJMC                                                  AS JRGJMC --金融工具名称
          ,A.YEDL                                                    AS YEDL --业务大类
          ,A.YWZL                                                    AS YWZL --业务中类
          ,A.YWXL                                                    AS YWXL --业务小类
          ,A.CPMC                                                    AS CPMC --产品名称
          ,A.JYFX                                                    AS JYFX --交易方向
          ,A.MYBJBZ                                                  AS MYBJBZ --合约币种
          ,A.MYBJJE                                                  AS MYBJJE --合约金额
          ,A.NHLL                                                    AS NHLL --年化利率
          ,TRIM(A.JYRQ)                                              AS JYRQ --交易日期
          --,TRIM(A.HTYDRQ)                                            AS HTYDRQ --合同起始日期
          ,NVL(TRIM(A.HTYDRQ),'99991231')                            AS HTYDRQ --合同起始日期
          ,TRIM(A.HTDQRQ)                                            AS HTDQRQ --合同到期日期
          ,A.BFQSZH                                                  AS BFQSZH --本方清算账号
          ,CASE WHEN NVL(TRIM(E.TAR_VALUE_CODE),H.TAR_VALUE_CODE) IS NOT NULL
                THEN NVL(TRIM(E.TAR_VALUE_NAME),H.TAR_VALUE_NAME) --MOD BY LIP 20250324 根据业务提供的映射口径调整
                /*WHEN (CASE WHEN (NVL(TRIM(D.RG_CD),F.RG_CD) IN ('810000','820000','710000') OR
                                 NVL(NVL(TRIM(D.INVTOR_CTY_CD),TRIM(F.INVTOR_CTY_CD)),'1111') NOT IN ('CHN','XXX','1111'))
                           THEN 'Y'
                           ELSE 'N'
                       END) = 'Y' AND NVL(TRIM(E.TAR_VALUE_CODE),H.TAR_VALUE_CODE) IS NOT NULL
                THEN '境外金融机构'
                WHEN SUBSTR(NVL(TRIM(E.TAR_VALUE_CODE),H.TAR_VALUE_CODE),1,1) IN ('C','D')
                THEN '银行业金融机构'*/
                WHEN (NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) LIKE '%银行%' OR
                      NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) LIKE '%农村信用合作%' OR
                      NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) LIKE '%农商%' OR
                      NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) LIKE '%农联社%' OR
                      NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) LIKE '%农村信用联社%') AND
                      NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) NOT LIKE '%理财%' AND
                      NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) NOT LIKE '%信托%' AND
                      NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) NOT LIKE '%基金%' AND
                      NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) NOT LIKE '%系列%' AND
                      NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) NOT LIKE '%资管%' AND
                      NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) NOT LIKE '%计划%' AND
                      NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) NOT LIKE '%号%'
                THEN '银行业金融机构'
                WHEN NVL(TRIM(E.TAR_VALUE_CODE),H.TAR_VALUE_CODE) IS NOT NULL OR
                     NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) LIKE '%理财%' OR
                     NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) LIKE '%信托%' OR
                     NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) LIKE '%基金%' OR
                     NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) LIKE '%系列%' OR
                     NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) LIKE '%资管%' OR
                     NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) LIKE '%计划%' OR
                     NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) LIKE '%号%' OR
                     NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) LIKE '%证券%'  --MOD BY LIP 20240923
                THEN '非银行业金融机构'
                WHEN NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) LIKE '%保险%' OR
                     NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) LIKE '%人寿%'
                THEN '非银行业金融机构'
                WHEN NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) LIKE '%政府%' OR
                     NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) LIKE '%财政%'
                THEN '政府机关'
                WHEN NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC) IS NOT NULL
                THEN '公司客户'
                --MOD BY LIP 20230920 同业存单买入的交易对手按照该默认规则进行逻辑
                WHEN A.YWXL = '同业存单发行' AND A.JYFX = '买入' THEN '非银行业金融机构'
                ELSE NULL
            END                                                      AS JYDSLB
          --,NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC)    AS JYDSMC
          --MOD BY LIP 20230920 同业存单买入的交易对手按照该默认规则进行逻辑
          ,CASE WHEN NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),TRIM(A.JYDSMC)) IS NOT NULL
                THEN NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),TRIM(A.JYDSMC))
                WHEN A.YWXL = '同业存单发行' AND A.JYFX = '买入'
                THEN '应收固定收益产品付息兑付资金户'
            END                                                      AS JYDSMC --交易对手名称
          ,A.JYDSPJ                                                  AS JYDSPJ --交易对手评级
          ,A.JYDSPJJG                                                AS JYDSPJJG --交易对手评级机构
          /*,A.JYDSZH                                                  AS JYDSZH --交易对手账号
          ,A.JYDSKHHH                                                AS JYDSKHHH --交易对手开户行号
          ,A.JYDSKHHM                                                AS JYDSKHHM --交易对手开户行名*/
          --MOD BY LIP 20230920 同业存单买入的交易对手按照该默认规则进行逻辑
          ,CASE WHEN A.YWXL = '同业存单发行' AND A.JYFX = '买入' THEN '1023130000054'
                WHEN A.YWXL = '同业存单发行' AND A.JYFX = '卖出' AND DFZH.JYBH IS NOT NULL THEN DFZH.JYDSZH
                WHEN TRIM(A.JYDSZH) IS NOT NULL THEN A.JYDSZH
            END                                                      AS JYDSZH --交易对手账号
          ,CASE WHEN A.YWXL = '同业存单发行' AND A.JYFX = '买入' THEN '909290000007'
                WHEN A.YWXL = '同业存单发行' AND A.JYFX = '卖出' AND DFZH.JYBH IS NOT NULL THEN DFZH.JYDSKHHH
                WHEN TRIM(A.JYDSKHHH) IS NOT NULL THEN A.JYDSKHHH
            END                                                      AS JYDSKHHH --交易对手开户行号
          ,CASE WHEN A.YWXL = '同业存单发行' AND A.JYFX = '买入' THEN '银行间市场清算所'
                WHEN A.YWXL = '同业存单发行' AND A.JYFX = '卖出' AND DFZH.JYBH IS NOT NULL THEN DFZH.JYDSKHHM
                WHEN TRIM(A.JYDSKHHM) IS NOT NULL THEN A.JYDSKHHM
            END                                                      AS JYDSKHHM --交易对手开户行名
          ,NVL(TRIM(A.WTGLBZ),'否')                                  AS WTGLBZ --委托管理标志
          ,A.SPRGH                                                   AS SPRGH --审批人工号
          ,A.JYYGH                                                   AS JYYGH --经办人工号
          ,A.BBZ                                                     AS BBZ --备注
          ,V_MONTH_END_DATEID                                        AS CJRQ --采集日期
          ,'000'                                                     AS DEPT_NO --部门编号
          ,'01'                                                      AS SRC_SYS_ID --来源系统ID
          ,A.NBJGH                                                   AS ISSUED_NO --填报机构
          ,'000000'                                                  AS ORG_NO --报送机构
          ,''                                                        AS ADDRESS --归属地
          --,NVL(TRIM(A.JYDSMC), D.CUST_NAME)                          AS JYDSMC_ORIG --交易对手名称脱敏（前）
          --,NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),A.JYDSMC)    AS JYDSMC_ORIG --交易对手名称脱敏（前）
          --MOD BY LIP 20230920 同业存单买入的交易对手按照该默认规则进行逻辑
          ,CASE WHEN NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),TRIM(A.JYDSMC)) IS NOT NULL
                THEN NVL(NVL(TRIM(D.CUST_NAME),TRIM(F.CUST_NAME)),TRIM(A.JYDSMC))
                WHEN A.YWXL = '同业存单发行' AND A.JYFX = '买入'
                THEN '应收固定收益产品付息兑付资金户'
            END                                                      AS JYDSMC_ORIG --交易对手名称（脱敏前）
          ,B.GSFZJG                                                  AS GSFZJG --归属分支机构
          ,A.DATA_SRC_DESC                                           AS DATA_SRC_DESC --数据来源中文
          ,A.ZCSFL                                                   AS ZCSFL --资产三分类代码 --ADD BY LIP 20250415
      FROM RRP_EAST.EAST5_1003_ZYZJJYXXB_TY A
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
      LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO D --对公客户基本信息
        ON D.CUST_ID = TRIM(A.JYDSHXKHH)
       AND D.ETL_DT = V_DATE
      LEFT JOIN RRP_MDL.CODE_MAP E --MOD BY LIP 20250324 根据业务提供的映射调整
        ON E.SRC_VALUE_CODE = D.NATNAL_ECON_DEPT_TYPE_CD
       AND E.SRC_CLASS_CODE = 'CD1418' --国民经济部门类型代码
       AND E.TAR_CLASS_CODE = 'C0060' --交易对手类别
       AND E.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.O_IML_PTY_SPV_CUST_INFO G --SPV客户信息
        ON G.SPV_CUST_ID = TRIM(A.JYDSHXKHH)
       AND G.START_DT <= V_DATE
       --AND G.END_DT >= V_DATE
       AND G.END_DT > V_DATE
      LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO F --对公客户基本信息
        ON F.CUST_ID = TRIM(G.PARTY_ID)
       AND F.ETL_DT = V_DATE
      LEFT JOIN RRP_MDL.CODE_MAP H --MOD BY LIP 20250324 根据业务提供的映射调整
        ON H.SRC_VALUE_CODE = F.NATNAL_ECON_DEPT_TYPE_CD
       AND H.SRC_CLASS_CODE = 'CD1418' --国民经济部门类型代码
       AND H.TAR_CLASS_CODE = 'C0060' --交易对手类别
       AND H.MOD_FLG = 'EAST'
      LEFT JOIN RRP_EAST.EAST5_1003_ZYZJJYXXB_TY_DFXX DFZH
        ON DFZH.JYBH = A.JYBH
       AND ((DFZH.RANK_RN IS NOT NULL AND DFZH.RANK_RNN = 1) OR DFZH.ZS = 1)
     WHERE A.CJRQ = V_MONTH_END_DATEID;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --自营资金交易信息中间表数据--插入目标表
    V_STEP      := V_STEP + 1;
    V_STEP_DESC := '自营资金交易信息中间表数据--插入目标表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_1003_ZYZJJYXXB
      (RID --数据主键
      ,NBJGH --内部机构号
      ,JRXKZH --金融许可证号
      ,YHJGMC --银行机构名称
      ,MXKMBH --明细科目编号
      ,MXKMMC --明细科目名称
      ,JYZHLX --账户类型
      ,JYBH --交易编号
      ,JRGJBH --金融工具编号
      ,JRGJMC --金融工具名称
      ,YEDL --业务大类
      ,YWZL --业务中类
      ,YWXL --业务小类
      ,CPMC --产品名称
      ,JYFX --交易方向
      ,MYBJBZ --合约币种
      ,MYBJJE --合约金额
      ,NHLL --年化利率
      ,JYRQ --交易日期
      ,HTYDRQ --合同起始日期
      ,HTDQRQ --合同到期日期
      ,BFQSZH --本方清算账号
      ,JYDSLB --交易对手类别
      ,JYDSMC --交易对手名称
      ,JYDSPJ --交易对手评级
      ,JYDSPJJG --交易对手评级机构
      ,JYDSZH --交易对手账号
      ,JYDSKHHH --交易对手开户行号
      ,JYDSKHHM --交易对手开户行名
      ,WTGLBZ --委托管理标志
      ,SPRGH --审批人工号
      ,JYYGH --经办人工号
      ,BBZ --备注
      ,CJRQ --采集日期
      ,DEPT_NO --部门编号
      ,SRC_SYS_ID --来源系统ID
      ,ISSUED_NO --填报机构
      ,ORG_NO --报送机构
      ,ADDRESS --归属地
      ,JYDSMC_ORIG --交易对手名称脱敏（前）
      ,GSFZJG --归属分支机构
      ,TY_ZJ_FLAG --同业资金标志
      ,DATA_SRC_DESC --数据来源系统 --MOD BY LIP 20250415
      )
    WITH EMP_TLR AS (
    SELECT ACCT_ID AS TLR_NO,EMP_NO AS EMP_ID,TO_CHAR(V_DATE+1,'YYYYMMDD') AS UPDATE_DT FROM RRP_MDL.ADD_TRA_EMP_NO
     UNION ALL
    SELECT TLR_NO,EMP_ID,UPDATE_DT FROM RRP_MDL.ADD_EMP_TLR),
    CMM_CLERK_INFO AS (
    SELECT TC.TLR_NO   AS TELLER_ID,
           TC.EMP_ID   AS CLERK_ID,
           ROW_NUMBER() OVER(PARTITION BY TC.TLR_NO ORDER BY TC.UPDATE_DT DESC) RN
      FROM EMP_TLR TC)
    SELECT RID --数据主键
          ,NBJGH --内部机构号
          ,JRXKZH --金融许可证号
          ,YHJGMC --银行机构名称
          ,MXKMBH --明细科目编号
          ,MXKMMC --明细科目名称
          ,JYZHLX --账户类型
          ,JYBH --交易编号
          ,JRGJBH --金融工具编号
          ,JRGJMC --金融工具名称
          ,YEDL --业务大类
          ,YWZL --业务中类
          ,YWXL --业务小类
          ,CPMC --产品名称
          ,JYFX --交易方向
          ,MYBJBZ --合约币种
          ,MYBJJE --合约金额
          ,NVL(NHLL,0) AS NHLL --年化利率
          ,JYRQ --交易日期
          ,NVL(TRIM(HTYDRQ),'99991231') AS HTYDRQ --合同起始日期
          ,NVL(TRIM(HTDQRQ),'99991231') AS HTDQRQ --合同到期日期
          ,BFQSZH --本方清算账号
          ,JYDSLB --交易对手类别
          --,JYDSMC --交易对手名称
          --MOD BY LIP 20230506 当对公客户的名称都是中文名时，将其中的()改为（）
          ,CASE WHEN REGEXP_REPLACE(TRIM(T.JYDSMC),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
               THEN REPLACE(REPLACE(REPLACE(TRIM(T.JYDSMC),'(','（'),')','）'),' ','')
               ELSE TRIM(T.JYDSMC)
           END                  AS JYDSMC --交易对手名称
          ,JYDSPJ --交易对手评级
          ,JYDSPJJG --交易对手评级机构
          ,JYDSZH --交易对手账号
          ,JYDSKHHH --交易对手开户行号
          ,JYDSKHHM --交易对手开户行名
          ,WTGLBZ --委托管理标志
          --,SPRGH --审批人工号
          --,JYYGH --经办人工号
          --,NVL(TA.CLERK_ID,TRIM(T.SPRGH)) AS SPRGH --审批人工号
          ,CASE WHEN NVL(TB.CLERK_ID,TRIM(T.JYYGH)) = NVL(TA.CLERK_ID,TRIM(T.SPRGH)) THEN NULL
                ELSE NVL(TA.CLERK_ID,TRIM(T.SPRGH))
            END AS SPRGH --审批人工号 --MOD BY LIP 20220919 当经办人工号和审批人工号一致时，将审批人置空
          ,NVL(TB.CLERK_ID,TRIM(T.JYYGH)) AS JYYGH --经办人工号
          ,BBZ --备注
          ,CJRQ --采集日期
          ,DEPT_NO --部门编号
          ,SRC_SYS_ID --来源系统ID
          --,ISSUED_NO --填报机构
          ,'000000' AS ISSUED_NO --填报机构
          ,ORG_NO --报送机构
          ,ADDRESS --归属地
          --,JYDSMC_ORIG --交易对手名称脱敏（前）
          --MOD BY LIP 20230506 当对公客户的名称都是中文名时，将其中的()改为（）
          ,CASE WHEN REGEXP_REPLACE(TRIM(T.JYDSMC_ORIG),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
               THEN REPLACE(REPLACE(REPLACE(TRIM(T.JYDSMC_ORIG),'(','（'),')','）'),' ','')
               ELSE TRIM(T.JYDSMC_ORIG)
           END                  AS JYDSMC_ORIG --交易对手名称脱敏（前）
          ,GSFZJG               AS GSFZJG      --归属分支机构
          --,'资金'               AS TY_ZJ_FLAG --同业资金标志
          ,ISSUED_NO            AS TY_ZJ_FLAG  --同业资金标志
          ,'资金系统'           AS DATA_SRC_DESC --数据来源系统 --MOD BY LIP 20250415
      FROM RRP_EAST.EAST5_1003_ZYZJJYXXB_ZJ_R T
      LEFT JOIN CMM_CLERK_INFO TA
        ON TA.TELLER_ID = T.SPRGH
       AND TA.RN = 1
      LEFT JOIN CMM_CLERK_INFO TB
        ON TB.TELLER_ID = T.JYYGH
       AND TB.RN = 1;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP      := V_STEP + 1;
    V_STARTTIME := SYSDATE;
    V_STEP_DESC := '自营资金交易信息表_同业';
    INSERT INTO RRP_EAST.EAST5_1003_ZYZJJYXXB
      (RID --数据主键
      ,NBJGH --内部机构号
      ,JRXKZH --金融许可证号
      ,YHJGMC --银行机构名称
      ,MXKMBH --明细科目编号
      ,MXKMMC --明细科目名称
      ,JYZHLX --账户类型
      ,JYBH --交易编号
      ,JRGJBH --金融工具编号
      ,JRGJMC --金融工具名称
      ,YEDL --业务大类
      ,YWZL --业务中类
      ,YWXL --业务小类
      ,CPMC --产品名称
      ,JYFX --交易方向
      ,MYBJBZ --合约币种
      ,MYBJJE --合约金额
      ,NHLL --年化利率
      ,JYRQ --交易日期
      ,HTYDRQ --合同起始日期
      ,HTDQRQ --合同到期日期
      ,BFQSZH --本方清算账号
      ,JYDSLB --交易对手类别
      ,JYDSMC --交易对手名称
      ,JYDSPJ --交易对手评级
      ,JYDSPJJG --交易对手评级机构
      ,JYDSZH --交易对手账号
      ,JYDSKHHH --交易对手开户行号
      ,JYDSKHHM --交易对手开户行名
      ,WTGLBZ --委托管理标志
      ,SPRGH --审批人工号
      ,JYYGH --经办人工号
      ,BBZ --备注
      ,CJRQ --采集日期
      ,DEPT_NO --部门编号
      ,SRC_SYS_ID --来源系统ID
      ,ISSUED_NO --填报机构
      ,ORG_NO --报送机构
      ,ADDRESS --归属地
      ,JYDSMC_ORIG --交易对手名称脱敏（前）
      ,GSFZJG --归属分支机构
      ,TY_ZJ_FLAG --同业资金标志
      ,DATA_SRC_DESC --数据来源系统 --MOD BY LIP 20250415
      )
    WITH EMP_TLR AS (
    SELECT ACCT_ID AS TLR_NO,EMP_NO AS EMP_ID,TO_CHAR(V_DATE+1,'YYYYMMDD') AS UPDATE_DT FROM RRP_MDL.ADD_TRA_EMP_NO
     UNION ALL
    SELECT TLR_NO,EMP_ID,UPDATE_DT FROM RRP_MDL.ADD_EMP_TLR),
    CMM_CLERK_INFO AS (
    SELECT TC.TLR_NO   AS TELLER_ID,
           TC.EMP_ID   AS CLERK_ID,
           ROW_NUMBER() OVER(PARTITION BY TC.TLR_NO ORDER BY TC.UPDATE_DT DESC) RN
      FROM EMP_TLR TC)
    SELECT RID --数据主键
          ,NBJGH --内部机构号
          ,JRXKZH --金融许可证号
          ,YHJGMC --银行机构名称
          ,MXKMBH --明细科目编号
          ,MXKMMC --明细科目名称
          ,JYZHLX --账户类型
          ,JYBH --交易编号
          ,JRGJBH --金融工具编号
          ,JRGJMC --金融工具名称
          ,YEDL --业务大类
          ,YWZL --业务中类
          ,YWXL --业务小类
          ,CPMC --产品名称
          ,JYFX --交易方向
          ,MYBJBZ --合约币种
          ,MYBJJE --合约金额
          ,NVL(NHLL,0) NHLL --年化利率
          ,JYRQ --交易日期
          ,NVL(TRIM(HTYDRQ),'99991231') HTYDRQ --合同起始日期
          ,NVL(TRIM(HTDQRQ),'99991231') HTDQRQ --合同到期日期
          ,BFQSZH --本方清算账号
          ,JYDSLB --交易对手类别
          --,JYDSMC --交易对手名称
          --MOD BY LIP 20230506 当对公客户的名称都是中文名时，将其中的()改为（）
          ,CASE WHEN REGEXP_REPLACE(TRIM(T.JYDSMC),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
               THEN REPLACE(REPLACE(REPLACE(TRIM(T.JYDSMC),'(','（'),')','）'),' ','')
               ELSE TRIM(T.JYDSMC)
           END                  AS JYDSMC --交易对手名称
          ,JYDSPJ --交易对手评级
          ,JYDSPJJG --交易对手评级机构
          ,JYDSZH --交易对手账号
          ,JYDSKHHH --交易对手开户行号
          ,JYDSKHHM --交易对手开户行名
          ,WTGLBZ --委托管理标志
          --,SPRGH --审批人工号
          --,JYYGH --经办人工号
          --,NVL(TA.CLERK_ID,TRIM(T.SPRGH)) AS SPRGH --审批人工号
          ,CASE WHEN NVL(TA.CLERK_ID,TRIM(T.SPRGH)) = NVL(TB.CLERK_ID,TRIM(T.JYYGH)) THEN NULL
                ELSE NVL(TA.CLERK_ID,TRIM(T.SPRGH))
            END AS SPRGH --审批人工号 --MOD BY LIP 20220919 当经办人工号和审批人工号一致时，将审批人置空
          ,NVL(TB.CLERK_ID,TRIM(T.JYYGH)) AS JYYGH --经办人工号
          ,BBZ --备注
          ,CJRQ --采集日期
          ,DEPT_NO --部门编号
          ,SRC_SYS_ID --来源系统ID
          --,ISSUED_NO --填报机构
          ,'000000' ISSUED_NO --填报机构
          ,ORG_NO --报送机构
          ,ADDRESS --归属地
          --,JYDSMC_ORIG --交易对手名称脱敏（前）
          --MOD BY LIP 20230506 当对公客户的名称都是中文名时，将其中的()改为（）
          ,CASE WHEN REGEXP_REPLACE(TRIM(T.JYDSMC_ORIG),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(T.JYDSMC_ORIG),'(','（'),')','）'),' ','')
                ELSE TRIM(T.JYDSMC_ORIG)
            END                  AS JYDSMC_ORIG --交易对手名称脱敏（前）
          ,GSFZJG --归属分支机构
          --,'同业'  TY_ZJ_FLAG --同业资金标志
          ,ISSUED_NO  TY_ZJ_FLAG --同业资金标志
          ,DATA_SRC_DESC AS DATA_SRC_DESC --数据来源系统 --MOD BY LIP 20250415
      FROM RRP_EAST.EAST5_1003_ZYZJJYXXB_TY_R T
      LEFT JOIN CMM_CLERK_INFO TA
        ON TA.TELLER_ID = T.SPRGH
       AND TA.RN = 1
      LEFT JOIN CMM_CLERK_INFO TB
        ON TB.TELLER_ID = T.JYYGH
       AND TB.RN = 1;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --'委托同业代付数据--插入自营资金交易信息表目标表
    V_STEP      := V_STEP + 1;
    V_STEP_DESC := '委托同业代付数据--插入自营资金交易信息表目标表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_1003_ZYZJJYXXB
      (RID, --数据主键
       NBJGH, --内部机构号
       JRXKZH, --金融许可证号
       YHJGMC, --银行机构名称
       MXKMBH, --明细科目编号
       MXKMMC, --明细科目名称
       JYZHLX, --账户类型
       JYBH, --交易编号
       JRGJBH, --金融工具编号
       JRGJMC, --金融工具名称
       YEDL, --业务大类
       YWZL, --业务中类
       YWXL, --业务小类
       CPMC, --产品名称
       JYFX, --交易方向
       MYBJBZ, --合约币种
       MYBJJE, --合约金额
       NHLL, --年化利率
       JYRQ, --交易日期
       HTYDRQ, --合同起始日期
       HTDQRQ, --合同到期日期
       BFQSZH, --本方清算账号
       JYDSLB, --交易对手类别
       JYDSMC, --交易对手名称
       JYDSPJ, --交易对手评级
       JYDSPJJG, --交易对手评级机构
       JYDSZH, --交易对手账号
       JYDSKHHH, --交易对手开户行号
       JYDSKHHM, --交易对手开户行名
       WTGLBZ, --委托管理标志
       SPRGH, --审批人工号
       JYYGH, --经办人工号
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       JYDSMC_ORIG, --交易对手名称脱敏（前）
       GSFZJG,--归属分支机构
       TY_ZJ_FLAG, --同业资金标志
       DATA_SRC_DESC --数据来源系统 --MOD BY LIP 20250415
       )
    WITH EMP_TLR AS (
    SELECT ACCT_ID AS TLR_NO,EMP_NO AS EMP_ID,TO_CHAR(V_DATE+1,'YYYYMMDD') AS UPDATE_DT FROM RRP_MDL.ADD_TRA_EMP_NO
     UNION ALL
    SELECT TLR_NO,EMP_ID,UPDATE_DT FROM RRP_MDL.ADD_EMP_TLR),
    CMM_CLERK_INFO AS (
    SELECT TC.TLR_NO   AS TELLER_ID,
           TC.EMP_ID   AS CLERK_ID,
           ROW_NUMBER() OVER(PARTITION BY TC.TLR_NO ORDER BY TC.UPDATE_DT DESC) RN
      FROM EMP_TLR TC)
    SELECT --MD5(V_MONTH_END_DATEID || A.TRA_ID)             AS RID, --数据主键
           SYS_GUID()                                      AS RID, --数据主键
           NVL(TRIM(F.ORG_ID1),'800')                      AS NBJGH, --内部机构号
           B.FIN_PERMIT_NO                                 AS JRXKZH, --金融许可证号
           B.ORG_NM                                        AS YHJGMC, --银行机构名称
           SUBSTR(A.SUBJ_ID,1,8)                           AS MXKMBH, --明细科目编号
           C.SUBJ_NM                                       AS MXKMMC, --明细科目名称
           A.ACC_TYP                                       AS JYZHLX, --账户类型
           A.TRA_ID                                        AS JYBH, --交易编号
           A.FIN_INST_ID                                   AS JRGJBH, --金融工具编号
           D.FIN_INST_NM                                   AS JRGJMC, --金融工具名称
           A.BIZ_LRG_CL                                    AS YEDL, --业务大类
           A.BIZ_MID_CL                                    AS YWZL, --业务中类
           A.BIZ_SML_CL                                    AS YWXL, --业务小类
           A.PROD_NM                                       AS CPMC, --产品名称
           CODE4.TAR_VALUE_NAME                            AS JYFX, --交易方向
           A.CONT_CUR                                      AS MYBJBZ, --合约币种
           A.CONT_AMT                                      AS MYBJJE, --合约金额
           A.YEAR_RATE                                     AS NHLL, --年化利率
           NVL(A.TRA_DT,'99991231')                        AS JYRQ, --交易日期
           NVL(A.CONT_START_DT,'99991231')                 AS HTYDRQ, --合同起始日期
           NVL(A.CONT_EXP_DT,'99991231')                   AS HTDQRQ, --合同到期日期
           A.LIQ_ACC                                       AS BFQSZH, --本方清算账号
           A.CNTPR_TYP                                     AS JYDSLB, --交易对手类别
           --A.CNTPR_NM                                      AS JYDSMC, --交易对手名称
           --MOD BY LIP 20230506 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(A.CNTPR_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(A.CNTPR_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(A.CNTPR_NM)
            END                                            AS JYDSMC, --交易对手名称
           A.CNTPR_RTG                                     AS JYDSPJ, --交易对手评级
           A.CNTPR_RTG_ORG_NM                              AS JYDSPJJG, --交易对手评级机构
           A.CNTPR_ACC                                     AS JYDSZH, --交易对手账号
           A.CNTPR_OPEN_BANK_NO                            AS JYDSKHHH, --交易对手开户行号
           A.CNTPR_OPEN_BANK_NM                            AS JYDSKHHM, --交易对手开户行名
           --A.ENTRS_MGT_FLG                                 AS WTGLBZ, --委托管理标志
           CODE6.TAR_VALUE_NAME                            AS WTGLBZ, --委托管理标志
           --A.APRV_PSN_NO                                   AS SPRGH, --审批人工号
           --A.HDLR_NO                                       AS JYYGH, --经办人工号
           --NVL(TA.CLERK_ID,TRIM(A.APRV_PSN_NO))            AS SPRGH, --审批人工号
           CASE WHEN NVL(TA.CLERK_ID,TRIM(A.APRV_PSN_NO)) = NVL(TB.CLERK_ID,TRIM(A.HDLR_NO)) THEN NULL
                ELSE NVL(TA.CLERK_ID,TRIM(A.APRV_PSN_NO))
            END                                            AS SPRGH, --审批人工号 --MOD BY LIP 20220919 当经办人工号和审批人工号一致时，将审批人置空
           NVL(TB.CLERK_ID,TRIM(A.HDLR_NO))                AS JYYGH, --经办人工号
           ''                                              AS BBZ, --备注
           V_MONTH_END_DATEID                              AS CJRQ, --采集日期
           '000'                                           AS DEPT_NO, --部门编号
           '01'                                            AS SRC_SYS_ID, --来源系统ID
           --A.DEPT_LINE                                     AS ISSUED_NO, --填报机构
           '000000'                                        AS ISSUED_NO, --填报机构
           ORG.ORG_ID_LEL_0                                AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
           END                                             AS ADDRESS, --归属地
           --A.CNTPR_NM                                      AS JYDSMC_ORIG, --交易对手名称脱敏（前）
           --MOD BY LIP 20230506 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(A.CNTPR_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(A.CNTPR_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(A.CNTPR_NM)
            END                                            AS JYDSMC_ORIG, --交易对手名称脱敏（前）
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                            AS GSFZJG,--归属分支机构
           --'同业代付'                                      AS TY_ZJ_FLAG --同业资金标志
           A.DEPT_LINE                                     AS TY_ZJ_FLAG, --同业资金标志
           '同业代付'                                      AS DATA_SRC_DESC --数据来源系统 --MOD BY LIP 20250415
      FROM RRP_MDL.M_EAST_OWN_CPTL_DTL A --自营资金交易流水
      LEFT JOIN RRP_MDL.ORG_CONFIG F --机构映射表
        ON F.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(TRIM(F.ORG_ID1),'800')
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_GL_INFO C --总账会计科目信息表--科目报送到三级
        ON C.SUBJ_ID = SUBSTR(A.SUBJ_ID,1,8)
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_FIN_INST_INFO D --金融工具信息表
        ON D.FIN_INST_ID = A.FIN_INST_ID
       AND D.DATA_SRC = A.DATA_SRC
       AND D.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE4 --码值配置表 --交易方向
        ON CODE4.SRC_VALUE_CODE = A.TRA_DIR
       AND CODE4.SRC_CLASS_CODE = 'D0133'
       AND CODE4.TAR_CLASS_CODE = 'D0133'
       AND CODE4.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE6 --码值配置表 --委托管理标志
        ON CODE6.SRC_VALUE_CODE = A.ENTRS_MGT_FLG
       AND CODE6.SRC_CLASS_CODE = 'Z0001'
       AND CODE6.TAR_CLASS_CODE = 'Z0001'
       AND CODE6.MOD_FLG = 'EAST'
      LEFT JOIN CMM_CLERK_INFO TA
        ON TA.TELLER_ID = A.APRV_PSN_NO
       AND TA.RN = 1
      LEFT JOIN CMM_CLERK_INFO TB
        ON TB.TELLER_ID = A.HDLR_NO
       AND TB.RN = 1
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = B.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON 1 = 1
       AND UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE --UPPER(A.DATA_SRC) IN ('CRSS')
           UPPER(A.DATA_SRC) IN ('ICMS') --MODIFY BY TANGAN AT 20221223
       AND A.BIZ_MID_CL = '同业代付'
       AND A.DATA_DT = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --更新交易对手账号及相关信息 --MOD BY LIP 20250417
    V_STEP      := V_STEP + 1;
    V_STEP_DESC := '更新交易对手账号及相关信息1';
    V_STARTTIME := SYSDATE;
    MERGE INTO (SELECT * FROM RRP_EAST.EAST5_1003_ZYZJJYXXB T
                 WHERE TRIM(JYDSMC) IS NOT NULL
                   AND TRIM(JYDSZH) IS NULL
                   AND CJRQ = V_MONTH_END_DATEID) TA
    USING (SELECT T.*,ROW_NUMBER() OVER(PARTITION BY JYDSMC,DATA_SRC_DESC ORDER BY JYRQ DESC) RN
             FROM RRP_EAST.EAST5_1003_ZYZJJYXXB T
            WHERE TRIM(JYDSMC) IS NOT NULL
              AND TRIM(JYDSZH) IS NOT NULL
              AND CJRQ = V_MONTH_END_DATEID) TB
       ON (TB.JYDSMC = TA.JYDSMC AND TB.DATA_SRC_DESC = TA.DATA_SRC_DESC AND TB.RN = 1)
     WHEN MATCHED THEN UPDATE SET
       TA.JYDSZH = TB.JYDSZH,
       TA.JYDSKHHH = TB.JYDSKHHH,
       TA.JYDSKHHM = TB.JYDSKHHM;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --更新交易对手账号及相关信息 --MOD BY LIP 20250417
    V_STEP      := V_STEP + 1;
    V_STEP_DESC := '更新交易对手账号及相关信息2';
    V_STARTTIME := SYSDATE;
    MERGE INTO (SELECT * FROM RRP_EAST.EAST5_1003_ZYZJJYXXB T
                 WHERE TRIM(JYDSMC) IS NOT NULL
                   AND TRIM(JYDSZH) IS NULL
                   AND CJRQ = V_MONTH_END_DATEID) TA
    USING (SELECT T.*,ROW_NUMBER() OVER(PARTITION BY JYDSMC,DATA_SRC_DESC ORDER BY JYRQ DESC) RN
             FROM RRP_EAST_APP.EAST5_1003_ZYZJJYXXB@LINK_RRP T
            WHERE TRIM(JYDSMC) IS NOT NULL
              AND TRIM(JYDSZH) IS NOT NULL
              AND CJRQ = V_MONTH_END_DATEID) TB
       ON (TB.JYDSMC = TA.JYDSMC AND TB.DATA_SRC_DESC = TA.DATA_SRC_DESC AND TB.RN = 1)
     WHEN MATCHED THEN UPDATE SET
       TA.JYDSZH = TB.JYDSZH,
       TA.JYDSKHHH = TB.JYDSKHHH,
       TA.JYDSKHHM = TB.JYDSKHHM;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --表分析
    V_STEP      := V_STEP + 1;
    V_STEP_DESC := '--表分析开始 --';
    V_STARTTIME := SYSDATE;
    RRP_EAST.ETL_DBMS_STATS(V_P_DATE, V_TABLE_NAME, V_PARTITION_NAME, O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  END IF;

  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  --在过程跑批完成记录表中插入记录，调度查询该表判断过程是是否跑批完成
  INSERT INTO RRP_MDL.ETL_STATE (ETL_DATE, PROC_NAME, END_TIME)
  VALUES (V_P_DATE, V_PROC_NAME, TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
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

END ETL_EAST5_1003_ZYZJJYXXB;
/

