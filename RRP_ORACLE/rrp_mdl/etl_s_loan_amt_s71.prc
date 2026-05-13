CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_LOAN_AMT_S71(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_LOAN_AMT_S71
  *  功能描述：S71普惠小微发放时授信额度表
  *  创建日期：20230217
  *  开发人员：于敬艺
  *  来源表：   S_LOAN
  *  目标表：   S_LOAN_AMT_S71
  *  配置表：
  *  修改情况：
  *   序号  修改日期  修改人   修改原因
  *   1    20230217  于敬艺   新增
  *   2    20230222  于敬艺   优化口径：黄娅娅和禹晴确定，当月发放当月结清，且期末没有有效授信的客户行内借据，
  *   3    20230223  LIUYU   纠正：当月放款月底没有授信客户放款授信逻辑统计：
  *       1）零售联合网贷：放款授信按照客户当月借据放款金额之和算当月授信
  *       2）对公：放款授信按照客户借据对应额度合同金额之和算当月授信
  *   4    20230228  LIUYU   转贴现虽然调整了客户号，还是需要按照借据对应客户额度统计借据授信总额（按照信贷客户取授信）
  *   5    20230522  LIUYU   调整过滤放款日期>=本月为 = 本月
  *   6    20230523  LIUYU   删除判断跑批频度逻辑
  *   7    20230527  LIUYU   优化取数逻辑取联合网贷放款日期<数据日期月末
  *   8    20230604  LIUYU   客户信息取报告日的客户信息，调整逻辑
  *   9    20230803  HYF     调整零售新发放授信过滤条件，消费和经营分开
  *   10   20230911  HYF     网商贷发放时授信总额，发放时消费授信总额，发放时经营授信总额超过50万，按50万计算
  *   11   20231102  HYF     调整其他个人非农户标识，直取S_LOAN 标志
  *   12   20240119  LWB     调整网商贷放款月授信额度相关的三个字段，即针对网商贷借据做特殊加工，规则修改处
  *   13   20240301  LWB     优化当日放款当日结清的逻辑
  *   14   20240304  LWB     客户类型修改为放款时客户类型
  *   15   20240329  LWB     修改转贴现部分放款时授信额度的逻辑
  *   16   20240729  LWB     修改部分取不到的对公信贷数据的取数逻辑
  *   17   20240805  LWB     修改其他个人非农户标识取数逻辑
  *   18   20250115  LWB     新增科技企业标志、逾期期限字段
  *   19   20250311  HYF     新增创新型中小企业标志、国家企业技术中心标志、各类科技名单企业标志、科技型中小企业标志，新增对公联合网贷-微业贷逻辑
  *   20   20250324  HYF     新增原建档立卡贫困户标志
  *   21   20250325  LWB     单独对同时存在网商贷与非网商贷客户进行逻辑处理
  *   22   20250415  HYF     增加系统内转贴标识 SYS_IN_FLG   
  *   23   20250514  HYF     新增放款机构号将891转出的机构号固定，方便报表累放指标出数，新增退役军人标志，无营业执照负责人标志
  *   24   20250704  HYF     其他个人非农户标识补充字节小微贷取数口径同自营贷款保持一致
  *   25   20250711  LWB     修改问题客户的放款时授信额度取数逻辑
  *   26   20251119  HYF     其他个人非农户标识补充201020100064-好企贷（恒兴）
  *   27   20260320  HYF     新增并购贷款类型、是否境外并购贷款、是否退役军人创办企业、放款月企业规模、放款月控股类型
  **********************************************************************/
AS
  --定义变量
  V_P_DATE         VARCHAR2(8);      --跑批数据日期
  V_STEP           INTEGER := 0;     --处理步骤
  V_SQLCOUNT       INTEGER := 0;     --更新或删除影响的记录数
  V_STARTTIME      DATE;             --处理开始时间
  V_ENDTIME        DATE;             --处理结束时间
  V_SQLMSG         VARCHAR2(300);    --SQL执行描述信息
  V_STEP_DESC      VARCHAR2(2000);   --任务名称
  V_PART_NAME      VARCHAR2(100);    --分区名
  V_LAST_MONTH_END VARCHAR2(8);      --上月末
  V_LAST_YEAR_END  VARCHAR2(8);      --上年末
  V_TAB_NAME       VARCHAR2(100) := 'S_LOAN_AMT_S71'; --表名
  V_PROC_NAME      VARCHAR2(1000) := 'ETL_S_LOAN_AMT_S71'; --程序名称
  V_SYSTEM         VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  V_LAST_MONTH_END := TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')-1,'YYYYMMDD'); --上月末
  V_LAST_YEAR_END  := TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y')-1,'YYYYMMDD'); --上年末

  --支持重跑
  V_STEP := 1;
  V_STEP_DESC := '程序跑批开始';
  V_STARTTIME := SYSDATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --分区表分区处理
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分
  V_STEP := V_STEP + 1;
  V_STEP_DESC := 'S7103普惠型消费贷款明细表--加工上月末的授信总额';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.S_LOAN_AMT_S71(
    DATA_DT                    ,        --数据日期
    ORG_NO                     ,        --机构号
    CUST_NO                    ,        --客户号
    RCPT_ID                    ,        --借据号
    CONT_ID                    ,        --合同编号
    RCPT_STAT                  ,        --借据状态
    CURR_CD                    ,        --币种
    LOAN_BIZ_TYP               ,        --贷款业务类型
    LOAN_ACT_DSTR_DT           ,        --贷款实际发放日期
    LOAN_ORIG_EXP_DT           ,        --贷款原始到期日期
    LVL5_CL                    ,        --五级分类
    LOAN_AMT                   ,        --放款金额
    LOAN_BAL                   ,        --贷款余额
    LOAN_NET_VAL               ,        --贷款净值
    STD_PROD_ID                ,        --标准产品编号
    LOAN_USEAGE                ,        --贷款用途
    INCOME_ANNUAL              ,        --年化收益
    FF_CRDT_TOTAL_LMT          ,        --发放时授信总额
    FF_OPR_CRDT_TOT_AMT        ,        --发放时经营授信总额
    FF_CON_CRDT_TOT_AMT        ,        --发放时消费授信总额
    CBRC_FLG                   ,        --CBRC标志
    DSBR_FARM_FLG              ,        --放款时农户标志
    OPR_CUST_TYP               ,        --经营性客户类型
    NON_REPY_PRIN_RENEW_FLG    ,        --无还本续贷标志
    LOAN_TERM                  ,        --贷款期限
    TJDBFS                     ,        --统计担保方式
    ENT_SCALE                  ,        --企业规模
    CORP_CUST_TYP              ,        --对公客户类型
    IS_CBRC_ENT                ,        --是否企业（银监）
    LOAN_DIR_BIO_FLG           ,        --贷款投向境内外标识
    TECH_INNO_ENT_FLG          ,        --科创企业标志
    CUST_LRG_CL                ,        --客户大类
    DATA_SRC                   ,        --数据来源
    QTGRFNH                    ,        --其他个人非农户标识
    OVD_LOAN_TERM              ,        --逾期期限
    TECH_ENT_FLG               ,        --科技型企业标志
    INOVT_MED_SIDE_ENTER_FLG   ,        --创新型中小企业标志
    CTY_CORP_TECH_CENTER_FLG   ,        --国家企业技术中心标志
    EACH_CLASS_SCEN_TECH_LIST_CORP_FLG, --各类科技名单企业标志
    TECH_MID_SML_ENT_FLG       ,        --科技型中小企业标志
    YJDLKPKH                   ,        --原建档立卡贫困户标志
    SYS_IN_FLG                 ,        --系统外标志
    FK_ORG_ID                  ,        --累放层机构号
    EX_SERVSM_FLG              ,        --退役军人标志
    NO_BUSLICS_PRC_FLG         ,        --无营业执照负责人标志
    BGDKLX                     ,        --并购贷款类型
    SFJWBGDK                   ,        --是否境外并购贷款
    SFTYJRCBQY                 ,        --是否退役军人创办企业
    FKSQYGM                    ,        --放款时企业规模
    FKSKGLX                    ,        --放款时控股类型
    FKYQYGM                    ,        --放款月企业规模
    FKYKGLX                             --放款月控股类型
    )
  SELECT V_P_DATE                            AS DATA_DT               --数据日期
         ,A.ORG_NO                            AS ORG_NO                --机构编号
         ,A.CUST_NO                           AS CUST_NO               --客户编号
         ,A.RCPT_ID                           AS RCPT_ID               --借据编号
         ,A.CONT_ID                           AS CONT_ID               --合同编号
         ,A.RCPT_STAT                         AS RCPT_STAT             --借据状态
         ,A.CURR_CD                           AS CURR_CD               --币种
         ,A.LOAN_BIZ_TYP                      AS LOAN_BIZ_TYP          --贷款业务类型
         ,A.LOAN_ACT_DSTR_DT                  AS LOAN_ACT_DSTR_DT      --贷款实际发放日期
         ,A.LOAN_ORIG_EXP_DT                  AS LOAN_ORIG_EXP_DT      --贷款原始到期日期
         ,A.LVL5_CL                           AS LVL5_CL               --五级分类
         ,A.LOAN_AMT                          AS LOAN_AMT              --放款金额
         ,A.LOAN_BAL                          AS LOAN_BAL              --贷款余额
         ,A.LOAN_NET_VAL                      AS LOAN_NET_VAL          --贷款净值
         ,A.STD_PROD_ID                       AS STD_PROD_ID           --标准产品编号
         ,A.LOAN_USEAGE                       AS LOAN_USEAGE           --贷款用途
         ,B.INCOME_ANNUAL                     AS INCOME_ANNUAL         --年化收益
         ,A.FF_CRDT_TOTAL_LMT                 AS FF_CRDT_TOTAL_LMT     --发放时授信总额
         ,A.FF_OPR_CRDT_TOT_AMT               AS FF_OPR_CRDT_TOT_AMT   --发放经营授信总额
         ,A.FF_CON_CRDT_TOT_AMT               AS FF_CON_CRDT_TOT_AMT   --发放消费授信总额
         ,B.CBRC_FLG                          AS CBRC_FLG              --CBRC标志
         ,B.FKSSNBZ                           AS DSBR_FARM_FLG         --放款时农户标志
         ,B.FKSKHLX/*A.OPR_CUST_TYP*/         AS OPR_CUST_TYP          --经营性客户类型 MODIFY BY LWB
         ,B.NON_REPY_PRIN_RENEW_FLG           AS NON_REPY_PRIN_RENEW_FLG --无还本续贷标志
         ,B.LOAN_TERM                         AS LOAN_TERM             --贷款期限
         ,B.TJDBFS                            AS TJDBFS                --统计担保方式
         ,B.FKYQYGM                           AS ENT_SCALE             --企业规模 MODIFY BY HYF
         ,B.CORP_CUST_TYP                     AS CORP_CUST_TYP         --对公客户类型
         ,B.IS_CBRC_ENT                       AS IS_CBRC_ENT           --是否企业（银监）
         ,B.LOAN_DIR_BIO_FLG                  AS LOAN_DIR_BIO_FLG      --贷款投向境内外标识
         ,B.TECH_INNO_ENT_FLG                 AS TECH_INNO_ENT_FLG     --科创企业标志
         ,B.CUST_LRG_CL                       AS CUST_LRG_CL           --客户大类
         ,B.DATA_SRC                          AS DATA_SRC              --数据来源
         ,A.QTGRFNH                           AS QTGRFNH               --其他个人非农户标识 MODIFY BY LWB 按累放层取
         ,A.OVD_LOAN_TERM                     AS OVD_LOAN_TERM         --逾期期限
         ,A.TECH_ENT_FLG                      AS TECH_ENT_FLG          --科技型企业标志MODIFY BY LWB 
         ,A.INOVT_MED_SIDE_ENTER_FLG          AS INOVT_MED_SIDE_ENTER_FLG --创新型中小企业标志 ADD BY 20250311
         ,A.CTY_CORP_TECH_CENTER_FLG          AS CTY_CORP_TECH_CENTER_FLG  --国家企业技术中心标志 ADD BY 20250311
         ,A.EACH_CLASS_SCEN_TECH_LIST_CORP_FLG AS EACH_CLASS_SCEN_TECH_LIST_CORP_FLG --各类科技名单企业标志 ADD BY 20250311
         ,A.TECH_MID_SML_ENT_FLG              AS TECH_MID_SML_ENT_FLG  --科技型中小企业标志 ADD BY 20250311
         ,A.YJDLKPKH                          AS YJDLKPKH              --原建档立卡贫困户标志 ADD BY 20250324
         ,B.SYS_IN_FLG                        AS SYS_IN_FLG            --系统外标志 ADD BY 20250415
         ,B.FK_ORG_ID                         AS FK_ORG_ID             --累放层机构号 ADD BY HYF 20250514
         ,B.EX_SERVSM_FLG                     AS EX_SERVSM_FLG         --退役军人标志 ADD BY HYF 20250514
         ,B.NO_BUSLICS_PRC_FLG                AS NO_BUSLICS_PRC_FLG    --无营业执照负责人标志 ADD BY HYF 20250514
         ,B.BGDKLX                            AS BGDKLX                --并购贷款类型 ADD BY HYF 20260320
         ,B.OV_SEA_MRG_LOAN_FLG               AS SFJWBGDK              --是否境外并购贷款 ADD BY HYF 20260320
         ,B.SFTYJRCBQY                        AS SFTYJRCBQY            --是否退役军人创办企业 ADD BY HYF 20260320
         ,B.FKSQYGM                           AS FKSQYGM               --放款时企业规模 ADD BY HYF 20260320
         ,B.FKSKGLX                           AS FKSKGLX               --放款时控股类型 ADD BY HYF 20260320
         ,B.FKYQYGM                           AS FKYQYGM               --放款月企业规模 ADD BY HYF 20260320
         ,B.FKYKGLX                           AS FKYKGLX               --放款月控股类型 ADD BY HYF 20260320
    FROM RRP_MDL.S_LOAN_AMT_S71 A --S71普惠小微发放时授信额度表
    LEFT JOIN RRP_MDL.S_LOAN B --MOD BY LIUYU 20230605 客户性质取最新的性质
      ON B.RCPT_ID = A.RCPT_ID
     AND B.DATA_DT = V_P_DATE
   WHERE A.DATA_DT <> V_LAST_YEAR_END --上年末 --上年的报送数据不纳入本年累计
     AND A.DATA_DT = V_LAST_MONTH_END; --上月末

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '清除WSD_TMP的数据';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE WSD_TMP';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_DZCP';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE WSD_HH';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE S_LOAN_AMT_S71_TMP';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --MODIFY BY LWB 20250325
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入同时出现网商贷与非网商贷客户的数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.TMP_DZCP(CUST_ID)
    WITH TMP AS (
  SELECT CUST_ID FROM RRP_MDL.S_LOAN A
   WHERE A.STD_PROD_ID IN ('202020100001','202020200004')
     AND A.LOAN_ACT_DSTR_DT BETWEEN V_LAST_MONTH_END AND V_P_DATE 
     AND A.DATA_DT = V_P_DATE
   GROUP BY CUST_ID)
  SELECT A.CUST_ID 
    FROM RRP_MDL.S_LOAN A
   INNER JOIN TMP B 
      ON B.CUST_ID = A.CUST_ID
   WHERE ((SUBSTR(A.LOAN_ACT_DSTR_DT,1,6) = SUBSTR(V_P_DATE,1,6))
          OR (A.DATA_SRC = '联合网贷' AND A.LOAN_ACT_DSTR_DT = V_LAST_MONTH_END))
     AND A.DATA_DT = V_P_DATE
   GROUP BY A.CUST_ID
  HAVING COUNT(DISTINCT CASE WHEN A.STD_PROD_ID IN ('202020100001','202020200004') THEN 'A' ELSE A.STD_PROD_ID END) > 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入同时出现网商贷与非网商贷客户的网商贷额度';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.WSD_HH(
    CUST_ID,
    FF_CRDT_TOTAL_LMT,  
    FF_OPR_CRDT_TOT_AMT, 
    FF_CON_CRDT_TOT_AMT, 
    DATA_SRC)
    WITH TMP AS (
  SELECT A.DATA_DT,
         A.RCPT_ID,
         A.CUST_ID,
         A.LOAN_AMT AS LOAN_AMT,
         CASE WHEN SUBSTR(A.LOAN_BIZ_TYP,1,4) NOT IN ('0104','0103','0101') THEN A.LOAN_AMT
              ELSE 0
          END AS FF_OPR_CRDT_TOT_AMT,
         CASE WHEN SUBSTR(A.LOAN_BIZ_TYP,1,4) IN ('0104','0103','0101') THEN A.LOAN_AMT
              ELSE 0
          END AS FF_CON_CRDT_TOT_AMT
    FROM RRP_MDL.S_LOAN A
   INNER JOIN RRP_MDL.TMP_DZCP B
      ON B.CUST_ID = A.CUST_ID
   WHERE (A.LOAN_BAL > 0 OR (A.LOAN_BAL = 0 
           AND A.LOAN_ACT_DSTR_DT = (TO_CHAR(TO_DATE(DATA_DT,'YYYYMMDD')-1,'YYYYMMDD')))) --当日放款当日结清的数据 --统计一个月内余额不为0的数据
      AND A.STD_PROD_ID IN ('202020100001','202020200004')
      AND SUBSTR(A.DATA_DT,0,6) = SUBSTR(V_P_DATE,0,6)), --当月
    TMP2 AS (
  SELECT A.DATA_DT
        ,A.CUST_ID
        ,SUM(A.LOAN_AMT)  AS FF_CRDT_TOTAL_LMT
        ,SUM(FF_OPR_CRDT_TOT_AMT) AS FF_OPR_CRDT_TOT_AMT
        ,SUM(FF_CON_CRDT_TOT_AMT) AS FF_CON_CRDT_TOT_AMT
    FROM TMP A
   GROUP BY A.DATA_DT,A.CUST_ID)
  SELECT A.CUST_ID,
         MAX(T4.FF_CRDT_TOTAL_LMT)   AS FF_CRDT_TOTAL_LMT,
         MAX(T4.FF_OPR_CRDT_TOT_AMT) AS FF_OPR_CRDT_TOT_AMT,
         0                           AS FF_CON_CRDT_TOT_AMT,
         '网商贷额度'                AS DATA_SRC
    FROM RRP_MDL.S_LOAN A  
   INNER JOIN TMP2 T4 
      ON T4.CUST_ID = A.CUST_ID
     AND T4.DATA_DT = TO_CHAR(TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD')+1,'YYYYMMDD')
   WHERE A.STD_PROD_ID IN ('202020100001','202020200004')--网商贷
     AND A.LOAN_ACT_DSTR_DT BETWEEN V_LAST_MONTH_END AND V_P_DATE
     AND A.DATA_DT = V_P_DATE
   GROUP BY A.CUST_ID;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入同时出现网商贷与非网商贷客户的非网商贷额度';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.WSD_HH(
    CUST_ID,
    FF_CRDT_TOTAL_LMT,  
    FF_OPR_CRDT_TOT_AMT, 
    FF_CON_CRDT_TOT_AMT, 
    DATA_SRC)
  /*SELECT E.CUST_ID
         ,E.CRDT_TOTAL_LMT AS FF_CRDT_TOTAL_LMT
         ,E.OPR_CRDT_TOT_AMT AS FF_OPR_CRDT_TOT_AMT
         ,E.CRDT_TOTAL_LMT-E.OPR_CRDT_TOT_AMT AS FF_CON_CRDT_TOT_AMT
         ,'非网商贷正常额度' AS DATA_SRC
    FROM RRP_MDL.M_CRDT_LMT_INFO E --授信额度主表
   INNER JOIN RRP_MDL.TMP_DZCP B 
      ON E.CUST_ID = B.CUST_ID
     AND E.DATA_DT = V_P_DATE*/
   SELECT E.CUST_ID
         ,CASE WHEN SUM(NVL(E.CRDT_LMT,0)) < SUM(NVL(E.ALDY_USE_LMT,0)) THEN SUM(NVL(E.ALDY_USE_LMT,0)) 
               ELSE SUM(NVL(E.CRDT_LMT,0))
           END AS FF_CRDT_TOTAL_LMT 
         ,CASE WHEN SUM(CASE WHEN TTA.TAR_VALUE_CODE LIKE '0102%' THEN NVL(E.CRDT_LMT,0) ELSE 0 END) <
                    SUM(CASE WHEN TTA.TAR_VALUE_CODE LIKE '0102%' THEN NVL(E.ALDY_USE_LMT,0) ELSE 0 END)
               THEN SUM(CASE WHEN TTA.TAR_VALUE_CODE LIKE '0102%' THEN NVL(E.ALDY_USE_LMT,0) ELSE 0 END)
               ELSE SUM(CASE WHEN TTA.TAR_VALUE_CODE LIKE '0102%' THEN NVL(E.CRDT_LMT,0) ELSE 0 END)
           END AS FF_OPR_CRDT_TOT_AMT
         ,CASE WHEN SUM(NVL(E.CRDT_LMT,0))-SUM(CASE WHEN TTA.TAR_VALUE_CODE LIKE '0102%' THEN NVL(E.CRDT_LMT,0) ELSE 0 END) <
                    SUM(NVL(E.ALDY_USE_LMT,0))-SUM(CASE WHEN TTA.TAR_VALUE_CODE LIKE '0102%' THEN NVL(E.ALDY_USE_LMT,0) ELSE 0 END)
               THEN SUM(NVL(E.ALDY_USE_LMT,0))-SUM(CASE WHEN TTA.TAR_VALUE_CODE LIKE '0102%' THEN NVL(E.ALDY_USE_LMT,0) ELSE 0 END)
               ELSE SUM(NVL(E.CRDT_LMT,0))-SUM(CASE WHEN TTA.TAR_VALUE_CODE LIKE '0102%' THEN NVL(E.CRDT_LMT,0) ELSE 0 END)
           END AS FF_CON_CRDT_TOT_AMT
         ,'非网商贷正常额度' AS DATA_SRC   
    FROM RRP_MDL.M_CRDT_LMT_SUB E --授信额度主表
    LEFT JOIN RRP_MDL.CODE_MAP TTA --码值映射表(贷款类型)
      ON TTA.SRC_VALUE_CODE = E.STD_PROD_ID
     AND TTA.SRC_CLASS_CODE = 'STD0002'
     AND TTA.TAR_CLASS_CODE = 'T0001'
     AND TTA.MOD_FLG = 'MDM'
   INNER JOIN RRP_MDL.TMP_DZCP B 
      ON B.CUST_ID = E.CUST_ID
   WHERE E.CRDT_STAT = 'Y'
     AND E.STD_PROD_ID NOT IN ('202020100001','202020200004')
     AND E.DATA_DT = V_P_DATE
   GROUP BY E.CUST_ID
   UNION ALL
  SELECT A.CUST_ID
        ,SUM(A.LOAN_AMT) AS FF_CRDT_TOTAL_LMT
        ,SUM(CASE WHEN SUBSTR(A.LOAN_BIZ_TYP,1,4) NOT IN ('0104','0103','0101') THEN A.LOAN_AMT ELSE 0 END) AS FF_OPR_CRDT_TOT_AMT
        ,SUM(CASE WHEN SUBSTR(A.LOAN_BIZ_TYP,1,4) IN ('0104','0103','0101') THEN A.LOAN_AMT ELSE 0 END) AS FF_CON_CRDT_TOT_AMT
        ,'非网商贷-当月放款当月结清' AS DATA_SRC
    FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO A --表内借据信息
    LEFT JOIN RRP_MDL.M_CRDT_LMT_INFO E --授信额度主表
      ON E.CUST_ID = A.CUST_ID
     AND E.DATA_DT = V_P_DATE
    INNER JOIN RRP_MDL.TMP_DZCP B --特殊客户表
      ON B.CUST_ID = A.CUST_ID
   WHERE NVL(A.LOAN_BIZ_TYP,'0') NOT IN ('90','99') --剔除委托贷款、非标其他债券
     --AND A.SUBJ_ID NOT LIKE '810601%' --不能排除当年放款当年转让的数据
     AND (SUBSTR(A.LOAN_ACT_DSTR_DT,1,6) = SUBSTR(V_P_DATE,1,6) --放款日期等于本月
          OR (A.DATA_SRC = '联合网贷' AND TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')-1))
     --AND (NVL(E.CRDT_TOTAL_LMT,0) = 0 OR E.CUST_ID IS NULL) --当月没关联上的就算
     AND (((SUBSTR(A.LOAN_BIZ_TYP,0,4) = '0102' AND NVL(E.OPR_CRDT_TOT_AMT,0) = 0)--经营产品,经营授信总额为0
          OR (SUBSTR(A.LOAN_BIZ_TYP,0,4) <> '0102' AND (NVL(E.CRDT_TOTAL_LMT,0) - NVL(E.OPR_CRDT_TOT_AMT,0)) = 0))--消费产品，授信总额为0
          OR E.CUST_ID IS NULL) --当月没关联上的就算 消费和经营分开
     AND A.DATA_SRC IN ('零售贷款','联合网贷')
     AND A.LOAN_STD_PROD_ID NOT IN ('202020100001','202020200004')
     AND A.DATA_DT = V_P_DATE
   GROUP BY A.CUST_ID;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '加工零售部分的网商贷客户当月授信';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.WSD_TMP
   (DATA_DT,
    RCPT_ID,
    CUST_ID,
    LOAN_AMT,
    FF_OPR_CRDT_TOT_AMT,
    FF_CON_CRDT_TOT_AMT
    )
  SELECT A.DATA_DT,
         A.RCPT_ID,
         A.CUST_ID,
         A.LOAN_AMT AS LOAN_AMT,
         CASE WHEN SUBSTR(A.LOAN_BIZ_TYP,1,4) NOT IN ('0104','0103','0101') THEN A.LOAN_AMT
              ELSE 0
          END AS FF_OPR_CRDT_TOT_AMT,
         CASE WHEN SUBSTR(A.LOAN_BIZ_TYP,1,4) IN ('0104','0103','0101') THEN A.LOAN_AMT
              ELSE 0
          END AS FF_CON_CRDT_TOT_AMT
    FROM RRP_MDL.S_LOAN A
   WHERE A.LOAN_BAL > 0 --统计一个月内余额不为0的数据
     AND A.DATA_SRC IN ('联合网贷','零售贷款')
     AND SUBSTR(A.DATA_DT,0,6) = SUBSTR(V_P_DATE,0,6); --当月
  COMMIT;

  INSERT INTO RRP_MDL.WSD_TMP
   (DATA_DT,
    RCPT_ID,
    CUST_ID,
    LOAN_AMT,
    FF_OPR_CRDT_TOT_AMT,
    FF_CON_CRDT_TOT_AMT
    )
  SELECT A.DATA_DT,
         A.RCPT_ID,
         A.CUST_ID,
         A.LOAN_AMT AS LOAN_AMT,
         CASE WHEN SUBSTR(A.LOAN_BIZ_TYP,1,4) NOT IN ('0104','0103','0101') THEN A.LOAN_AMT
              ELSE 0
         END AS FF_OPR_CRDT_TOT_AMT,
         CASE WHEN SUBSTR(A.LOAN_BIZ_TYP,1,4) IN ('0104','0103','0101') THEN A.LOAN_AMT
              ELSE 0
         END AS FF_CON_CRDT_TOT_AMT
    FROM RRP_MDL.S_LOAN A
   WHERE A.LOAN_BAL = '0'
     AND A.LOAN_ACT_DSTR_DT = CASE WHEN A.DATA_SRC = '零售贷款' THEN DATA_DT
                                   ELSE TO_CHAR(TO_DATE(DATA_DT,'YYYYMMDD') - 1,'YYYYMMDD')
                               END --当日放款当日结清的数据
     AND A.DATA_SRC IN ('联合网贷','零售贷款')
     AND SUBSTR(A.DATA_DT,0,6) = SUBSTR(V_P_DATE,0,6); --当月
  COMMIT;

  INSERT INTO RRP_MDL.WSD_TMP
   (DATA_DT,
    RCPT_ID,
    CUST_ID,
    LOAN_AMT,
    FF_OPR_CRDT_TOT_AMT,
    FF_CON_CRDT_TOT_AMT
    )
  SELECT A.DATA_DT,
         A.RCPT_ID,
         A.CUST_ID,
         A.LOAN_AMT AS LOAN_AMT,
         0 AS FF_OPR_CRDT_TOT_AMT,
         0 AS FF_CON_CRDT_TOT_AMT
    FROM RRP_MDL.S_LOAN A
   WHERE A.DATA_SRC IN ('对公信贷','票据贴现','票据转贴现')
     AND A.LOAN_NET_VAL <> 0
     AND SUBSTR(A.DATA_DT,0,6) = SUBSTR(V_P_DATE,0,6);

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := 'S7103普惠型消费贷款明细表--加工本月发放的授信总额';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.S_LOAN_AMT_S71_TMP(
    DATA_DT                    ,        --数据日期
    ORG_NO                     ,        --机构号
    CUST_NO                    ,        --客户号
    RCPT_ID                    ,        --借据号
    CONT_ID                    ,        --合同编号
    RCPT_STAT                  ,        --借据状态
    CURR_CD                    ,        --币种
    LOAN_BIZ_TYP               ,        --贷款业务类型
    LOAN_ACT_DSTR_DT           ,        --贷款实际发放日期
    LOAN_ORIG_EXP_DT           ,        --贷款原始到期日期
    LVL5_CL                    ,        --五级分类
    LOAN_AMT                   ,        --放款金额
    LOAN_BAL                   ,        --贷款余额
    LOAN_NET_VAL               ,        --贷款净值
    STD_PROD_ID                ,        --标准产品编号
    LOAN_USEAGE                ,        --贷款用途
    INCOME_ANNUAL              ,        --年化收益
    FF_CRDT_TOTAL_LMT          ,        --发放时授信总额
    FF_OPR_CRDT_TOT_AMT        ,        --发放时经营授信总额
    FF_CON_CRDT_TOT_AMT        ,        --发放时消费授信总额
    CBRC_FLG                   ,        --CBRC标志
    DSBR_FARM_FLG              ,        --放款时农户标志
    OPR_CUST_TYP               ,        --经营性客户类型
    NON_REPY_PRIN_RENEW_FLG    ,        --无还本续贷标志
    LOAN_TERM                  ,        --贷款期限
    TJDBFS                     ,        --统计担保方式
    ENT_SCALE                  ,        --企业规模
    CORP_CUST_TYP              ,        --对公客户类型
    IS_CBRC_ENT                ,        --是否企业（银监）
    LOAN_DIR_BIO_FLG           ,        --贷款投向境内外标识
    TECH_INNO_ENT_FLG          ,        --科创企业标志
    CUST_LRG_CL                ,        --客户大类
    DATA_SRC                   ,        --数据来源
    QTGRFNH                    ,        --其他个人非农户标识
    OVD_LOAN_TERM              ,        --逾期期限
    TECH_ENT_FLG               ,        --科技型企业标志
    INOVT_MED_SIDE_ENTER_FLG   ,        --创新型中小企业标志
    CTY_CORP_TECH_CENTER_FLG   ,        --国家企业技术中心标志
    EACH_CLASS_SCEN_TECH_LIST_CORP_FLG, --各类科技名单企业标志
    TECH_MID_SML_ENT_FLG       ,        --科技型中小企业标志
    YJDLKPKH                   ,        --原建档立卡贫困户标志
    SYS_IN_FLG                 ,        --系统外标志 
    FK_ORG_ID                  ,        --累放层机构号
    EX_SERVSM_FLG              ,        --退役军人标志
    NO_BUSLICS_PRC_FLG         ,        --无营业执照负责人标志
    BGDKLX                     ,        --并购贷款类型
    SFJWBGDK                   ,        --是否境外并购贷款
    SFTYJRCBQY                 ,        --是否退役军人创办企业
    FKSQYGM                    ,        --放款时企业规模
    FKSKGLX                    ,        --放款时控股类型
    FKYQYGM                    ,        --放款月企业规模
    FKYKGLX                             --放款月控股类型            
    )
  --当月发放当月结清且期末没有有效授信的客户行内借据：
  /*业务杨光泽反馈网商贷（'202020100001','202020200004'）的放款月授信额度需特殊计算，规则如下：
  根据网商贷的放款日期，统计该日期下该客户所有贷款余额不为0或当日放款当日结清的借据对应的放款金额
   作为该客户的放款月授信额度*/
    WITH TMP1 AS(--零售联合网贷，放款授信按照客户当月借据放款金额之和算当月授信
  SELECT A.CUST_ID
        ,SUM(A.LOAN_AMT) AS LOAN_AMT
        ,SUM(CASE WHEN SUBSTR(A.LOAN_BIZ_TYP,1,4) NOT IN ('0104','0103','0101')
                  THEN A.LOAN_AMT
                  ELSE 0
              END) AS FF_OPR_CRDT_TOT_AMT
        ,SUM(CASE WHEN SUBSTR(A.LOAN_BIZ_TYP,1,4) IN ('0104','0103','0101')
                  THEN A.LOAN_AMT
                  ELSE 0
              END) AS FF_CON_CRDT_TOT_AMT
    FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO A --表内借据信息
    LEFT JOIN RRP_MDL.M_CRDT_LMT_INFO E --授信额度主表
      ON E.CUST_ID = A.CUST_ID
     AND E.DATA_DT = V_P_DATE
   WHERE NVL(A.LOAN_BIZ_TYP,'0') NOT IN ('90','99') --剔除委托贷款、非标其他债券
     --AND A.SUBJ_ID NOT LIKE '810601%' --不能排除当年放款当年转让的数据
     AND A.DATA_SRC IN ('零售贷款','联合网贷')
     AND (SUBSTR(A.LOAN_ACT_DSTR_DT,1,6) = SUBSTR(V_P_DATE,1,6) --放款日期等于本月
         OR (A.DATA_SRC = '联合网贷' AND TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')-1))
     --AND (NVL(E.CRDT_TOTAL_LMT,0) = 0 OR E.CUST_ID IS NULL) --当月没关联上的就算
     AND (((SUBSTR(A.LOAN_BIZ_TYP,0,4) = '0102' AND NVL(E.OPR_CRDT_TOT_AMT,0) = 0)--经营产品,经营授信总额为0
         OR (SUBSTR(A.LOAN_BIZ_TYP,0,4) <> '0102' AND ( NVL(E.CRDT_TOTAL_LMT,0) - NVL(E.OPR_CRDT_TOT_AMT,0)) = 0))--消费产品，授信总额为0
         OR E.CUST_ID IS NULL) --当月没关联上的就算 消费和经营分开
     AND A.DATA_DT = V_P_DATE
   GROUP BY A.CUST_ID
  /*HAVING SUM(CASE WHEN SUBSTR(A.LOAN_BIZ_TYP,0,4) = '0102' AND NVL(E.OPR_CRDT_TOT_AMT,0) = 0 THEN 1
                    WHEN SUBSTR(A.LOAN_BIZ_TYP,0,4) <> '0102' AND (NVL(E.CRDT_TOTAL_LMT,0) - NVL(E.OPR_CRDT_TOT_AMT,0)) = 0 THEN 1
                    WHEN E.CUST_ID IS NULL THEN 1 ELSE 0 END) > 0*/),
  --新增对公联合网贷逻辑 ADD BY 20250311
    TMP2 AS(--对公，放款授信按照客户借据对应额度合同金额之和算当月授信
  SELECT T.CUST_ID,SUM(T.CONT_AMT) AS CONT_AMT
    FROM (SELECT A.CUST_ID
                ,D.CONT_ID
                ,D.CONT_AMT
            FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO A --表内借据信息
            LEFT JOIN RRP_MDL.M_CRDT_LMT_INFO E --授信额度主表
              ON E.CUST_ID = A.CUST_ID
             AND E.DATA_DT = V_P_DATE
            LEFT JOIN RRP_MDL.M_LOAN_CONT_INFO C -- 业务合同
              ON C.CONT_ID = A.CONT_ID
             AND C.DATA_DT = V_P_DATE
            LEFT JOIN RRP_MDL.M_LOAN_CONT_INFO D -- 额度合同
              ON D.CONT_ID = C.CRDT_LMT_ID
             AND D.DATA_DT = V_P_DATE
           WHERE NVL(A.LOAN_BIZ_TYP,'0') NOT IN ('90','99') --剔除委托贷款、非标其他债券
             AND A.DATA_SRC IN ('对公信贷','票据贴现','对公联合网贷')
             --AND SUBSTR(A.LOAN_ACT_DSTR_DT,1,6) = SUBSTR(V_P_DATE,1,6) --放款日期等于本月
             --新增对公联合网贷逻辑 ADD BY 20250311
             AND (SUBSTR(A.LOAN_ACT_DSTR_DT,1,6) = SUBSTR(V_P_DATE,1,6) --放款日期等于本月
                  OR (A.DATA_SRC = '对公联合网贷'
                     AND TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')-1))             
             AND (NVL(E.CRDT_TOTAL_LMT,0) = 0 OR E.CUST_ID IS NULL) --当月没关联上的就算
             AND A.DATA_DT = V_P_DATE
           GROUP BY A.CUST_ID,D.CONT_ID,D.CONT_AMT) T
   GROUP BY T.CUST_ID),
    TMP3 AS(
    --20230228 调整口径：转贴现虽然调整了客户号，还是需要按照借据对应客户额度统计借据授信总额（按照信贷客户取授信）
    --20230301 又调整口径 转贴现直贴人有授信，取直贴人授信，没有则取借据放款金额
  SELECT BB.DISCNT_CUST_ID,
         SUBSTR(BB.LOAN_ACT_DSTR_DT,0,6) LOAN_ACT_DSTR_DT,
         SUM(BB.LOAN_AMT) LOAN_AMT
    FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO BB --表内借据表M层
   WHERE BB.DATA_SRC = '票据转贴现'
     AND BB.DATA_DT = V_P_DATE
   GROUP BY BB.DISCNT_CUST_ID,SUBSTR(BB.LOAN_ACT_DSTR_DT,0,6)),
    TMP4 AS (
  SELECT A.DATA_DT
        ,A.CUST_ID
        ,SUM(A.LOAN_AMT)  AS LOAN_AMT
        ,SUM(FF_OPR_CRDT_TOT_AMT) AS FF_OPR_CRDT_TOT_AMT
        ,SUM(FF_CON_CRDT_TOT_AMT) AS FF_CON_CRDT_TOT_AMT
    FROM RRP_MDL.WSD_TMP A
   GROUP BY A.DATA_DT,A.CUST_ID),
    TMP5 AS (
  SELECT CUST_ID
        ,SUM(FF_CRDT_TOTAL_LMT)  AS FF_CRDT_TOTAL_LMT
        ,SUM(FF_OPR_CRDT_TOT_AMT) AS FF_OPR_CRDT_TOT_AMT
        ,SUM(FF_CON_CRDT_TOT_AMT) AS FF_CON_CRDT_TOT_AMT    
    FROM RRP_MDL.WSD_HH 
   GROUP BY CUST_ID)
  SELECT A.DATA_DT                           AS DATA_DT               --数据日期
        ,A.ORG_ID                            AS ORG_NO                --机构编号
        ,A.CUST_ID                           AS CUST_NO               --客户编号
        ,A.RCPT_ID                           AS RCPT_ID               --借据编号
        ,A.CONT_ID                           AS CONT_ID               --合同编号
        ,A.RCPT_STAT                         AS RCPT_STAT             --借据状态
        ,A.CUR                               AS CURR_CD               --币种
        ,A.LOAN_BIZ_TYP                      AS LOAN_BIZ_TYP          --贷款业务类型
        ,A.LOAN_ACT_DSTR_DT                  AS LOAN_ACT_DSTR_DT      --贷款实际发放日期
        ,A.LOAN_ORIG_EXP_DT                  AS LOAN_ORIG_EXP_DT      --贷款原始到期日期
        ,A.LVL5_CL                           AS LVL5_CL               --五级分类
        ,A.LOAN_AMT                          AS LOAN_AMT              --放款金额
        ,A.LOAN_BAL                          AS LOAN_BAL              --贷款余额
        ,A.LOAN_NET_VAL                      AS LOAN_NET_VAL          --贷款净值
        ,A.STD_PROD_ID                       AS STD_PROD_ID           --标准产品编号
        ,A.LOAN_USEAGE                       AS LOAN_USEAGE           --贷款用途
        ,A.INCOME_ANNUAL                     AS INCOME_ANNUAL         --年化收益
        --,COALESCE(T3.LOAN_AMT,T2.CONT_AMT,T1.LOAN_AMT,E.CRDT_TOTAL_LMT)
        ,NVL(CASE WHEN T6.CUST_ID = A.CUST_ID THEN T6.FF_CRDT_TOTAL_LMT
                  WHEN A.STD_PROD_ID IN ('202020100001','202020200004') THEN T4.LOAN_AMT
                  WHEN A.DATA_SRC='票据转贴现' THEN NVL(AA.CRDT_TOTAL_LMT_ZT,T3.LOAN_AMT)
                  ELSE CASE WHEN T1.LOAN_AMT <> 0 THEN T1.LOAN_AMT
                            WHEN A.STD_PROD_ID = '203030500015' AND NVL(E.CRDT_TOTAL_LMT_ZT,0) = 0 THEN T5.LOAN_AMT--取不到授信额度的兴付贷取当日放款金额
                            WHEN A.DATA_SRC IN ('对公信贷','票据贴现')--MODIFY BY LWB 20240729
                                AND NVL(E.CRDT_TOTAL_LMT_ZT,0) = 0 THEN A.LMT_CONT_AMT--取不到授信额度的对公信贷取对应额度合同金额
                  WHEN T1.LOAN_AMT = 0 OR T1.LOAN_AMT IS NULL THEN E.CRDT_TOTAL_LMT_ZT
                  ELSE 0 END
              END,0)                         AS FF_CRDT_TOTAL_LMT     --发放时授信总额
        --,COALESCE(T1.FF_OPR_CRDT_TOT_AMT,E.OPR_CRDT_TOT_AMT,0)
        ,NVL(CASE WHEN T6.CUST_ID = A.CUST_ID THEN T6.FF_OPR_CRDT_TOT_AMT
                  WHEN A.STD_PROD_ID IN ('202020100001','202020200004') THEN T4.FF_OPR_CRDT_TOT_AMT
                  ELSE CASE WHEN T1.FF_OPR_CRDT_TOT_AMT <> 0 THEN T1.FF_OPR_CRDT_TOT_AMT
                            WHEN T1.FF_OPR_CRDT_TOT_AMT = 0 OR T1.FF_OPR_CRDT_TOT_AMT IS NULL THEN E.OPR_CRDT_TOT_AMT
                            ELSE 0 END
              END,0)                         AS FF_OPR_CRDT_TOT_AMT   --发放时经营授信总额
       ,NVL(CASE WHEN T6.CUST_ID = A.CUST_ID THEN T6.FF_CON_CRDT_TOT_AMT  
                 WHEN A.STD_PROD_ID IN ('202020100001','202020200004') THEN T4.LOAN_AMT-T4.FF_OPR_CRDT_TOT_AMT 
                 WHEN T1.FF_CON_CRDT_TOT_AMT <> 0 THEN T1.FF_CON_CRDT_TOT_AMT  
                 WHEN T1.FF_CON_CRDT_TOT_AMT = 0 OR T1.FF_CON_CRDT_TOT_AMT IS NULL 
                 THEN NVL(E.CRDT_TOTAL_LMT_ZT,0)- NVL(E.OPR_CRDT_TOT_AMT,0) 
                 ELSE NVL(NVL(E.CRDT_TOTAL_LMT_ZT,0)- NVL(E.OPR_CRDT_TOT_AMT,0),0)
              END,0)                         AS FF_CON_CRDT_TOT_AMT   --发放时消费授信总额
        ,A.CBRC_FLG                          AS CBRC_FLG              --CBRC标志
        ,A.FKSSNBZ                           AS DSBR_FARM_FLG         --放款时农户标志
        /*,A.OPR_CUST_TYP                      AS OPR_CUST_TYP          --经营性客户类型*/
        ,A.FKSKHLX                           AS OPR_CUST_TYP          --经营性客户类型，修改为放款时客户类型MODIFY BY LWB
        ,A.NON_REPY_PRIN_RENEW_FLG           AS NON_REPY_PRIN_RENEW_FLG --无还本续贷标志
        ,A.LOAN_TERM                         AS LOAN_TERM             --贷款期限
        ,A.TJDBFS                            AS TJDBFS                --统计担保方式
        --,A.ENT_SCALE                         AS ENT_SCALE             --企业规模
        ,A.FKYQYGM                           AS ENT_SCALE             --企业规模 MODIFY BY LWB 20240729
        ,A.CORP_CUST_TYP                     AS CORP_CUST_TYP         --对公客户类型
        ,A.IS_CBRC_ENT                       AS IS_CBRC_ENT           --是否企业（银监）
        ,A.LOAN_DIR_BIO_FLG                  AS LOAN_DIR_BIO_FLG      --贷款投向境内外标识
        ,A.TECH_INNO_ENT_FLG                 AS TECH_INNO_ENT_FLG     --科创企业标志
        ,A.CUST_LRG_CL                       AS CUST_LRG_CL           --客户大类
        ,A.DATA_SRC                          AS DATA_SRC              --数据来源
        /*,A.QTGRFNH                           AS QTGRFNH               --其他个人非农户标识*/
        ,CASE WHEN A.STD_PROD_ID IN ('201020100024','201020100014','201020100051','201020100052','201020100064')--MOD BY LWB
                   AND A.FKSKHLX = 'Z' --取放款层的客户类型
                   AND A.FKSSNBZ = 'N' --取放款层农户标识
              THEN '1'
              WHEN A.DATA_SRC = '零售贷款' AND A.FKSSNBZ = 'N' --取放款层农户标识
                   AND A.LOAN_ACT_DSTR_DT > '20250430'
                   --AND B.CUST_CHAR = '其他无营业执照负责人'
                   AND T7.NO_BUSLICS_PRC_FLG = 'Y'
              THEN '1' 
              WHEN A.STD_PROD_ID = '202020200001' AND A.FKSSNBZ = 'N'  --取放款层农户标识
                   AND T7.NO_BUSLICS_PRC_FLG = 'Y'
              THEN '1'                                
              ELSE '0'
          END                                AS QTGRFNH               --其他个人非农户标识 1-是 0-否  MODIFY BY HYF in 20250704
       ,A.OVD_LOAN_TERM                      AS OVD_LOAN_TERM         --逾期期限
       ,A.TECH_ENT_FLG                       AS TECH_ENT_FLG          --科技型企业标志
       ,A.INOVT_MED_SIDE_ENTER_FLG           AS INOVT_MED_SIDE_ENTER_FLG --创新型中小企业标志 ADD BY 20250311
       ,A.CTY_CORP_TECH_CENTER_FLG           AS CTY_CORP_TECH_CENTER_FLG  --国家企业技术中心标志 ADD BY 20250311
       ,A.EACH_CLASS_SCEN_TECH_LIST_CORP_FLG AS EACH_CLASS_SCEN_TECH_LIST_CORP_FLG --各类科技名单企业标志 ADD BY 20250311
       ,A.TECH_MID_SML_ENT_FLG               AS TECH_MID_SML_ENT_FLG  --科技型中小企业标志 ADD BY 20250311  
       ,A.YJDLKPKH                           AS YJDLKPKH              --原建档立卡贫困户标志 ADD BY 20250324 
       ,A.SYS_IN_FLG                         AS SYS_IN_FLG            --系统外标志 ADD BY 20250415  
       ,A.FK_ORG_ID                          AS FK_ORG_ID             --累放层机构号 ADD BY HYF 20250514
       ,A.EX_SERVSM_FLG                      AS EX_SERVSM_FLG         --退役军人标志 ADD BY HYF 20250514
       ,A.NO_BUSLICS_PRC_FLG                 AS NO_BUSLICS_PRC_FLG    --无营业执照负责人标志 ADD BY HYF 20250514 
       ,A.BGDKLX                             AS BGDKLX                --并购贷款类型 ADD BY HYF 20260320
       ,A.OV_SEA_MRG_LOAN_FLG                AS SFJWBGDK              --是否境外并购贷款 ADD BY HYF 20260320
       ,A.SFTYJRCBQY                         AS SFTYJRCBQY            --是否退役军人创办企业 ADD BY HYF 20260320
       ,A.FKSQYGM                            AS FKSQYGM               --放款时企业规模 ADD BY HYF 20260320
       ,A.FKSKGLX                            AS FKSKGLX               --放款时控股类型 ADD BY HYF 20260320
       ,A.FKYQYGM                            AS FKYQYGM               --放款月企业规模 ADD BY HYF 20260320
       ,A.FKYKGLX                            AS FKYKGLX               --放款月控股类型 ADD BY HYF 20260320                
   FROM RRP_MDL.S_LOAN A --表内借据信息S层
   LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO B --表内借据表M层
     ON B.RCPT_ID = A.RCPT_ID
    AND B.DATA_DT = V_P_DATE
   LEFT JOIN RRP_MDL.M_CUST_CORP_INFO C --对公客户信息
     ON C.CUST_ID = NVL(A.CUST_ID,'-')
    AND C.DATA_DT = V_P_DATE
   LEFT JOIN RRP_MDL.M_CRDT_LMT_INFO E --授信额度主表
     ON E.CUST_ID = B.ICMS_CUST_ID -- 取信贷客户
    AND E.DATA_DT = V_P_DATE
   LEFT JOIN RRP_MDL.M_CRDT_LMT_INFO AA
     ON AA.CUST_ID = A.CUST_ID
    AND AA.DATA_DT = A.LOAN_ACT_DSTR_DT
   LEFT JOIN TMP1 T1
     ON T1.CUST_ID = A.CUST_ID --仅零售
   LEFT JOIN TMP2 T2
     ON T2.CUST_ID = A.CUST_ID --对公不含转贴现
   LEFT JOIN TMP3 T3 --MODIFY BY LWB 20240329
     ON T3.DISCNT_CUST_ID = A.CUST_ID --转贴现
    AND T3.LOAN_ACT_DSTR_DT=SUBSTR(a.LOAN_ACT_DSTR_DT,0,6)--精确到月份
   LEFT JOIN TMP4 T4 --MODIFY BY LWB  联合网贷数据T+2，即20230101放款的数据需在20230102才能取到
     ON T4.CUST_ID = A.CUST_ID
    AND T4.DATA_DT = TO_CHAR(TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD')+1,'YYYYMMDD')
   LEFT JOIN TMP4 T5
     ON T5.CUST_ID = A.CUST_ID
    AND T5.DATA_DT = A.LOAN_ACT_DSTR_DT
   LEFT JOIN TMP5 T6 --特殊客户处理
     ON T6.CUST_ID = A.CUST_ID
   LEFT JOIN RRP_MDL.M_CUST_IND_INFO T7 --个人客户信息
      ON T7.CUST_ID = A.CUST_ID
     AND T7.DATA_DT = V_P_DATE
   LEFT JOIN (SELECT A.CUST_ID --客户号
                    ,A.BUSINFOEXISTFLAG --是否有效工商信息
                    ,ROW_NUMBER() OVER (PARTITION BY CUST_ID ORDER BY APP_DT DESC ) AS RN
                FROM RRP_MDL.M_LOAN_APP_INFO A --贷款申请信息
               WHERE A.DATA_DT = V_P_DATE) G
     ON G.CUST_ID = A.CUST_ID
    AND G.RN = 1
  WHERE NVL(A.LOAN_BIZ_TYP,'0') NOT IN ('90','99') --剔除委托贷款、非标其他债券
    --AND NVL(A.CUST_ID,'-') <> '-' --转帖现取不到客户号的剔除
    AND CASE WHEN A.DATA_SRC IN ('零售贷款','联合网贷','对公信贷','票据贴现') THEN '1' ELSE C.CUST_ID END IS NOT NULL
    --MOD BY LIUYU 修复剔除转贴现非ECIF客户数据即可
    AND A.DATA_SRC IN ('零售贷款','联合网贷','对公信贷','票据贴现','票据转贴现')
    AND ((A.DATA_SRC <> '联合网贷' AND SUBSTR(A.LOAN_ACT_DSTR_DT,1,6) = SUBSTR(V_P_DATE,1,6) )
         OR ((A.DATA_SRC = '联合网贷' OR A.STD_PROD_ID = '203050100001') --新增对公联合网贷逻辑 ADD BY 20250311
             AND TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD') >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')-1
             AND TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD') < LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD'))))
    AND A.DATA_DT = V_P_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插数据到目标表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.S_LOAN_AMT_S71( --MODIFY BY LWB
    DATA_DT                    ,        --数据日期
    ORG_NO                     ,        --机构号
    CUST_NO                    ,        --客户号
    RCPT_ID                    ,        --借据号
    CONT_ID                    ,        --合同编号
    RCPT_STAT                  ,        --借据状态
    CURR_CD                    ,        --币种
    LOAN_BIZ_TYP               ,        --贷款业务类型
    LOAN_ACT_DSTR_DT           ,        --贷款实际发放日期
    LOAN_ORIG_EXP_DT           ,        --贷款原始到期日期
    LVL5_CL                    ,        --五级分类
    LOAN_AMT                   ,        --放款金额
    LOAN_BAL                   ,        --贷款余额
    LOAN_NET_VAL               ,        --贷款净值
    STD_PROD_ID                ,        --标准产品编号
    LOAN_USEAGE                ,        --贷款用途
    INCOME_ANNUAL              ,        --年化收益
    FF_CRDT_TOTAL_LMT          ,        --发放时授信总额
    FF_OPR_CRDT_TOT_AMT        ,        --发放时经营授信总额
    FF_CON_CRDT_TOT_AMT        ,        --发放时消费授信总额
    CBRC_FLG                   ,        --CBRC标志
    DSBR_FARM_FLG              ,        --放款时农户标志
    OPR_CUST_TYP               ,        --经营性客户类型
    NON_REPY_PRIN_RENEW_FLG    ,        --无还本续贷标志
    LOAN_TERM                  ,        --贷款期限
    TJDBFS                     ,        --统计担保方式
    ENT_SCALE                  ,        --企业规模
    CORP_CUST_TYP              ,        --对公客户类型
    IS_CBRC_ENT                ,        --是否企业（银监）
    LOAN_DIR_BIO_FLG           ,        --贷款投向境内外标识
    TECH_INNO_ENT_FLG          ,        --科创企业标志
    CUST_LRG_CL                ,        --客户大类
    DATA_SRC                   ,        --数据来源
    QTGRFNH                    ,        --其他个人非农户标识
    OVD_LOAN_TERM              ,        --逾期期限
    TECH_ENT_FLG               ,        --科技型企业标志
    INOVT_MED_SIDE_ENTER_FLG   ,        --创新型中小企业标志
    CTY_CORP_TECH_CENTER_FLG   ,        --国家企业技术中心标志
    EACH_CLASS_SCEN_TECH_LIST_CORP_FLG, --各类科技名单企业标志
    TECH_MID_SML_ENT_FLG       ,        --科技型中小企业标志
    YJDLKPKH                   ,        --原建档立卡贫困户标志
    SYS_IN_FLG                 ,        --系统外标志 
    FK_ORG_ID                  ,        --累放层机构号
    EX_SERVSM_FLG              ,        --退役军人标志
    NO_BUSLICS_PRC_FLG         ,        --无营业执照负责人标志   
    BGDKLX                     ,        --并购贷款类型
    SFJWBGDK                   ,        --是否境外并购贷款
    SFTYJRCBQY                 ,        --是否退役军人创办企业
    FKSQYGM                    ,        --放款时企业规模
    FKSKGLX                    ,        --放款时控股类型
    FKYQYGM                    ,        --放款月企业规模
    FKYKGLX                             --放款月控股类型               
    )
  SELECT DATA_DT                    ,        --数据日期
         ORG_NO                     ,        --机构号
         CUST_NO                    ,        --客户号
         RCPT_ID                    ,        --借据号
         CONT_ID                    ,        --合同编号
         RCPT_STAT                  ,        --借据状态
         CURR_CD                    ,        --币种
         LOAN_BIZ_TYP               ,        --贷款业务类型
         LOAN_ACT_DSTR_DT           ,        --贷款实际发放日期
         LOAN_ORIG_EXP_DT           ,        --贷款原始到期日期
         LVL5_CL                    ,        --五级分类
         LOAN_AMT                   ,        --放款金额
         LOAN_BAL                   ,        --贷款余额
         LOAN_NET_VAL               ,        --贷款净值
         STD_PROD_ID                ,        --标准产品编号
         LOAN_USEAGE                ,        --贷款用途
         INCOME_ANNUAL              ,        --年化收益
         CASE WHEN DATA_SRC IN ('零售贷款','联合网贷') AND FF_OPR_CRDT_TOT_AMT+FF_CON_CRDT_TOT_AMT <> FF_CRDT_TOTAL_LMT 
              THEN FF_OPR_CRDT_TOT_AMT+FF_CON_CRDT_TOT_AMT
              ELSE FF_CRDT_TOTAL_LMT
          END AS FF_CRDT_TOTAL_LMT  ,        --发放时授信总额
         FF_OPR_CRDT_TOT_AMT        ,        --发放时经营授信总额
         FF_CON_CRDT_TOT_AMT        ,        --发放时消费授信总额
         CBRC_FLG                   ,        --CBRC标志
         DSBR_FARM_FLG              ,        --放款时农户标志
         OPR_CUST_TYP               ,        --经营性客户类型
         NON_REPY_PRIN_RENEW_FLG    ,        --无还本续贷标志
         LOAN_TERM                  ,        --贷款期限
         TJDBFS                     ,        --统计担保方式
         ENT_SCALE                  ,        --企业规模
         CORP_CUST_TYP              ,        --对公客户类型
         IS_CBRC_ENT                ,        --是否企业（银监）
         LOAN_DIR_BIO_FLG           ,        --贷款投向境内外标识
         TECH_INNO_ENT_FLG          ,        --科创企业标志
         CUST_LRG_CL                ,        --客户大类
         DATA_SRC                   ,        --数据来源
         QTGRFNH                    ,        --其他个人非农户标识
         OVD_LOAN_TERM              ,        --逾期期限
         TECH_ENT_FLG               ,        --科技型企业标志
         INOVT_MED_SIDE_ENTER_FLG   ,        --创新型中小企业标志
         CTY_CORP_TECH_CENTER_FLG   ,        --国家企业技术中心标志
         EACH_CLASS_SCEN_TECH_LIST_CORP_FLG, --各类科技名单企业标志
         TECH_MID_SML_ENT_FLG       ,        --科技型中小企业标志
         YJDLKPKH                   ,        --原建档立卡贫困户标志
         SYS_IN_FLG                 ,        --系统外标志 
         FK_ORG_ID                  ,        --累放层机构号
         EX_SERVSM_FLG              ,        --退役军人标志
         NO_BUSLICS_PRC_FLG         ,        --无营业执照负责人标志 
         BGDKLX                     ,        --并购贷款类型
         SFJWBGDK                   ,        --是否境外并购贷款
         SFTYJRCBQY                 ,        --是否退役军人创办企业
         FKSQYGM                    ,        --放款时企业规模
         FKSKGLX                    ,        --放款时控股类型
         FKYQYGM                    ,        --放款月企业规模
         FKYKGLX                             --放款月控股类型           
    FROM RRP_MDL.S_LOAN_AMT_S71_TMP;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --记录正常日志
  V_STEP := V_STEP + 1;
  V_STEP_DESC := 'S71普惠小微发放时授信额度表--查询数据是否重复';
  V_STARTTIME := SYSDATE;
    WITH TMP1 AS (
  SELECT DATA_DT,RCPT_ID,COUNT(1)
    FROM RRP_MDL.S_LOAN_AMT_S71 T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,RCPT_ID
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

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

END ETL_S_LOAN_AMT_S71;
/

