CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_MRPT_GUA_LOAN_DTL(I_P_DATE IN INTEGER,
                       O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_MRPT_GUA_LOAN_DTL
  *  功能描述：担保贷款明细数据
  *  创建日期：2022/12/29
  *  开发人员：HDY
  *  来源表：  RRP_MDL.O_ICL_CMM_GUAR_CONT                 担保合同
               RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO       对公贷款合同信息
               RRP_MDL.O_ICL_CMM_LOAN_GUAR_CONT_RELA       贷款合同与担保合同关系
               RRP_MDL.M_LOAN_IN_DUBILL_INFO               表内借据信息
               RRP_MDL.M_CRDT_LMT_INFO                     授信额度主表
               RRP_MDL.M_CUST_CORP_INFO                    对公客户信息
               RRP_MDL.M_CUST_IND_INFO                     个人客户信息
               RRP_MDL.O_ICL_CMM_RETL_LOAN_REPAY_DTL       零售贷款还款明细
               RRP_MDL.O_ICL_CMM_CORP_LOAN_REPAY_DTL       对公贷款还款明细
               RRP_MDL.M_PUM_ORG_INFO                      机构表

  *  目标表：  RRP_MDL.M_MRPT_GUA_LOAN_DTL
  *
  *  配置表：  RRP_MDL.M_ZFXRZDBJGMD)                      政府性融资担保机构名单
  *  修改情况：1  2022/12/29  HDY   首次创建
  *
  ***************************************************************************/
  AS
  -- 定义变量 --
  I_STEP        INTEGER := 0;   -- 处理步骤
  I_SQLCOUNT    INTEGER := 0;   -- 更新或删除影响的记录数
  V_STEP_DESC   VARCHAR2(100);  -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(100) := 'ETL_M_MRPT_GUA_LOAN_DTL' ;-- 程序名称
  V_P_DATE      VARCHAR2(8);    -- 跑批数据日期
  V_SQLMSG      VARCHAR2(300);  -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);   -- 来源系统
  V_SQL         VARCHAR2(2000); -- 动态sql
  V_TAB_NAME    VARCHAR2(100);  --表名称
  D_STARTTIME   DATE;
  D_P_DATE      DATE;           --跑批日期
  V_Y_DATE      VARCHAR2(8);    --年初日期
  D_Y_DATE      DATE;           --年初日期
   V_FREQ_FLAG   VARCHAR2(10);    --跑批频度标识


BEGIN

  O_ERRCODE := '0';
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  D_P_DATE := TO_DATE(V_P_DATE,'YYYYMMDD'); --获取跑批日期
  V_Y_DATE := TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y'),'YYYYMMDD'); --获取年初日期
  D_Y_DATE := TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y');                     --获取年初日期
  V_SYSTEM := '监管报送';          -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_MRPT_GUA_LOAN_DTL'; --表名称

  --跑批频率
  V_FREQ_FLAG := FUN_FREQ(V_P_DATE, V_PROC_NAME);
  IF V_FREQ_FLAG = '1' THEN

 -- 支持重跑 --
  I_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  D_STARTTIME := SYSDATE;

  V_SQL := 'TRUNCATE TABLE RRP_MDL.M_MRPT_GUA_LOAN_DTL_TMP01'; --清空临时表
  EXECUTE IMMEDIATE V_SQL;

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP := 2;
  V_STEP_DESC := '--数据插入临时表--';
  D_STARTTIME := SYSDATE;

  INSERT INTO RRP_MDL.M_MRPT_GUA_LOAN_DTL_TMP01
            (
               DATA_DT           --01 数据日期
              ,ORG_NUM           --02 管理机构编号
              ,GUARTOR_ID        --03 担保机构编号
              ,GUARTOR_NAME      --04 担保机构名称
              ,CONT_ID           --05 贷款合同号
              ,RCPT_ID           --06 贷款借据号
              ,CUST_ID           --07 被担保人编号
              ,DISTR_AMT         --08 放款金额
              ,DISTR_DT          --09 放款日期
              ,LOAN_BAL          --10 贷款余额
              ,LOAN_ACT_EXP_DT   --11 贷款实际到期日期
              ,GUA_MODE          --12 担保方式
              ,DATA_SRC          --13 数据来源
              ,OVD_DAYS          --14 逾期天数
              ,LVL5_CL           --15 五级分类
              ,GUAR_WAY_CD       --16 担保方式
            )
       SELECT V_P_DATE AS DATA_DT      --01 数据日期
              ,NVL(A.DIRECTOR_ORG_ID,C.ORG_ID) ORG_NUM   --02 管理机构编号
              ,A.GUARTOR_ID            --03 担保机构编号
              ,A.GUARTOR_NAME          --04 担保机构名称
              ,B.LOAN_CONT_ID CONT_ID  --05 贷款合同号
              ,C.RCPT_ID               --06 贷款借据号
              ,A.CUST_ID               --07 被担保人编号
              ,C.DISTR_AMT             --08 放款金额
              ,C.DISTR_DT              --09 放款日期
              ,C.LOAN_BAL              --10 贷款余额
              ,C.LOAN_ACT_EXP_DT       --11 贷款实际到期日期
              ,C.GUA_MODE              --12 担保方式
              ,C.DATA_SRC              --13 数据来源
              ,C.OVD_DAYS              --14 逾期天数
              ,C.LVL5_CL               --15 五级分类
              ,CASE WHEN C.GUA_MODE = '1' THEN '抵押'
                    WHEN C.GUA_MODE = '2' THEN '质押(含保证金)'
                    WHEN C.GUA_MODE = '3' THEN '保证'
                    WHEN C.GUA_MODE = '4' THEN '信用/免担保贷款'
               END AS GUAR_WAY_CD
         FROM RRP_MDL.O_ICL_CMM_GUAR_CONT A --担保合同
         LEFT JOIN RRP_MDL.O_ICL_CMM_LOAN_GUAR_CONT_RELA B --贷款合同与担保合同关系
                ON A.GUAR_CONT_ID = B.GUAR_CONT_ID
               AND A.ETL_DT = B.ETL_DT
         LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO C         --表内借据信息
                ON B.LOAN_CONT_ID = C.CONT_ID
               AND C.DATA_DT = V_P_DATE
        WHERE A.ETL_DT = D_P_DATE
          AND A.GUARTOR_NAME LIKE '%担保%'
          AND A.STATUS_CD IN ('101', '112')
          AND C.LOAN_ACT_EXP_DT >= V_Y_DATE
        UNION
       SELECT V_P_DATE AS DATA_DT     --01 数据日期
              ,NVL(C.DIRECTOR_ORG_ID,D.ORG_ID) ORG_NUM --02 管理机构编号
              ,C.GUARTOR_ID           --03 担保机构编号
              ,C.GUARTOR_NAME         --04 担保机构名称
              ,A.CONT_ID              --05 贷款合同号
              ,D.RCPT_ID              --06 贷款借据号
              ,C.CUST_ID              --07 被担保人编号
              ,D.DISTR_AMT            --08 放款金额
              ,D.DISTR_DT             --09 放款日期
              ,D.LOAN_BAL             --10 贷款余额
              ,D.LOAN_ACT_EXP_DT      --11 贷款实际到期日期
              ,D.GUA_MODE             --12 担保方式
              ,D.DATA_SRC             --13 数据来源
              ,D.OVD_DAYS             --14 逾期天数
              ,D.LVL5_CL              --15 五级分类
              ,CASE WHEN D.GUA_MODE = '1' THEN '抵押'
                    WHEN D.GUA_MODE = '2' THEN '质押(含保证金)'
                    WHEN D.GUA_MODE = '3' THEN '保证'
                    WHEN D.GUA_MODE = '4' THEN '信用/免担保贷款'
               END AS GUAR_WAY_CD
         FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO A      --对公贷款合同信息
         LEFT JOIN RRP_MDL.O_ICL_CMM_LOAN_GUAR_CONT_RELA B --贷款合同与担保合同关系
                ON A.LMT_CONT_ID = B.LOAN_CONT_ID
               AND A.ETL_DT = B.ETL_DT
         LEFT JOIN RRP_MDL.O_ICL_CMM_GUAR_CONT C          --担保合同表
                ON B.GUAR_CONT_ID = C.GUAR_CONT_ID
               AND B.ETL_DT = C.ETL_DT
         LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO D        --表内借据信息
                ON A.CONT_ID = D.CONT_ID
               AND D.DATA_DT = V_P_DATE
        WHERE A.ETL_DT = D_P_DATE
          AND C.GUARTOR_NAME LIKE '%担保%'
          AND C.STATUS_CD IN ('101', '112')
          AND D.LOAN_ACT_EXP_DT >= V_Y_DATE;

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP := 3;
  V_STEP_DESC := '--把表内借据数据插入临时表--';
  D_STARTTIME := SYSDATE;

  INSERT INTO RRP_MDL.M_MRPT_GUA_LOAN_DTL_TMP01
            (
               DATA_DT           --01 数据日期
              ,ORG_NUM           --02 管理机构编号
              ,GUARTOR_ID        --03 担保机构编号
              ,GUARTOR_NAME      --04 担保机构名称
              ,CONT_ID           --05 贷款合同号
              ,RCPT_ID           --06 贷款借据号
              ,CUST_ID           --07 被担保人编号
              ,DISTR_AMT         --08 放款金额
              ,DISTR_DT          --09 放款日期
              ,LOAN_BAL          --10 贷款余额
              ,LOAN_ACT_EXP_DT   --11 贷款实际到期日期
              ,GUA_MODE          --12 担保方式
              ,DATA_SRC          --13 数据来源
              ,OVD_DAYS          --14 逾期天数
              ,LVL5_CL           --15 五级分类
              ,GUAR_WAY_CD
            )
     SELECT   V_P_DATE AS DATA_DT  --01 数据日期
              ,A.ORG_ID            --02 管理机构编号
              ,'' AS GUARTOR_ID    --03 担保机构编号
              ,'广东中盈盛达融资担保投资股份有限公司' GUARTOR_NAME --04 担保机构名称
              ,A.CONT_ID           --05 贷款合同号
              ,A.RCPT_ID           --06 贷款借据号
              ,A.CUST_ID           --07 被担保人编号
              ,A.DISTR_AMT         --08 放款金额
              ,A.DISTR_DT          --09 放款日期
              ,A.LOAN_BAL          --10 贷款余额
              ,A.LOAN_ACT_EXP_DT   --11 贷款实际到期日期
              ,A.GUA_MODE          --12 担保方式
              ,A.DATA_SRC          --13 数据来源
              ,A.OVD_DAYS          --14 逾期天数
              ,A.LVL5_CL           --15 五级分类
              ,CASE WHEN A.GUA_MODE = '1' THEN '抵押'
                    WHEN A.GUA_MODE = '2' THEN '质押(含保证金)'
                    WHEN A.GUA_MODE = '3' THEN '保证'
                    WHEN A.GUA_MODE = '4' THEN '信用/免担保贷款'
               END AS GUAR_WAY_CD
         FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO A  --表内借据信息
        WHERE A.LOAN_PROD_NM  ='新心金融小微贷'
          AND A.DATA_DT = V_P_DATE
          AND A.RCPT_ID NOT IN (SELECT RCPT_ID FROM M_MRPT_GUA_LOAN_DTL_TMP01 A WHERE A.DATA_DT = V_P_DATE);

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP := 4;
  V_STEP_DESC := '-- 增加分区 --';
  D_STARTTIME := SYSDATE;

  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE); --增加分区

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP := 5;
  V_STEP_DESC := '--把数据插入广东辖内银行业金融机构与融资担保公司担保贷款表--';
  D_STARTTIME := SYSDATE;

  INSERT INTO RRP_MDL.M_MRPT_GUA_LOAN_DTL
            (  DATA_DT                 --01 数据日期
              ,ORG_NUM                 --02 机构编号
              ,ORG_NAME                --03 所属分行
              ,GUARTOR_ID              --04 担保机构编号
              ,GUARTOR_NAME            --05 担保机构名称
              ,CONT_ID                 --06 贷款合同号
              ,RCPT_ID                 --07 贷款借据号
              ,CUST_ID                 --08 客户编号
              ,DISTR_AMT               --09 放款金额
              ,DISTR_DT                --10 放款日期
              ,LOAN_BAL                --11 贷款余额
              ,LOAN_ACT_EXP_DT         --12 贷款到期日期
              ,GUA_MODE                --13 担保方式
              ,DATA_SRC                --14 归属部门
              ,OVD_DAYS                --15 逾期天数
              ,LVL5_CL                 --16 五级分类代码
              ,ENT_SCALE               --17 企业规模
              ,CRDT_TOTAL_LMT          --18 授信总额度
              ,ZFXDBJG                 --19 政府性融资担保机构标记
              ,SN_FLG                  --20 农户或新型农业经营主体标记
              ,NLJHK                   --21 年累计还款
              ,GUAR_WAY_CD
       )
     SELECT    V_P_DATE AS DATA_DT  --01 数据日期
              ,A.ORG_NUM            --02 管理机构编号
              ,F.ORG_NM             --03 机构名称
              ,A.GUARTOR_ID         --04 担保机构编号
              ,A.GUARTOR_NAME       --05 担保机构名称
              ,A.CONT_ID            --06 贷款合同号
              ,A.RCPT_ID            --07 贷款借据号
              ,A.CUST_ID            --08 被担保人编号
              ,A.DISTR_AMT          --09 放款金额
              ,A.DISTR_DT           --10 放款日期
              ,A.LOAN_BAL           --11 贷款余额
              ,A.LOAN_ACT_EXP_DT    --12 贷款实际到期日期
              ,A.GUA_MODE           --13 担保方式
              ,A.DATA_SRC           --14 数据来源
              ,A.OVD_DAYS           --15 逾期天数
              ,A.LVL5_CL            --16 五级分类
              ,D.ENT_SCALE          --17 企业规模
              ,B.CRDT_TOTAL_LMT     --18 授信总额度
              ,C.FLG ZFXDBJG        --19 政府性融资担保机构标记
              ,CASE WHEN A.DATA_SRC = '零售贷款' THEN E.FARM_FLG
                    WHEN A.DATA_SRC = '对公贷款' THEN D.FAMILY_FARM_FLG
                     END AS SN_FLG  --20 农户或新型农业经营主体标记
              ,CASE WHEN A.DATA_SRC = '零售贷款' THEN RTL.LSHK
                    WHEN A.DATA_SRC = '对公贷款' THEN CORP.DGHK
                    END AS NLJHK    --21 年累计还款
              ,A.GUAR_WAY_CD
         FROM RRP_MDL.M_MRPT_GUA_LOAN_DTL_TMP01 A
    LEFT JOIN (SELECT CUST_ID, SUM(CRDT_TOTAL_LMT) CRDT_TOTAL_LMT
                 FROM RRP_MDL.M_CRDT_LMT_INFO    --授信额度主表
                WHERE CRDT_STAT = 'Y'            --授信额度是否有效
                  AND DATA_DT = V_P_DATE
                GROUP BY CUST_ID) B
           ON A.CUST_ID = B.CUST_ID
    LEFT JOIN (SELECT DISTINCT GUARTOR_ID_K,FLG
                 FROM RRP_MDL.M_ZFXRZDBJGMD) C   --政府性融资担保机构名单
           ON A.GUARTOR_ID = C.GUARTOR_ID_K
          AND A.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_CUST_CORP_INFO D         --对公客户信息
           ON A.CUST_ID  = D.CUST_ID
          AND A.DATA_DT  = V_P_DATE
          AND A.DATA_SRC = '对公贷款'
    LEFT JOIN RRP_MDL.M_CUST_IND_INFO E          --个人客户信息
           ON A.CUST_ID  = E.CUST_ID
          AND A.DATA_DT  = V_P_DATE
          AND A.DATA_SRC = '零售贷款'
    LEFT JOIN (SELECT DUBIL_ID,CUST_ID,SUM(CURRT_REPAY_PRIC) LSHK
                 FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_REPAY_DTL  --零售贷款还款明细
                WHERE ETL_DT >= D_Y_DATE
                GROUP BY DUBIL_ID, CUST_ID) RTL
           ON A.CUST_ID = RTL.CUST_ID
          AND A.RCPT_ID = RTL.DUBIL_ID
          AND A.DATA_SRC = '零售贷款'
          AND A.DATA_DT  = V_P_DATE
    LEFT JOIN (SELECT DUBIL_ID,CUST_ID,SUM(CURRT_REPAY_PRIC) DGHK
               FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_REPAY_DTL  --对公贷款还款明细
                WHERE ETL_DT >= D_Y_DATE
                GROUP BY DUBIL_ID, CUST_ID) CORP
           ON A.CUST_ID = CORP.CUST_ID
          AND A.RCPT_ID = CORP.DUBIL_ID
          AND A.DATA_SRC = '对公贷款'
          AND A.DATA_DT  = V_P_DATE
    LEFT JOIN RRP_MDL.M_PUM_ORG_INFO F                       --机构表
           ON A.ORG_NUM = F.ORG_ID
          AND F.DATA_DT = V_P_DATE
   WHERE A.DATA_DT = V_P_DATE
     AND A.DATA_SRC = '零售贷款'
      OR A.GUA_MODE NOT IN ('2')
      ;

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;

  --程序结束标记
  I_STEP := 6;
  V_STEP_DESC := '-- 程序跑批结束 --';
  O_ERRCODE  := '0';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,'');
  
  END IF;

--异常处理
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    I_STEP := 7;
    V_STEP_DESC := '-- 程序跑批异常 --';
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_MRPT_GUA_LOAN_DTL;
/

