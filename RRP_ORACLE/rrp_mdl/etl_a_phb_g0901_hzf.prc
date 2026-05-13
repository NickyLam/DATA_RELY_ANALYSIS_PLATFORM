CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_A_PHB_G0901_HZF
(I_P_DATE IN INTEGER,
 O_ERRCODE OUT VARCHAR2
)
  /**************************************************************************
  *  程序名称：ETL_A_PHB_G0901_HZF
  *  功能描述：零售_互联网合作方小基表
  *  创建日期：20221110
  *  开发人员：韦永钊
  *  来源表：
  *  目标表：A_PHB_G0901_HZF --零售_互联网合作方小基表
  *  配置表：CODE_MAP
  *  修改情况：
  *  序号  修改日期   修改人            修改原因
  *  001   20221110   weiyongzhao       创建过程
  *  002   20230523   weiyongzhao       优化出数逻辑，产品编号不能写死，改从配置表出
  *  003   20230919   lwb               调整出资比例的出数逻辑，新增统计担保方式字段
  *  004   20231115   LWB               新增实际贷款利率收入字段，用于报送G0902/G0903
  *  005   20251203   HYF               调整出数逻辑，不从配置表出数
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;     -- 处理步骤
  V_PROC_NAME  VARCHAR2(30) := 'ETL_A_PHB_G0901_HZF';
                                 -- 程序名称
  V_P_DATE     VARCHAR2(8);      -- 跑批数据日期
  V_STARTTIME  DATE;             -- 处理开始时间
  V_ENDTIME    DATE;             -- 处理结束时间
  V_SQLCOUNT   INTEGER := 0;     -- 更新或删除影响的记录数
  V_SQLMSG     VARCHAR2(300);    -- SQL执行描述信息
  V_SYSTEM     VARCHAR2(30);     -- 来源系统
  V_STEP_DESC  VARCHAR2(200);    --任务名称
  V_TAB_NAME VARCHAR2(100) ; --表名
  V_PART_NAME VARCHAR2(100); --分区名
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE     := TO_CHAR(I_P_DATE);  -- 获取跑批日期
  V_SYSTEM     := '监管报送';           -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME   := 'A_PHB_G0901_HZF'; --表名,写目标表表名
  V_PART_NAME  := 'PARTITION_'||V_P_DATE; --V_P_DATE 当前日期


  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_A_PHB_G0901_HZF_1';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_A_PHB_G0901_HZF_2';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 分区表分区处理 --
   V_STEP := V_STEP + 1;
   V_STEP_DESC := '分区处理';
   V_STARTTIME := SYSDATE;

   ETL_PARTITION_ADD(V_P_DATE, V_TAB_NAME, '1', O_ERRCODE);

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '临时数据处理1';
  V_STARTTIME := SYSDATE;

  INSERT /*+APPEND*/ INTO RRP_MDL.TMP_A_PHB_G0901_HZF_1 NOLOGGING
    (
        BGRQ              --报告日期
       ,HZFS              --合作方式
       ,HZFWYM            --合作方唯一码
       ,HZJGMC            --合作机构名称
       ,SHXYDM            --社会信用代码
       ,HZJGLB            --合作机构类别
       ,TGFWLX            --提供服务类型
       ,HLWDKYTLB         --互联网贷款用途类别
       ,BHCZBL            --本行出资比例
       ,HZFCZBL           --合作方出资比例
       ,TJYE              --统计余额（元）
       ,HZFFKYE           --合作方放款余额（元）
       ,HLWDKFKYE         --互联网贷款放款余额（元）
       ,BLDKYE            --不良贷款余额（元）
       ,BLDKL             --不良贷款率（%）
       ,YQ30TYSDKJE       --逾期30天以上贷款金额
       ,GTCZFFDKYQL       --共同出资发放贷款逾期率（逾期30天以上）（%）
       ,DKPJLL            --贷款平均利率（%）
       ,ZXLB              --增信类别
       ,ZFHZFFY           --支付合作方费用（元）
       ,ZFDBZXFY          --支付担保增信费用（元）
       ,BNLXSY            --本年利息收益（元）
       ,TJDBFS            --统计担保方式
       ,TJYE_ACT          --实际贷款利率收入
       ,ZWJGBH            --账务机构编号
       ,TGFWLX_G0902      --提供服务类型_G0902
       ,TGFWLX_G0903      --提供服务类型_G0903
    )
WITH TMP_GROUP AS (--去重
    SELECT /*+ MATERIALIZE*/A.COOP_AGRT_ID||PNR_TYP AS COOP_ID,
           A.COOP_AGRT_ID,A.PNR_NM,A.PNR_CRDL_NO,A.PNR_TYP,A.INCRE_CRDT_MODE_CD,A.COOP_MODE
      FROM RRP_MDL.M_LOAN_NET_COOP_SUB A --互联网贷款合作协议表
     WHERE DATA_DT = V_P_DATE 
     GROUP BY A.COOP_AGRT_ID,A.PNR_NM,A.PNR_CRDL_NO,A.PNR_TYP,A.COOP_MODE,A.INCRE_CRDT_MODE_CD),
  TMP_SPLIT_CN AS (SELECT /*+ MATERIALIZE*/COOP_ID , LENGTH(COOP_MODE)-LENGTH(REGEXP_REPLACE(COOP_MODE, ';', ''))+1 RN FROM TMP_GROUP ),--看有多少个要拆
  TMP_SPLIT_MAX AS (SELECT /*+ MATERIALIZE*/ROWNUM CRN FROM TMP_GROUP CONNECT BY ROWNUM<=(SELECT MAX(RN) SM FROM TMP_SPLIT_CN)), --拆
  TMP_G0902 AS (--转码并排序合并
     SELECT  /*+ MATERIALIZE*/A.COOP_AGRT_ID,A.PNR_NM,A.PNR_CRDL_NO,A.PNR_TYP,A.INCRE_CRDT_MODE_CD,A.COOP_MODE,
             LISTAGG(DISTINCT D.TAR_VALUE_CODE,'') WITHIN GROUP (ORDER BY D.TAR_VALUE_CODE) AS TGFWLX_G0902
       FROM TMP_GROUP A,TMP_SPLIT_MAX B,TMP_SPLIT_CN C,
            RRP_MDL.CODE_MAP D
      WHERE A.COOP_ID = C.COOP_ID
        AND C.RN >=B.CRN
        AND REGEXP_SUBSTR(COOP_MODE,'[^;]+',1,CRN) = D.SRC_VALUE_CODE
        AND D.MOD_FLG = 'G0902'
      GROUP BY A.COOP_AGRT_ID,A.PNR_NM,A.PNR_CRDL_NO,A.PNR_TYP,A.INCRE_CRDT_MODE_CD,A.COOP_MODE
      ORDER BY A.COOP_AGRT_ID),
 TMP_G0903 AS (--转码并排序合并
   SELECT  /*+ MATERIALIZE*/A.COOP_AGRT_ID,A.PNR_NM,A.PNR_CRDL_NO,A.PNR_TYP,A.INCRE_CRDT_MODE_CD,A.COOP_MODE,
           LISTAGG(DISTINCT D.TAR_VALUE_CODE,'') WITHIN GROUP (ORDER BY D.TAR_VALUE_CODE) AS TGFWLX_G0903
     FROM TMP_GROUP A,TMP_SPLIT_MAX B,TMP_SPLIT_CN C,
          RRP_MDL.CODE_MAP D
    WHERE A.COOP_ID = C.COOP_ID
      AND C.RN >=B.CRN
      AND REGEXP_SUBSTR(COOP_MODE,'[^;]+',1,CRN) = D.SRC_VALUE_CODE
      AND D.MOD_FLG = 'G0903'
    GROUP BY A.COOP_AGRT_ID,A.PNR_NM,A.PNR_CRDL_NO,A.PNR_TYP,A.INCRE_CRDT_MODE_CD,A.COOP_MODE
    ORDER BY A.COOP_AGRT_ID),
  TMP_AGRT AS (    
 SELECT /*+USE_HASH(A,B)*/
        A.COOP_AGRT_ID,A.PNR_NM,A.PNR_CRDL_NO,A.PNR_TYP
       ,A.COOP_MODE ,A.INCRE_CRDT_MODE_CD ZXLB,A.TGFWLX_G0902,B.TGFWLX_G0903
   FROM TMP_G0902 A,TMP_G0903 B
  WHERE A.COOP_AGRT_ID = B.COOP_AGRT_ID
    AND A.PNR_CRDL_NO = B.PNR_CRDL_NO),
TMP_CONT_COOP_AGRT_ID AS (
    SELECT COOP_AGRT_ID
      FROM RRP_MDL.M_LOAN_CONT_INFO 
     WHERE DATA_DT = V_P_DATE
     GROUP BY COOP_AGRT_ID ),
  TMP_COOP_AGRT_ID AS (
    SELECT C.COOP_AGRT_ID,REGEXP_SUBSTR(C.COOP_AGRT_ID, '[^;]+', 1, LEVEL) COOP_AGRT_ID_ST 
    FROM TMP_CONT_COOP_AGRT_ID C 
     CONNECT BY LEVEL <= LENGTH(C.COOP_AGRT_ID) - LENGTH(REPLACE(C.COOP_AGRT_ID, ';')) + 1
     GROUP BY C.COOP_AGRT_ID,REGEXP_SUBSTR(C.COOP_AGRT_ID, '[^;]+', 1, LEVEL)),
    LOAN_CONT_INFO_TMP AS (
    SELECT T1.CONT_ID,MAX(T3.PNR_NM) HZFMC,MAX(T3.PNR_CRDL_NO) HZFWYM
          ,MAX(T3.PNR_TYP) HLWDKHZJGLB,MAX(T3.COOP_MODE) HZJGTGFWLX,MAX(T3.ZXLB) ZXLB
          ,MAX(T3.TGFWLX_G0902) TGFWLX_G0902,MAX(T3.TGFWLX_G0903) TGFWLX_G0903
      FROM RRP_MDL.S_LOAN T1
      LEFT JOIN RRP_MDL.M_LOAN_CONT_INFO T2 ON T2.CONT_ID = T1.CONT_ID AND T2.DATA_DT = V_P_DATE
      LEFT JOIN TMP_COOP_AGRT_ID T4 ON T4.COOP_AGRT_ID = T2.COOP_AGRT_ID
      LEFT JOIN TMP_AGRT T3 ON T3.COOP_AGRT_ID = T4.COOP_AGRT_ID_ST
      WHERE T1.NET_LOAN_FLG = 'Y'
       AND T1.DATA_DT = V_P_DATE
    GROUP BY T1.CONT_ID)        
  SELECT    V_P_DATE                              AS BGRQ                      -- 报告日期
/*           ,CASE WHEN T2.HZFS = '01'   THEN '联合贷'  --联合贷
                  WHEN T2.HZFS = '02' THEN '本行助贷'  --本行助贷 无业务
                  WHEN T2.HZFS = '03' THEN '助贷本行'  --助贷本行
             END                                   AS HZFS                      -- 合作方式*/
           ,T1.HZFS                                AS HZFS                      -- 合作方式 MOD BY 20251203
           ,T2.HZFWYM                              AS HZFWYM                    -- 合作方唯一码
           ,T2.HZFMC                               AS HZJGMC                    -- 合作机构名称
           ,T2.HZFWYM                              AS SHXYDM                    -- 社会信用代码
           ,M1.TAR_VALUE_NAME                      AS HZJGLB                    -- 合作机构类别
           ,T2.HZJGTGFWLX                          AS TGFWLX                    --提供服务类型
           ,T1.HLWDKYTLB                             AS HLWDKYTLB               --互联网贷款用途类别 MOD BY 20251203
           ,T1.BHCZBL                                AS BHCZBL                  --本行出资比例 MOD BY 20251203          
           ,T1.HZJGCZBL                              AS HZFCZBL                -- 合作机构出资比例  MOD BY 20251203         
           ,SUM(T1.LOAN_NET_VAL * U.EXRT)            AS TJYE                      -- 统计余额（元）
           ,SUM(CASE WHEN NVL(T1.BHCZBL,0) * NVL(T1.HZJGCZBL,0) = 0 THEN 0 ELSE 
                T1.LOAN_NET_VAL * U.EXRT/ (NVL(T1.BHCZBL,0)  * NVL(T1.HZJGCZBL,0)) END)                
                                                     AS HZFFKYE                   -- 合作方放款余额（元） MOD BY 20251203
           ,SUM(CASE WHEN NVL(T1.BHCZBL,0) = 0 THEN 0 
                ELSE T1.LOAN_NET_VAL * U.EXRT/ NVL(T1.BHCZBL,0)  END ) AS HLWDKFKYE                 -- 互联网贷款放款余额（元） MOD BY 20251203
           ,SUM(CASE WHEN T1.LVL5_CL IN ('03','04','05') THEN T1.LOAN_NET_VAL * U.EXRT ELSE 0 END)
                                                     AS BLDKYE                    -- 不良贷款余额（元）
           ,CASE WHEN SUM(NVL(T1.LOAN_NET_VAL,0) * U.EXRT)=0 THEN 0 ELSE
            SUM(CASE WHEN T1.LVL5_CL IN ('03','04','05') THEN T1.LOAN_NET_VAL * U.EXRT ELSE 0 END)
            /SUM(T1.LOAN_NET_VAL * U.EXRT)* 100  END     AS BLDKL                     -- 不良贷款率（%）
           ,SUM(CASE WHEN T1.OVD_DAYS >30 THEN
                    CASE WHEN T1.OVD_DAYS > 0 AND T1.OVD_DAYS <= 90
                            AND SUBSTR(T1.LOAN_BIZ_TYP, 1, 4) IN ('0101', '0103', '0104', '0199')
                            AND T1.GXH_PAY_FREQ IN ('M','03') --按月还款
                            AND T1.GXH_PAY_TYPE IN ('1','2','6','7','8','9','11')  --根据发文，按月分期还款的个人消费贷款90天以上取逾期本金    --1等额本息 2等额本金 6气球贷 7等额累进 8等比累进 9等本等息 11按比例还本
                       THEN T1.OVD_PRIN_BAL * U.EXRT
                       ELSE T1.LOAN_NET_VAL * U.EXRT
                     END
                   ELSE 0
                  END)                               AS YQ30TYSDKJE               -- 逾期30天以上贷款金额
           ,CASE WHEN SUM(NVL(T1.LOAN_NET_VAL,0) * U.EXRT)=0 THEN 0 ELSE
            SUM(CASE WHEN T1.OVD_DAYS >30 THEN
                    CASE WHEN T1.OVD_DAYS > 0 AND T1.OVD_DAYS <= 90
                            AND SUBSTR(T1.LOAN_BIZ_TYP, 1, 4) IN ('0101', '0103', '0104', '0199')
                            AND T1.GXH_PAY_FREQ IN ('M','03') --按月还款
                            AND T1.GXH_PAY_TYPE IN ('1','2','6','7','8','9','11')  --根据发文，按月分期还款的个人消费贷款90天以上取逾期本金    --1等额本息 2等额本金 6气球贷 7等额累进 8等比累进 9等本等息 11按比例还本
                       THEN T1.OVD_PRIN_BAL * U.EXRT
                       ELSE T1.LOAN_NET_VAL * U.EXRT
                     END
                   ELSE 0
                  END)
              /SUM(NVL(T1.LOAN_NET_VAL,0) * U.EXRT)* 100  END   AS GTCZFFDKYQL               -- 共同出资发放贷款逾期率（逾期30天以上）（%）
           ,CASE WHEN SUM(NVL(T1.LOAN_NET_VAL,0) * U.EXRT)=0 THEN 0 ELSE
           SUM(T1.LOAN_NET_VAL * U.EXRT * T1.ACT_RATE)/SUM(NVL(T1.LOAN_NET_VAL,0) * U.EXRT)
                                                  END    AS DKPJLL                    -- 贷款平均利率（%）
           ,DECODE(T2.ZXLB,'01','保证保险提供增信'
                          ,'02','信用保险提供增信'
                          ,'03','融资担保公司提供增信'
                          ,'04','其他机构提供增信'
                          ,'不适用')                   AS ZXLB                      -- 增信类别
           ,0                                          AS ZFHZFFY                   -- 支付合作方费用（元）
           ,0                                          AS ZFDBZXFY                  -- 支付担保增信费用（元）
           ,SUM(T3.RET_INT)                            AS BNLXSY                    -- 本年利息收益（元）
           ,T1.TJDBFS
           ,SUM(T1.LOAN_NET_VAL * U.EXRT * T1.ACT_RATE)  AS TJYE_ACT                --实际贷款利率收入
           ,T1.ZWJGBH                                    AS ZWJGBH                  --账务机构编号
           ,T2.TGFWLX_G0902                              AS TGFWLX_G0902            --提供服务类型_G0902
           ,T2.TGFWLX_G0903                              AS TGFWLX_G0903            --提供服务类型_G0903
      FROM (SELECT A.DATA_DT                             AS DATA_DT                  --数据日期
                  ,A.RCPT_ID                             AS RCPT_ID                  --借据编号
                  ,A.CONT_ID                             AS CONT_ID                  --合同号
                  ,A.CUR                                 AS CUR                      --币种
                  ,CASE WHEN A.FND_PCT < 100 THEN '联合贷'  --联合贷
                        WHEN A.FND_PCT = 100 THEN '助贷本行'  --助贷本行
                   END                                   AS HZFS                      --合作方式                 
                  ,CASE WHEN SUBSTR(A.LOAN_BIZ_TYP,1,4) IN ('0103') THEN '个人消费'
                   ELSE '个人生产经营' END               AS HLWDKYTLB                 --互联网贷款用途类别 MOD BY 20251203 
                  ,CASE WHEN A.STD_PROD_ID ='202020200004' AND A.LOAN_ACT_DSTR_DT >= 20230412 AND  A.TJDBFS='XY' then '202020100001'
                        WHEN A.STD_PROD_ID ='202020200004' AND A.LOAN_ACT_DSTR_DT >= 20230101 AND  A.TJDBFS='BZ' then '202020100004'
                          else A.STD_PROD_ID end   AS  STD_PROD_ID             --标准产品编号
                  ,A.LVL5_CL                       AS  LVL5_CL                 --五级分类
                  ,A.LOAN_NET_VAL                  AS  LOAN_NET_VAL            --贷款净值
                  ,A.OVD_DAYS                      AS  OVD_DAYS                --逾期天数
                  ,A.LOAN_BIZ_TYP                  AS  LOAN_BIZ_TYP            --贷款业务类型
                  ,A.GXH_PAY_FREQ                  AS  GXH_PAY_FREQ            --还款频率
                  ,A.GXH_PAY_TYPE                  AS  GXH_PAY_TYPE            --还款方式
                  ,A.OVD_PRIN_BAL                  AS  OVD_PRIN_BAL            --逾期本金余额
                  ,A.ACT_RATE                      AS  ACT_RATE                --实际利率
                  ,A.FND_PCT/100                   AS  BHCZBL                  --本行出资比例
                  --,(100-aaa.fnd_pct)/100                            AS  HZJGCZBL                --合作机构出资比例                  
                  ,A.FND_PCT_HZF/100               AS  HZJGCZBL                --合作机构出资比例 MOD BY 20251203                  
                  ,DECODE(A.TJDBFS,'XY','信用','BZ','保证','DZY','抵质押') as TJDBFS
                  ,SUBSTR(A.ORG_ID,0,3)||'001'     AS ZWJGBH                   --账务机构编号
            FROM RRP_MDL.S_LOAN A  --A层借据信息表
/*             INNER JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO AAA
             ON A.RCPT_ID=AAA.RCPT_ID
             and aaa.data_dt=V_P_DATE*/
/*            LEFT JOIN (SELECT STD_PROD_ID,MAX(HZJGCZBL) AS HZJGCZBL
                       FROM RRP_MDL.M_DICT_G09_HZF  --G09静态表
                       GROUP BY STD_PROD_ID
                      ) B
                   ON B.STD_PROD_ID = A.STD_PROD_ID*/
            WHERE A.DATA_DT = V_P_DATE
              AND SUBSTR(A.LOAN_BIZ_TYP,1,4) IN ('0102','0103')   --个人经营和个人消费
              AND A.DATA_SRC IN ('联合网贷','零售贷款')   --互联网包含联合网贷和零售中的网贷
              AND A.NET_LOAN_FLG = 'Y'  --互联网贷款标志
              AND (   NVL(A.LOAN_BAL,0) <> 0 --有余额
                    OR ( A.DATA_SRC IN ('零售贷款')  AND SUBSTR(A.LOAN_ACT_DSTR_DT,1,4) = SUBSTR(V_P_DATE,1,4)
                        ) --当年放款
                    OR ( A.DATA_SRC IN ('联合网贷') AND A.LOAN_ACT_DSTR_DT >= SUBSTR(V_P_DATE ,1,4)-1||'1231'
                       ) --联合网贷包含去年末一天
                   )
           ) T1
/*     INNER JOIN RRP_MDL.M_DICT_G09_HZF T2 --G09静态表
             --ON T2.YWPZBH = T1.STD_PROD_ID
             ON T2.STD_PROD_ID = T1.STD_PROD_ID  -- MODIFY BY WEIYONGZHAO 20230523 取标准产品编号关联
            AND T2.HZJGCZBL = T1.HZJGCZBL*/
     --关联合作协议子表取合作方等相关信息 ADD BY 20251203
     LEFT JOIN LOAN_CONT_INFO_TMP T2
            ON T2.CONT_ID = T1.CONT_ID
     LEFT JOIN (SELECT RCPT_ID,
                       SUM(RET_INT) AS RET_INT
                  FROM  RRP_MDL.M_LOAN_RP_PLAN_INFO C --贷款还款计划信息
                 WHERE C.REPY_DT >= SUBSTR(V_P_DATE,1,4)||'0101'
                   AND C.REPY_DT <= V_P_DATE
                   AND C.DATA_DT=V_P_DATE
                 GROUP BY RCPT_ID)T3
             ON T3.RCPT_ID = T1.RCPT_ID
     LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO U --汇率表
             ON U.DATA_DT = T1.DATA_DT
            AND U.BASE_CUR = T1.CUR
            AND U.CNV_CUR = 'CNY'
/*     LEFT JOIN RRP_MDL.CODE_MAP M1 --码值表
             ON M1.TAR_CLASS_CODE = 'C0005' --行业类别
            AND M1.SRC_CLASS_CODE = 'C0005'
            AND M1.MOD_FLG = 'BFD'
            AND M1.TAR_VALUE_CODE = T2.HLWDKHZJGLB*/
     LEFT JOIN RRP_MDL.CODE_MAP M1 --码值表
             ON M1.TAR_CLASS_CODE = 'C0051' --合作方类型
            AND M1.SRC_CLASS_CODE = 'C0051'
            AND M1.MOD_FLG = 'EAST'
            AND M1.TAR_VALUE_CODE = T2.HLWDKHZJGLB           
     GROUP BY /*CASE WHEN T2.HZFS = '01'   THEN '联合贷'  --联合贷
                  WHEN T2.HZFS = '02' THEN '本行助贷'  --本行助贷 无业务
                  WHEN T2.HZFS = '03' THEN '助贷本行'  --助贷本行
             END*/
            T1.HZFS
           ,T2.HZFWYM
           ,T2.HZFMC
           ,T2.HZFWYM
           ,M1.TAR_VALUE_NAME
           ,T2.HZJGTGFWLX
/*           ,DECODE(T2.HLWDKYTLB,'01','个人消费'
                               ,'02','个人生产经营'
                               ,'03','对公流动资金')*/
           ,T1.HLWDKYTLB
           ,T1.BHCZBL
           ,T1.HZJGCZBL
           ,DECODE(T2.ZXLB,'01','保证保险提供增信'
                          ,'02','信用保险提供增信'
                          ,'03','融资担保公司提供增信'
                          ,'04','其他机构提供增信'
                          ,'不适用')
           ,T1.TJDBFS
           ,T1.ZWJGBH
           ,T2.TGFWLX_G0902
           ,T2.TGFWLX_G0903
   ;
   COMMIT;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '临时数据处理2';
  V_STARTTIME := SYSDATE;

/*   INSERT INTO TMP_A_PHB_G0901_HZF_2
    (
        BGRQ              --报告日期
       ,HZFS              --合作方式
       ,HZFWYM            --合作方唯一码
       ,HLWDKYTLB         --互联网贷款用途类别
       ,BNTJHS            --本年推荐户数
       ,BNSXHS            --本年授信户数
    )         
    SELECT V_P_DATE         AS BGRQ              --报告日期
          ,CASE WHEN A.HZFS = '01'   THEN '联合贷'  --联合贷
                  WHEN A.HZFS = '02' THEN '本行助贷'  --本行助贷 无业务
                  WHEN A.HZFS = '03' THEN '助贷本行'  --助贷本行
             END            AS HZFS              --合作方式
          ,A.HZFWYM         AS HZFWYM            --合作方唯一码
          ,DECODE(A.HLWDKYTLB,'01','个人消费'
                              ,'02','个人生产经营'
                              ,'03','对公流动资金')       AS HLWDKYTLB         --互联网贷款用途类别
          ,COUNT(DISTINCT B.CUST_ID)                      AS BNTJHS            --本年推荐户数
          ,COUNT(DISTINCT CASE WHEN B.APP_STAT = 'Finished' THEN B.CUST_ID END)
                                                          AS BNSXHS            --本年授信户数
    FROM (SELECT \*YWPZBH*\STD_PROD_ID,HZFWYM,HLWDKYTLB,MIN(HZFS) AS HZFS
          FROM M_DICT_G09_HZF
          GROUP BY \*YWPZBH*\STD_PROD_ID,HZFWYM,HLWDKYTLB
         ) A      
   INNER JOIN M_LOAN_APP_INFO B --贷款申请表
           \*ON CASE WHEN  B.LOAN_BIZ_TYP ='202020100001' THEN '02001006135011'
                   WHEN  B.LOAN_BIZ_TYP ='202020200004' THEN '02001006160048'
                   WHEN  B.LOAN_BIZ_TYP ='202010100003' THEN '02001004135021'
                   WHEN  B.LOAN_BIZ_TYP ='202010100001' THEN '02001004120222'
                   WHEN  B.LOAN_BIZ_TYP ='202010100002' THEN '02001004165051'
                   WHEN  B.LOAN_BIZ_TYP ='202010100006' THEN '0900600100001'
                   WHEN  B.LOAN_BIZ_TYP ='202010100004' THEN '02001004165085'
                   WHEN  B.LOAN_BIZ_TYP ='202010200005' THEN '02001004165073'
                   WHEN  B.LOAN_BIZ_TYP ='202010200004' THEN '02001004220010'
                   WHEN  B.LOAN_BIZ_TYP ='202020200002' THEN '02001006155012'
                   WHEN  B.LOAN_BIZ_TYP ='202020200003' THEN '02001006160045'
                   WHEN  B.LOAN_BIZ_TYP ='202020200005' THEN '02001006310010'
                   WHEN  B.LOAN_BIZ_TYP ='202020200006' THEN '02001006305010'
              END = A.YWPZBH*\ -- MODIFY BY WEIYONGZHAO 20230523 取标准产品编号关联
           ON B.LOAN_BIZ_TYP = A.STD_PROD_ID
    WHERE B.DATA_DT = V_P_DATE
      AND B.DATA_SRC IN ('零售贷款','联合网贷')
      AND (SUBSTR(B.APP_DT,1,4) = SUBSTR(V_P_DATE,1,4) --本年申请
           OR (B.DATA_SRC IN ('联合网贷') AND B.APP_DT = (SUBSTR(V_P_DATE,1,4)-1)||'1231')
          )
      AND A.HZFWYM IS NOT NULL
    GROUP BY A.HZFS
            ,A.HZFWYM
            ,A.HLWDKYTLB
       ;
   COMMIT;*/
   
   --MOD BY 20251203
   INSERT INTO TMP_A_PHB_G0901_HZF_2
    (
        BGRQ              --报告日期
       ,HZFS              --合作方式
       ,HZFWYM            --合作方唯一码
       ,HLWDKYTLB         --互联网贷款用途类别
       ,BNTJHS            --本年推荐户数
       ,BNSXHS            --本年授信户数
       ,ZWJGBH            --账务机构编号
    )
    WITH TMP_AGRT AS ( 
    SELECT /*+ MATERIALIZE*/ A.COOP_AGRT_ID,MAX(A.PNR_NM) PNR_NM,MAX(A.PNR_CRDL_NO) PNR_CRDL_NO
          ,MAX(A.PNR_TYP) PNR_TYP,MAX(A.COOP_MODE) COOP_MODE,MAX(A.INCRE_CRDT_MODE_CD) ZXLB
      FROM RRP_MDL.M_LOAN_NET_COOP_SUB A --互联网贷款合作协议表
     WHERE DATA_DT = V_P_DATE
     GROUP BY COOP_AGRT_ID),
TMP_CONT_COOP_AGRT_ID AS (
    SELECT /*+ MATERIALIZE*/ COOP_AGRT_ID
      FROM RRP_MDL.M_LOAN_CONT_INFO 
     WHERE DATA_DT = V_P_DATE
     GROUP BY COOP_AGRT_ID ),
  TMP_COOP_AGRT_ID AS (
    SELECT /*+ MATERIALIZE*/ C.COOP_AGRT_ID,REGEXP_SUBSTR(C.COOP_AGRT_ID, '[^;]+', 1, LEVEL) COOP_AGRT_ID_ST 
    FROM TMP_CONT_COOP_AGRT_ID C 
     CONNECT BY LEVEL <= LENGTH(C.COOP_AGRT_ID) - LENGTH(REPLACE(C.COOP_AGRT_ID, ';')) + 1
     GROUP BY C.COOP_AGRT_ID,REGEXP_SUBSTR(C.COOP_AGRT_ID, '[^;]+', 1, LEVEL)),
    LOAN_CONT_INFO_TMP AS (
    SELECT /*+ MATERIALIZE*/
           CASE WHEN T1.STD_PROD_ID ='202020200004' AND T1.LOAN_ACT_DSTR_DT >= 20230412 AND  T1.TJDBFS='XY' then '202020100001'
                WHEN T1.STD_PROD_ID ='202020200004' AND T1.LOAN_ACT_DSTR_DT >= 20230101 AND  T1.TJDBFS='BZ' then '202020100004'
           ELSE T1.STD_PROD_ID END STD_PROD_ID
          ,MAX(T3.PNR_CRDL_NO) HZFWYM
          ,MAX(CASE WHEN SUBSTR(T1.LOAN_BIZ_TYP,1,4) IN ('0103') THEN '个人消费'
               ELSE '个人生产经营' END) HLWDKYTLB
          ,MAX(CASE WHEN T1.FND_PCT < 100 THEN '联合贷'    --联合贷
                    WHEN T1.FND_PCT = 100 THEN '助贷本行'  --助贷本行
               END) HZFS
          ,SUBSTR(T1.ORG_ID,0,3)||'001' AS ZWJGBH
      FROM RRP_MDL.S_LOAN T1
      LEFT JOIN RRP_MDL.M_LOAN_CONT_INFO T2 ON T2.CONT_ID = T1.CONT_ID AND T2.DATA_DT = V_P_DATE
      LEFT JOIN TMP_COOP_AGRT_ID T4 ON T4.COOP_AGRT_ID = T2.COOP_AGRT_ID
      LEFT JOIN TMP_AGRT T3 ON T3.COOP_AGRT_ID = T4.COOP_AGRT_ID_ST
      WHERE T1.NET_LOAN_FLG = 'Y'
       AND T1.DATA_DT = V_P_DATE
    GROUP BY CASE WHEN T1.STD_PROD_ID ='202020200004' AND T1.LOAN_ACT_DSTR_DT >= 20230412 AND  T1.TJDBFS='XY' then '202020100001'
                  WHEN T1.STD_PROD_ID ='202020200004' AND T1.LOAN_ACT_DSTR_DT >= 20230101 AND  T1.TJDBFS='BZ' then '202020100004'
             ELSE T1.STD_PROD_ID END,SUBSTR(T1.ORG_ID,0,3)||'001'),
    CUST_NUM AS ( SELECT /*+ MATERIALIZE*/ B.LOAN_BIZ_TYP AS LOAN_BIZ_TYP
                        ,SUBSTR(B.ORG_ID,0,3)||'001' AS ZWJGBH
                        ,COUNT(DISTINCT B.CUST_ID) AS BNTJHS
                        ,COUNT(DISTINCT CASE WHEN B.APP_STAT = 'Finished' THEN B.CUST_ID END) AS BNSXHS
                  FROM RRP_MDL.M_LOAN_APP_INFO B --贷款申请表
                  WHERE B.DATA_SRC IN ('零售贷款','联合网贷')
                  AND (SUBSTR(B.APP_DT,1,4) = SUBSTR(V_P_DATE,1,4) --本年申请
                       OR (B.DATA_SRC IN ('联合网贷') AND B.APP_DT = (SUBSTR(V_P_DATE,1,4)-1)||'1231')
                      )
                  AND B.DATA_DT = V_P_DATE
                  GROUP BY B.LOAN_BIZ_TYP,SUBSTR(B.ORG_ID,0,3)||'001'
    )                
    SELECT V_P_DATE                                       AS BGRQ              --报告日期
          ,A.HZFS                                         AS HZFS              --合作方式
          ,A.HZFWYM                                       AS HZFWYM            --合作方唯一码
          ,A.HLWDKYTLB                                    AS HLWDKYTLB         --互联网贷款用途类别
          ,B.BNSXHS                                       AS BNTJHS            --本年推荐户数
          ,B.BNSXHS                                       AS BNSXHS            --本年授信户数
          ,A.ZWJGBH                                       AS ZWJGBH            --账务机构编号
    FROM LOAN_CONT_INFO_TMP A      
   INNER JOIN CUST_NUM B --贷款申请表
           ON B.LOAN_BIZ_TYP = A.STD_PROD_ID
          AND A.ZWJGBH = B.ZWJGBH
    WHERE A.HZFWYM IS NOT NULL;
   COMMIT;
   
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    V_STEP      := V_STEP + 1;
    V_STEP_DESC := '数据插入表';
    V_STARTTIME := SYSDATE;

        INSERT INTO A_PHB_G0901_HZF
    (
        BGRQ              --报告日期
       ,HZFWYM            --合作方唯一码
       ,HLWDKYTLB         --互联网贷款用途类别
       ,HZFS              --合作方式
       ,HZFMC             --合作方名称
       ,SHXYDM            --社会信用代码
       ,HLWDKHZJGLB       --互联网贷款合作机构类别
       ,TJYE              --统计余额（元）
       ,HZFFKYE           --合作方放款余额（元）
       ,HLWDKFKYE         --互联网贷款放款余额（元）
       ,HZJGCZBL          --合作机构出资比例
       ,BLDKYE            --不良贷款余额（元）
       ,BLDKL             --不良贷款率（%）
       ,YQ30TYSDKJE       --逾期30天以上贷款金额
       ,GTCZFFDKYQL       --共同出资发放贷款逾期率（逾期30天以上）（%）
       ,DKPJLL            --贷款平均利率（%）
       ,HZJGTGFWLX        --合作机构提供服务类型
       ,HZJGTGYXHKFW      --合作机构提供营销获客服务
       ,HZJGTGGTCZFW      --合作机构提供共同出资服务
       ,HZJGTGZFJSFW      --合作机构提供支付结算服务
       ,HZJGTGKHSXFW      --合作机构提供客户筛选服务
       ,HZJGTGBFFXPJFW    --合作机构提供部分风险评价服务
       ,HZJGTGDBZXFW      --合作机构提供担保增信服务
       ,HZJGTGXXKJFW      --合作机构提供信息科技服务
       ,HZJGTGYQQSFW      --合作机构提供逾期清收服务
       ,HZJGTGQTFW        --合作机构提供其他服务
       ,BNTJHS            --本年推荐户数
       ,BNSXHS            --本年授信户数
       ,ZXLB              --增信类别
       ,ZFHZFFY           --支付合作方费用（元）
       ,ZFDBZXFY          --支付担保增信费用（元）
       ,BNLXSY            --本年利息收益（元）
       ,TJDBFS            --统计担保方式
       ,TJYE_ACT          --实际贷款利率收入
       ,ZWJGBH            --账务机构编号
       ,TGFWLX_G0902      --提供服务类型_G0902
       ,TGFWLX_G0903      --提供服务类型_G0903       
    )
    SELECT V_P_DATE                       AS BGRQ              --报告日期
          ,A.HZFWYM                       AS HZFWYM            --合作方唯一码
          ,A.HLWDKYTLB                    AS HLWDKYTLB         --互联网贷款用途类别  --码表编号 A0069
          ,A.HZFS                         AS HZFS              --合作方式  --码表编号 A0072
          ,A.HZJGMC                       AS HZFMC             --合作方名称 【补录】系统补录
          ,A.HZFWYM                       AS SHXYDM            --社会信用代码 【补录】系统补录
          ,A.HZJGLB                       AS HLWDKHZJGLB       --互联网贷款合作机构类别  --码表编号 C0035 【补录】系统补录
          ,A.TJYE                         AS TJYE              --统计余额（元）
          ,A.HZFFKYE                      AS HZFFKYE           --合作方放款余额（元） 【补录】系统补录
          ,A.HLWDKFKYE                    AS HLWDKFKYE         --互联网贷款放款余额（元） 【补录】系统补录
          ,A.HZFCZBL                      AS HZJGCZBL          --合作机构出资比例 【补录】手工补录
          ,A.BLDKYE                       AS BLDKYE            --不良贷款余额（元）
          ,A.BLDKL                        AS BLDKL             --不良贷款率（%）
          ,A.YQ30TYSDKJE                  AS YQ30TYSDKJE       --逾期30天以上贷款金额
          ,A.GTCZFFDKYQL                  AS GTCZFFDKYQL       --共同出资发放贷款逾期率（逾期30天以上）（%） 【补录】手工补录
          ,A.DKPJLL                       AS DKPJLL            --贷款平均利率（%） 【补录】系统补录
          ,A.TGFWLX                       AS HZJGTGFWLX        --合作机构提供服务类型  --码表编号 A0011 【补录】系统补录
          ,CASE WHEN A.TGFWLX LIKE '%01%' THEN 'A' ELSE '否' END
                                          AS HZJGTGYXHKFW      --合作机构提供营销获客服务 【补录】系统补录
          ,CASE WHEN A.TGFWLX LIKE '%02%' THEN 'B' ELSE '否' END
                                          AS HZJGTGGTCZFW      --合作机构提供共同出资服务 【补录】系统补录
          ,CASE WHEN A.TGFWLX LIKE '%03%' THEN 'C' ELSE '否' END
                                          AS HZJGTGZFJSFW      --合作机构提供支付结算服务 【补录】系统补录
          ,CASE WHEN A.TGFWLX LIKE '%08%' THEN 'D' ELSE '否' END
                                          AS HZJGTGKHSXFW      --合作机构提供客户筛选服务 【补录】系统补录
          ,CASE WHEN A.TGFWLX LIKE '%09%' THEN 'E' ELSE '否' END
                                          AS HZJGTGBFFXPJFW    --合作机构提供部分风险评价服务 【补录】系统补录
          ,CASE WHEN A.TGFWLX LIKE '%05%' THEN 'F' ELSE '否' END
                                          AS HZJGTGDBZXFW      --合作机构提供担保增信服务 【补录】系统补录
          ,CASE WHEN A.TGFWLX LIKE '%06%' THEN 'G' ELSE '否' END
                                          AS HZJGTGXXKJFW      --合作机构提供信息科技服务 【补录】系统补录
          ,CASE WHEN A.TGFWLX LIKE '%07%' THEN 'H' ELSE '否' END
                                          AS HZJGTGYQQSFW      --合作机构提供逾期清收服务 【补录】系统补录
          ,CASE WHEN A.TGFWLX LIKE '%10%' THEN 'I' ELSE '否' END
                                          AS HZJGTGQTFW        --合作机构提供其他服务 【补录】系统补录
          ,CASE WHEN SUM(NVL(A.HLWDKFKYE,0)) OVER(PARTITION BY A.HZFS,A.HZFWYM,A.HLWDKYTLB,A.ZWJGBH) = 0 THEN 0
           ELSE ROUND(NVL(A.HLWDKFKYE,0)/SUM(NVL(A.HLWDKFKYE,0)) OVER(PARTITION BY A.HZFS,A.HZFWYM,A.HLWDKYTLB,A.ZWJGBH) * B.BNTJHS) END
                                          AS BNTJHS            --本年推荐户数 系统取数
          ,CASE WHEN SUM(nvl(A.HLWDKFKYE,0)) OVER(PARTITION BY A.HZFS,A.HZFWYM,A.HLWDKYTLB,A.ZWJGBH) = 0 THEN 0
           ELSE ROUND(nvl(A.HLWDKFKYE,0)/SUM(nvl(A.HLWDKFKYE,0)) OVER(PARTITION BY A.HZFS,A.HZFWYM,A.HLWDKYTLB,A.ZWJGBH) * B.BNSXHS) END
                                          AS BNSXHS            --本年授信户数 系统取数
          ,A.ZXLB                         AS ZXLB              --增信类别  补录  --码表编号 A0094 系统取数
          ,A.ZFHZFFY                      AS ZFHZFFY           --支付合作方费用（元） 系统取数
          ,A.ZFDBZXFY                     AS ZFDBZXFY          --支付担保增信费用（元） 默认为0
          ,A.BNLXSY                       AS BNLXSY            --本年利息收益（元） 系统取数
          ,A.TJDBFS                       AS TJDBFS
          ,A.TJYE_ACT                     AS TJYE_ACT          --实际贷款利率收入
          ,A.ZWJGBH                       AS ZWJGBH            --账务机构编号
          ,A.TGFWLX_G0902                 AS TGFWLX_G0902      --提供服务类型_G0902
          ,A.TGFWLX_G0903                 AS TGFWLX_G0903      --提供服务类型_G0903          
    FROM TMP_A_PHB_G0901_HZF_1 A --临时表1
    LEFT JOIN TMP_A_PHB_G0901_HZF_2 B --临时表2
           ON B.HZFS = A.HZFS
          AND B.HZFWYM = A.HZFWYM
          AND B.HLWDKYTLB = A.HLWDKYTLB
          AND A.ZWJGBH = B.ZWJGBH
    WHERE A.HZFWYM IS NOT NULL
    ;
   COMMIT;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  --插入过程跑批完成记录表
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;

   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 程序跑批结束记录 --
   V_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
     V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
     ROLLBACK;
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;
     V_STEP := V_STEP + 1;
     V_STEP_DESC := '-- 程序跑批异常 --';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_A_PHB_G0901_HZF;
/

