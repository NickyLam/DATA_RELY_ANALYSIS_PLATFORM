CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_LOAN_CONT_INFO
(I_P_DATE IN INTEGER,        --跑批日期
 O_ERRCODE OUT VARCHAR2        --错误代码
 )
  /**************************************************************************
  *  程序名称：ETL_INIT_M_LOAN_CONT_INFO
  *  功能描述：贷款合同信息
  *  创建日期：20220519
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_LOAN_CONT_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220519  梅炜    首次创建
  *             2    20220819  hulj    调整合同号和客户号逻辑，增加数据重复校验逻辑
  *             3    20221021  hulj    调整对公、零售、联合网贷贷款产品类型,客户经理,合作方责任金额取值口径
  *             4    20221022  mw      调整合作协议、协议日期取值及产品编号映射关系
  *             5    20221108  hulj    调整零售贷款部分三方,四方协议口径
  *             6    20221220  hulj    调整零售贷款部分合作协议编号取值
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_LOAN_CONT_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
 -- V_LAST_DAT  VARCHAR2(8); -- 当月月末
 -- V_YESTADAY  VARCHAR2(8); -- 上日
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_DATE  DATE;             --数据日期(判断输入参数日期格式是否准确)
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_DATE   := TO_DATE(I_P_DATE,'YYYYMMDD');
  V_MONTH_START_DATE := TRUNC(TO_DATE(I_P_DATE,'YYYYMMDD'), 'MM');
  V_TAB_NAME := 'M_LOAN_CONT_INFO'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;


   -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --判断跑批频度--


  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;

  --初始化表增加分区
  V_STEP_DESC := '初始化表增加分区';
  V_START_DT := SUBSTR(V_P_DATE,0,6)||'01';
  WHILE TO_DATE(V_START_DT,'YYYYMMDD') <= TO_DATE(V_P_DATE,'YYYYMMDD')
  LOOP
  ETL_PARTITION_ADD(V_START_DT,V_TAB_NAME, '1', O_ERRCODE);
  V_START_DT := TO_CHAR(TO_DATE(V_START_DT,'YYYYMMDD')  + 1 ,'YYYYMMDD');
  END LOOP;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --删除当前分区数据

  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理


  --清理临时表数据
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '贷款合同信息--清理临时表数据';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_LOAN_CONT_INFO_TEMP02';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '贷款合同信息--对公贷款部分';
  V_STARTTIME := SYSDATE;
  INSERT INTO M_LOAN_CONT_INFO_TEMP02
  (
    DATA_DT                  --数据日期
    ,LGL_REP_ID              --法人编号
    ,CONT_ID                 --合同编号
    ,CONT_NM                 --合同名称
    ,PRIM_CONT_ID            --主合同号
    ,CUST_ID                 --客户编号
    ,ORG_ID                  --机构编号
    ,RGST_ORG_ID             --注册机构
    ,OPER_ORG_ID             --开户机构
    ,APP_ID                  --申请编号
    ,CRDT_LMT_ID              --授信额度编号
    ,LOAN_PROD_TYP           --贷款产品类型
    ,LOAN_PROD_NM            --贷款产品名称
    ,CUR                     --币种
    ,CONT_AMT                --合同金额
    ,CONT_START_DT           --合同开始日期
    ,CONT_EXP_DT             --合同到期日期
    ,MAIN_GUA_MODE           --主担保方式1
    ,SUB_GUA_MODE            --子担保方式2
    ,CUST_MGR_NO             --客户经理工号
    ,LOAN_USEAGE             --贷款用途
    ,DIR_RGN_AREA_CD         --投向地区行政区划
    ,DIR_IDY                 --投向行业
    ,FIN_LOAN_REL_LC_NO      --融资贷款关联信用证号
    ,CONT_SIGN_DT            --合同签订日期
    ,COOP_AGRT_ID            --合作协议编号
    ,CUST_DATA_AUTH_ID       --客户数据授权书编号
    ,GRANT_EFF_DT            --授权生效日期
    ,GRANT_END_DT            --授权终止日期
    ,PNR_RESP_AMT            --合作方责任金额
    ,APP_PSN_TEL             --申请人联系电话
    ,CONT_STAT               --合同状态
    ,DEPT_LINE               --部门条线
    ,DATA_SRC                --数据来源
    ,GUAR_RATE               --担保率
    ,STD_PROD_ID             --标准产品编号
    ,PAYOFF_FLG              --结清标记
    ,MON_FLG                 --月口径标识
    ,TERMNT_DT               --终止日期
    ,LOAN_HAPP_TYPE_CD       --贷款发生类型
    ,HIGH_TECH_PROPERTY_TYPE_CD
                             --高技术产业类型代码
    ,DIGIT_ECON_CORE_PROPERTY_TYPE_CD
                             --数字经济核心产业类型代码
    ,INTEL_PROP_INTE_PROPERTY_TYPE_CD
                             --知识产权密集型产业类型代码
    ,CUL_PROPERTY_FLG        --文化产业标志
    ,STRATE_NEW_INDUS_TYPE_CD--战略性新兴产业类型代码
    ,HIGH_NEW_TECH_CORP_FLG  --高新技术企业标志
    ,SCI_TECH_CORP_FLG       --科技型企业标志
    ,SCI_TECH_INOVT_CORP_FLG --科创企业标志
    )
   SELECT
         V_P_DATE                                     DATA_DT                    --数据日期
         ,A.LP_ID                                     LGL_REP_ID                 --法人编号
         ,A.CONT_ID                                   CONT_ID                    --合同编号
         ,NVL(TRIM(A.MANU_CONT_ID),A.CONT_ID)         CONT_NM                    --合同名称
         ,A.CONT_ID                                   PRIM_CONT_ID               --主合同号
         ,A.CUST_ID                                   CUST_ID                    --客户编号 --转贴现、福费廷的取对手方的客户号
         ,TRIM(A.MGMT_ORG_ID)                         ORG_ID                     --管理机构
         ,TRIM(A.RGST_ORG_ID)                         RGST_ORG_ID                --注册机构
         ,TRIM(A.OPER_ORG_ID)                         OPER_ORG_ID                --开户机构 --MODIFY BY MW 20221122
         ,A.APV_FLOW_NUM                              APP_ID                     --申请编号
         ,A.LMT_CONT_ID                               CRDT_LMT_ID                --授信额度编号
         /*,CASE WHEN A.BUS_BREED_ID IN ('1060080') THEN '0204'
               WHEN E.ACCT_TYP IS NOT NULL THEN E.ACCT_TYP
               WHEN D.FLAG ='2' THEN '030201' --买断式转贴现
               ELSE '02'--对公贷款
           END                                        LOAN_PROD_TYP              --贷款产品类型 T0001*/
        ,CASE WHEN E.TAR_VALUE_CODE IS NOT NULL THEN E.TAR_VALUE_CODE
              WHEN B.PROD_ID IS NOT NULL THEN B.PROD_ID
               ELSE '02'  --个人贷款
           END                                        LOAN_PROD_TYP              --贷款产品类型 --modify by xieyugeng 20221021
         ,B.PROD_NAME                                 LOAN_PROD_NM               --贷款产品名称
         ,A.CURR_CD                                   CUR                        --币种
         ,A.CONT_AMT                                  CONT_AMT                   --合同金额
         ,CASE WHEN TO_CHAR(A.START_DT,'YYYYMMDD') NOT IN ('00010101','29991231') THEN TO_CHAR(A.START_DT,'YYYYMMDD')
               WHEN TO_CHAR(A.DISTR_DT,'YYYYMMDD') NOT IN ('00010101','29991231') THEN TO_CHAR(A.DISTR_DT,'YYYYMMDD')
               ELSE NULL
           END                                        CONT_START_DT              --合同开始日期  --modify by tangan at 20221125
         ,CASE WHEN TO_CHAR(A.EXP_DT,'YYYYMMDD') IN ('00010101','29991231')
               THEN NULL
               ELSE TO_CHAR(A.EXP_DT,'YYYYMMDD')
           END                                        CONT_EXP_DT                --合同到期日期
         ,NVL(TB.TAR_VALUE_CODE,'Z')                  MAIN_GUA_MODE              --主担保方式
         ,A.SUB_GUAR_WAY_CD                           SUB_GUA_MODE               --子担保方式
         ,COALESCE(TRIM(A.MGMT_TELLER_ID),TRIM(A.RGST_TELLER_ID)) CUST_MGR_NO    --客户经理工号
         ,/*CASE WHEN TRIM(A.LOAN_USAGE_DESCB) IS NOT NULL THEN TRIM(A.LOAN_USAGE_DESCB)
               WHEN D.FLAG ='2' THEN '上海票据交易所系统参与者间开展的票据交易'
               WHEN A.BUS_BREED_ID IN ('1090','4010197') THEN '企业日常经营周转'
               WHEN A.BUS_BREED_ID LIKE '1080%' THEN '其他-垫款'
           END                  */
          A.LOAN_USAGE_DESCB                          LOAN_USEAGE                --贷款用途
         ,NULL                                        DIR_RGN_AREA_CD            --投向地区行政区划代码
         ,A.DIR_INDUS_CD                              DIR_IDY                    --投向行业
         ,A.LC_ID                                     FIN_LOAN_REL_LC_NO         --融资贷款关联信用证号
         ,TO_CHAR(A.DISTR_DT,'YYYYMMDD')              CONT_SIGN_DT               --合同签订日期
         ,NULL                                        COOP_AGRT_ID               --合作协议编号
         ,NULL                                        CUST_DATA_AUTH_ID          --客户数据授权书编号
         ,NULL                                        GRANT_EFF_DT               --授权生效日期
         ,NULL                                        GRANT_END_DT               --授权终止日期
         ,NULL                                        PNR_RESP_AMT               --合作方责任金额
         ,NULL                                        APP_PSN_TEL                --申请人联系电话
         ,NVL(TA.TAR_VALUE_CODE,'99')                 CONT_STAT                  --合同状态 CD1371-->D0117
         ,NULL                                        DEPT_LINE                  --部门条线
         ,'对公信贷'                                   DATA_SRC                   --数据来源
         ,CASE WHEN A.CONT_AMT = 0
               THEN  0
               WHEN  nvl(H1.RELA_AMT,0)/ A.cont_amt >= 1
               then 1
               else
               round( nvl(H1.RELA_AMT,0) / A.cont_amt ,8)
               end                                    GUAR_RATE                  --担保率
         ,A.STD_PROD_ID                               STD_PROD_ID                --标准产品编号
         ,CASE WHEN A.ACM_DISTR_AMT = A.ACM_CALLBK_AMT  THEN 'Y'
               ELSE 'N' END                           PAYOFF_FLG                 --结清标记
         ,CASE WHEN (A.VALID_FLG_CD  ='2' --2生效，4终结（包括已结清失效和未结清失效）
               OR (A.VALID_FLG_CD = '4' AND A.ACM_DISTR_AMT <> A.ACM_CALLBK_AMT) --未结清
                   )  AND (A.STD_PROD_ID  LIKE '2%' OR A.STD_PROD_ID IN ('602060100001','602060100002','602030100001','602030100001','602030100002'))
                   AND A.CONT_TYPE_CD = '02'  THEN 'Y'  --02业务合同
             ELSE 'N'
             END                                      MON_FLG                    --月口径标识
         ,TO_CHAR(A.TERMNT_DT,'YYYYMMDD')             TERMNT_DT                  --终止日期
         ,A.LOAN_HAPP_TYPE_CD                         LOAN_HAPP_TYPE_CD          --贷款发生类型
         ,NULL                                        HIGH_TECH_PROPERTY_TYPE_CD --高技术产业类型代码
         ,NULL                                        DIGIT_ECON_CORE_PROPERTY_TYPE_CD
                                                                                 --数字经济核心产业类型代码
         ,NULL                                        INTEL_PROP_INTE_PROPERTY_TYPE_CD
                                                                                 --知识产权密集型产业类型代码
         ,NULL                                        CUL_PROPERTY_FLG           --文化产业标志
         ,NULL                                        STRATE_NEW_INDUS_TYPE_CD   --战略性新兴产业类型代码
         ,C.HIGH_NEW_TECH_CORP_FLG                    HIGH_NEW_TECH_CORP_FLG     -- 高新技术企业标志
         ,C.SCI_TECH_CORP_FLG                         SCI_TECH_CORP_FLG          -- 科技型企业标志
         ,C.SCI_TECH_INOVT_CORP_FLG                   SCI_TECH_INOVT_CORP_FLG    --科创企业标志
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO A --对公贷款合同信息
    LEFT JOIN (SELECT H.CONT_ID CONT_ID,SUM(H.RELA_AMT) RELA_AMT
              FROM O_IML_AGT_LOAN_CONT_RELA_TAB_INFO_H H
              WHERE H.OBJ_TYPE_NAME= 'GuarantyContract'
              GROUP BY H.CONT_ID) H1
         ON H1.CONT_ID = A.CONT_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO B --标准产品信息
      ON B.PROD_ID = A.STD_PROD_ID
     AND B.ETL_DT = V_DATE
    LEFT JOIN O_ICL_CMM_CORP_LOAN_BUS_CONT_ATTACH_INFO C --对公贷款业务合同附加信息
      ON C.CONT_ID = A.CONT_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP TA --合同状态转码 CD1371-->D0117
      ON TA.SRC_VALUE_CODE = A.VALID_FLG_CD
     AND TA.SRC_CLASS_CODE = 'CD2586'
     AND TA.TAR_CLASS_CODE = 'D0117'
     AND TA.MOD_FLG = 'MDM' --监管集市明细层
    LEFT JOIN RRP_MDL.CODE_MAP TB --担保方式1转码 CD1244-->D0037
      ON TB.SRC_VALUE_CODE = A.MAJOR_GUAR_WAY_CD
     AND TB.SRC_CLASS_CODE = 'CD2656'
     AND TB.TAR_CLASS_CODE = 'D0002'
     AND TB.MOD_FLG = 'MDM' --监管集市明细层
  /*  LEFT JOIN RRP_MDL.ADD_DUBILL_LOAN_BIZ_TYP E
      ON E.BUS_BREED_ID = A.BUS_BREED_ID
     AND E.DATE_SOURCESD = 'DG'
     AND E.MIAN_ACCT_TYP_FLAG = '1'*/
       LEFT JOIN RRP_MDL.CODE_MAP E  --码值映射表(贷款类型)
      ON A.STD_PROD_ID = E.SRC_VALUE_CODE
      AND E.SRC_CLASS_CODE = 'STD0002'
      AND E.TAR_CLASS_CODE = 'T0001'
      AND E.MOD_FLG = 'MDM'
   WHERE /*(D.CONT_ID IS NOT NULL
         OR (A.VALID_FLG_CD IN ('01','02') --01是已生效，02是到期未结清失效
             --AND A.BUS_BREED_ID NOT LIKE '2%' AND A.BUS_BREED_ID NOT LIKE '5%'
             --AND A.CONT_TYPE_CD = '02'  --业务合同
             ))--2\5开头的是表外业务
     AND*/ A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '贷款合同信息--处理对公贷款合同余额';
  V_STARTTIME := SYSDATE;

  MERGE INTO M_LOAN_CONT_INFO_TEMP02 A
  USING
        (
               SELECT /*+PARALLEL*/
                      C.CONT_ID
                     ,SUM(B.PRIC_BAL)  AS LOAN_ACCT_BAL --金数不考虑核销、减值等情况，只考虑原始余额是否结清
                FROM O_ICL_CMM_CORP_LOAN_ACCT_INFO  B    --对公贷款账户信息
               INNER JOIN O_ICL_CMM_CORP_LOAN_DUBIL_INFO A --对公贷款借据信息表
                  ON A.DUBIL_ID = B.DUBIL_NUM
                 AND A.ETL_DT = B.ETL_DT
                LEFT JOIN O_ICL_CMM_CORP_LOAN_CONT_INFO C  --对公贷款合同信息表
                  ON A.CONT_ID = C.CONT_ID
                 AND A.ETL_DT = C.ETL_DT
               WHERE B.ETL_DT = V_DATE
                 AND (B.OPEN_ACCT_DT <> B.CLOS_ACCT_DT)
                 AND (C.CRDT_TYPE_CD = '02' OR C.CRDT_TYPE_CD IS NULL ) --00未知 01额度合同  02业务合同
                 GROUP BY C.CONT_ID
                ) B
  ON (A.CONT_ID = B.CONT_ID
  AND A.DATA_DT = V_P_DATE)
  WHEN MATCHED
  THEN UPDATE SET A.DUBIL_BAL_TOT = B.LOAN_ACCT_BAL;
  COMMIT;
  V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;



  V_STEP := V_STEP + 1;
  V_STEP_DESC := '贷款合同信息--零售信贷部分';
  V_STARTTIME := SYSDATE;
  INSERT INTO M_LOAN_CONT_INFO_TEMP02
  (
    DATA_DT                  --数据日期
    ,LGL_REP_ID              --法人编号
    ,CONT_ID                 --合同编号
    ,CONT_NM                 --合同名称
    ,PRIM_CONT_ID            --主合同号
    ,CUST_ID                 --客户编号
    ,ORG_ID                  --机构编号
    ,APP_ID                  --申请编号
    ,CRDT_LMT_ID             --授信额度编号
    ,LOAN_PROD_TYP           --贷款产品类型
    ,LOAN_PROD_NM            --贷款产品名称
    ,CUR                     --币种
    ,CONT_AMT                --合同金额
    ,CONT_START_DT           --合同开始日期
    ,CONT_EXP_DT             --合同到期日期
    ,MAIN_GUA_MODE               --担保方式1
    ,SUB_GUA_MODE               --担保方式2
    ,CUST_MGR_NO             --客户经理工号
    ,LOAN_USEAGE             --贷款用途
    ,DIR_RGN_AREA_CD         --投向地区行政区划
    ,DIR_IDY                 --投向行业
    ,FIN_LOAN_REL_LC_NO      --融资贷款关联信用证号
    ,CONT_SIGN_DT            --合同签订日期
    ,COOP_AGRT_ID            --合作协议编号
    ,CUST_DATA_AUTH_ID       --客户数据授权书编号
    ,GRANT_EFF_DT            --授权生效日期
    ,GRANT_END_DT            --授权终止日期
    ,PNR_RESP_AMT            --合作方责任金额
    ,APP_PSN_TEL             --申请人联系电话
    ,CONT_STAT               --合同状态
    ,DEPT_LINE               --部门条线
    ,DATA_SRC                --数据来源
    ,GUAR_RATE               --担保率
    ,MON_FLG                 --月口径标识
    ,TERMNT_DT               --终止日期
    ,LOAN_HAPP_TYPE_CD       --贷款发生类型
    ,HIGH_TECH_PROPERTY_TYPE_CD
                             --高技术产业类型代码
    ,DIGIT_ECON_CORE_PROPERTY_TYPE_CD
                             --数字经济核心产业类型代码
    ,INTEL_PROP_INTE_PROPERTY_TYPE_CD
                             --知识产权密集型产业类型代码
    ,CUL_PROPERTY_FLG        --文化产业标志
    ,STRATE_NEW_INDUS_TYPE_CD--战略性新兴产业类型代码

    )
   SELECT
         V_P_DATE                                     DATA_DT                    --数据日期
         ,A.LP_ID                                     LGL_REP_ID                 --法人编号
         ,A.CONT_ID                                   CONT_ID                    --合同编号
         ,NVL(TRIM(A.CONT_NAME),A.CONT_ID)            CONT_NM                    --合同名称
         ,A.CONT_ID                                   PRIM_CONT_ID               --主合同号
         ,A.CUST_ID                                   CUST_ID                    --客户编号
         ,A.ACCT_INSTIT_ID                            ORG_ID                     --机构编号
         ,A.APV_FLOW_NUM                              APP_ID                     --申请编号     MODIFY BY MW 2022/11/26
         ,A.LMT_CONT_ID                               CRDT_LMT_ID                --授信额度编号 MODIFY BY MW 2022/11/26
         ,CASE WHEN TE.TAR_VALUE_CODE IS NOT NULL THEN TE.TAR_VALUE_CODE
               WHEN PROD.PROD_ID IS NOT NULL THEN PROD.PROD_ID
               ELSE '01' --个人贷款
           END                                        LOAN_PROD_TYP              --贷款产品类型   --modify by xieyugeng 20221021
         ,A.PROD_NAME                                 LOAN_PROD_NM               --贷款产品名称
         ,A.CURR_CD                                   CUR                        --币种
         ,A.CONT_AMT                                  CONT_AMT                   --合同金额
         ,CASE WHEN TO_CHAR(A.START_DT,'YYYYMMDD') IN ('00010101','29991231')
               THEN NULL
               ELSE TO_CHAR(A.START_DT,'YYYYMMDD')
           END                                        CONT_START_DT              --合同开始日期
         ,CASE WHEN TO_CHAR(A.EXP_DT,'YYYYMMDD') NOT IN ('00010101','29991231')
               THEN TO_CHAR(A.EXP_DT,'YYYYMMDD')                                 --Hulj7月版数仓才加到期日期
               WHEN TO_CHAR(A.TERMNT_DT,'YYYYMMDD') NOT IN ('00010101','29991231')
               THEN TO_CHAR(A.TERMNT_DT,'YYYYMMDD')
           END                                        CONT_EXP_DT                --合同到期日期
         ,NVL(TC.TAR_VALUE_CODE,'Z')                  MAIN_GUA_MODE              --主担保方式
         ,A.SUB_GUAR_WAY_CD                           SUB_GUA_MODE               --子担保方式
         ,A.CUST_MGR_ID                               CUST_MGR_NO                --客户经理工号
         ,C.CD_DESCB                                  LOAN_USEAGE                --贷款用途
         ,NULL                                        DIR_RGN_AREA_CD            --投向地区行政区划代码
         ,A.DIR_INDUS_CD                              DIR_IDY                    --投向行业
         ,NULL                                        FIN_LOAN_REL_LC_NO         --融资贷款关联信用证号  --零售无
         ,CASE WHEN TO_CHAR(A.SIGN_DT,'YYYYMMDD') IN ('00010101','29991231')
               THEN NULL
               ELSE TO_CHAR(A.SIGN_DT,'YYYYMMDD')
           END                                         CONT_SIGN_DT               --合同签订日期
         ,CASE WHEN A.PROD_ID IN ('202020200005','202020200006') THEN '华兴深分后海合字第20191007001号' --网商小贷
               WHEN A.PROD_ID IN ('202010200003') THEN '业务合作协议20181206号'  --玖富万卡
               WHEN A.PROD_ID IN ('202020200003','202010200004') THEN '华兴微贷合作字第201904001号华兴普惠20191216001'  --人保助贷（经营/消费）
               WHEN A.PROD_ID IN ('202010200008') THEN '粤华银零售审批【2019】0029号' --趣店引流贷
               WHEN A.PROD_ID IN ('202020200002','202010200005') --平安普惠/平安普惠（消费）
                    AND A.START_DT >= TO_DATE('20201010','YYYYMMDD')
                    AND A.START_DT <= TO_DATE('20210118','YYYYMMDD')
                    AND (NVL(TRIM(A.INCRE_CRDT_MODE_CD),' ') IN ('共保','44INS_36GR_20GUR','49.5INS_40.5GR_10GUR')
                         OR NVL(TRIM(A.INCRE_CRDT_MODE_CD),' ') LIKE '%\_%\_%' ESCAPE '\')  --增信模式
                THEN '华兴R20201010-0'  --平安普惠（经营/消费）+四方+2020年10月10日至2022年10月9日
               WHEN A.PROD_ID IN ('202020200002','202010200005')
                    AND A.START_DT >= TO_DATE('20210119','YYYYMMDD')
                    --AND A.START_DT <= TO_DATE('20221201','YYYYMMDD')
                    AND A.START_DT <= TO_DATE('20221124','YYYYMMDD')  --MOD BY LIP 20221207 根据张家伟反馈的最新协议信息修改
                    AND (NVL(TRIM(A.INCRE_CRDT_MODE_CD),' ') IN ('共保','44INS_36GR_20GUR','49.5INS_40.5GR_10GUR')
                         OR NVL(TRIM(A.INCRE_CRDT_MODE_CD),' ') LIKE '%\_%\_%' ESCAPE '\')  --增信模式
                THEN '华兴R20210119-01'  --平安普惠（经营/消费）+四方+2021年1月19日至2022年11月24日
               --ADD BY LIP 20221207 根据张家伟反馈的最新协议信息修改
               WHEN A.PROD_ID IN ('202020200002','202010200005')
                    AND A.START_DT >= TO_DATE('20221125','YYYYMMDD')
                    AND A.START_DT <= TO_DATE('20241108','YYYYMMDD')
                    AND (NVL(TRIM(A.INCRE_CRDT_MODE_CD),' ') IN ('共保','44INS_36GR_20GUR','49.5INS_40.5GR_10GUR')
                         OR NVL(TRIM(A.INCRE_CRDT_MODE_CD),' ') LIKE '%\_%\_%' ESCAPE '\')  --增信模式
                THEN '华兴R20221125-01'  --平安普惠（经营/消费）+四方+2022年11月25日至2024年11月8日
               WHEN A.PROD_ID IN ('202020200002','202010200005')
                    AND A.START_DT >= TO_DATE('20181130','YYYYMMDD')
                    AND A.START_DT <= TO_DATE('20210103','YYYYMMDD')
                    AND (NVL(TRIM(A.INCRE_CRDT_MODE_CD),'0') IN ('0','-','非共保','80%INS_20%GUR','99%ins_1%gur','90%INS_10%GU')
                         OR NVL(TRIM(A.INCRE_CRDT_MODE_CD),' ') LIKE '%\_%' ESCAPE '\')  --增信模式
               THEN '华兴R20181130-01'  --平安普惠（经营/消费）+三方+2018年11月30日至2021年1月3日
               WHEN A.PROD_ID IN ('202020200002','202010200005')
                    AND A.START_DT >= TO_DATE('20210104','YYYYMMDD')
                    AND A.START_DT <= TO_DATE('20210118','YYYYMMDD')
                    AND (NVL(TRIM(A.INCRE_CRDT_MODE_CD),'0') IN ('0','-','非共保','80%INS_20%GUR','99%ins_1%gur','90%INS_10%GU')
                         OR NVL(TRIM(A.INCRE_CRDT_MODE_CD),' ') LIKE '%\_%' ESCAPE '\')  --增信模式
                THEN '华兴R20210104-01'  --平安普惠（经营/消费）+三方+2021年1月4日至2021年1月18日
               WHEN A.PROD_ID IN ('202020200002','202010200005')
                    AND A.START_DT >= TO_DATE('20210119','YYYYMMDD')
                    --AND A.START_DT <= TO_DATE('20221201','YYYYMMDD')
                    AND A.START_DT <= TO_DATE('20221124','YYYYMMDD')  -- 根据张家伟反馈的最新协议信息修改
                    AND (NVL(TRIM(A.INCRE_CRDT_MODE_CD),'0') IN ('0','-','非共保','80%INS_20%GUR','99%ins_1%gur','90%INS_10%GU')
                         OR NVL(TRIM(A.INCRE_CRDT_MODE_CD),' ') LIKE '%\_%' ESCAPE '\')  --增信模式
                THEN '华兴R20210119-02'  --平安普惠（经营/消费）+三方+2021年1月19日至2022年11月24日
               --根据张家伟反馈的最新协议信息修改
               WHEN A.PROD_ID IN ('202020200002','202010200005')
                    AND A.START_DT >= TO_DATE('20221125','YYYYMMDD')
                    AND A.START_DT <= TO_DATE('20241108','YYYYMMDD')
                    AND (NVL(TRIM(A.INCRE_CRDT_MODE_CD),'0') IN ('0','-','非共保','80%INS_20%GUR','99%ins_1%gur','90%INS_10%GU')
                         OR NVL(TRIM(A.INCRE_CRDT_MODE_CD),' ') LIKE '%\_%' ESCAPE '\')  --增信模式
                THEN '华兴R20221125-02'  --平安普惠（经营/消费）+三方+2022年11月25日至2024年11月8日
               WHEN A.PROD_ID IN ('202020200002','202010200005')
                    AND A.START_DT >= TO_DATE('20221115','YYYYMMDD')
                    AND A.START_DT <= TO_DATE('20241108','YYYYMMDD')
                    AND NVL(TRIM(A.INCRE_CRDT_MODE_CD),'0') IN ('100%GUR')  --增信模式
                THEN '华兴R20221115-01'  --平安普惠（经营/消费）+两方+2022年11月15日至2024年11月8日
           END                                        COOP_AGRT_ID               --合作协议编号    --mod by hulj 20221220
         ,NVL(TB.CUST_DATA_AUTH_ID,'合作方未提供')    CUST_DATA_AUTH_ID          --客户数据授权书编号
        /* ,CASE WHEN A.PROD_ID IN ('02001004165073','02001006155012','02001006295191','02001006305010',
                                  '02001006310010','02001004220010','02001006160045')
               THEN TO_CHAR(A.SIGN_DT,'YYYYMMDD')
           END                                        GRANT_EFF_DT               --授权生效日期*/
         ,CASE WHEN A.PROD_ID IN ('202010200005','202020200002',--平安普惠
                                 '202020200003','202020200004','202010200004',--人保助贷
                                 '202020200005','202020200005',202020200006) --网商小贷
               THEN TO_CHAR(A.SIGN_DT,'YYYYMMDD')
               END                                    GRANT_EFF_DT               --授权生效日期
         /*,CASE WHEN A.PROD_ID IN ('02001004165073','02001006155012','02001006295191','02001006305010',
                                  '02001006310010','02001004220010','02001006160045')
              THEN CASE \*WHEN TO_CHAR(A.EXP_DT,'YYYYMMDD') NOT IN ('00010101','29991231')
                        THEN TO_CHAR(A.EXP_DT,'YYYYMMDD') --ADD BY LIP 增加合同的到期日*\--7月版才给加到期日期
                        WHEN TO_CHAR(A.TERMNT_DT,'YYYYMMDD') NOT IN ('00010101','29991231')
                        THEN TO_CHAR(A.TERMNT_DT,'YYYYMMDD')
                    END
           END                                        GRANT_END_DT               --授权终止日期*/
         ,CASE WHEN A.PROD_ID IN ('202010200005','202020200002',--平安普惠
                                 '202020200003','202020200004','202010200004',--人保助贷
                                 '202020200005','202020200005',202020200006) --网商小贷
               THEN CASE WHEN TO_CHAR(A.EXP_DT,'YYYYMMDD') NOT IN ('00010101','29991231')
                        THEN TO_CHAR(A.EXP_DT,'YYYYMMDD') --ADD BY LIP 增加合同的到期日*\--7月版才给加到期日期
                        WHEN TO_CHAR(A.TERMNT_DT,'YYYYMMDD') NOT IN ('00010101','29991231')
                        THEN TO_CHAR(A.TERMNT_DT,'YYYYMMDD')
                    END
           END                                        GRANT_END_DT               --授权终止日期*/
         ,CASE WHEN A.PROD_ID IN ( '202020200005','202020200005','202020200006') THEN A.CONT_AMT --网商小贷
               WHEN A.PROD_ID IN ('202010200003') THEN A.CONT_AMT --0  --玖富万卡 20220422张家伟邮件
               WHEN A.PROD_ID IN ( '202020200003','202020200004','202010200004') THEN A.CONT_AMT  --人保助贷（经营/消费）
               WHEN A.PROD_ID IN ('202010200008') THEN A.CONT_AMT --0 --趣店 20220422张家伟邮件
               WHEN A.PROD_ID IN ('202010200005','202020200002')THEN A.CONT_AMT  --平安普惠（经营/消费）
           END                                        PNR_RESP_AMT                     --合作方责任金额
         ,NVL(TRIM(E.OPEN_ACCT_RSRV_MOBILE_NO),TRIM(E.CONT_NUM)) APP_PSN_TEL     --申请人联系电话
         ,NVL(TA.TAR_VALUE_CODE,'99')                 CONT_STAT                  --合同状态
         ,NULL                                        DEPT_LINE                  --部门条线
         ,'零售贷款'                                   DATA_SRC                   --数据来源
         ,CASE WHEN A.CONT_AMT = 0
               THEN  0
               WHEN  nvl(H1.RELA_AMT,0)/ A.cont_amt >= 1
               then 1
               else
               round( nvl(H1.RELA_AMT,0) / A.cont_amt ,8)
               end                                   GUAR_RATE    --担保率
         ,CASE WHEN ( A.TERMNT_DT >= V_MONTH_START_DATE OR A.TERMNT_DT = TO_DATE('00010101','YYYYMMDD'))
               THEN 'Y'
               ELSE 'N'
               END                                   MON_FLG      --月口径标识
         ,TO_CHAR(A.TERMNT_DT,'YYYYMMDD')            TERMNT_DT    --终止日期   --ADD BY MW 20221126 原筛选条件放开，增加字段
         ,A.LOAN_HAPP_TYPE_CD                        LOAN_HAPP_TYPE_CD     --贷款发生类型
         ,CASE SUBSTR(REPLACE(NVL(TRIM(A.HIGH_TECH_PROPERTY_TYPE_CD),'08'),'999999','08'),1,2) --modify by weiyongzhao 20221116 优化逻辑
                WHEN '01' THEN '01' --医药制造业
                WHEN '02' THEN '02' --航空、航天器及设备制造业
                WHEN '03' THEN '03' --电子及通信设备制造业
                WHEN '04' THEN '04' --计算机及办公设备制造业
                WHEN '05' THEN '05' --医疗仪器设备及仪器仪表制造业
                WHEN '06' THEN '06' --信息化学品制造业
                WHEN '08' THEN '08' --非高技术产业
                WHEN '-'  THEN '08' --非高技术产业
                ELSE '07' --高技术服务业
          END                                         HIGH_TECH_PROPERTY_TYPE_CD  --高技术产业类型代码
         ,CASE SUBSTR(REPLACE(NVL(TRIM(A.DIGIT_ECON_CORE_PROPERTY_TYPE_CD),'06'),'999999','06'),1,2) --modify by weiyongzhao 20221116 优化逻辑
                WHEN '01' THEN '01' --数字产品制造业
                WHEN '02' THEN '02' --数字产品服务业
                WHEN '03' THEN '03' --数字技术应用业
                WHEN '04' THEN '04' --数字要素驱动业
                WHEN '05' THEN '05' --数字化效率提升业
                WHEN '06' THEN '06' --非数据经济核心产业
                ELSE '06' --非数据经济核心产业
          END                                        DIGIT_ECON_CORE_PROPERTY_TYPE_CD  --数字经济核心产业类型代码
          ,DECODE(SUBSTR(NVL(TRIM(A.INTEL_PROP_INTE_PROPERTY_TYPE_CD),'99'),1,2),'99','0','-','0','1')
                                                     INTEL_PROP_INTE_PROPERTY_TYPE_CD  --知识产权密集型产业类型代码
          ,DECODE(SUBSTR(NVL(TRIM(A.CUL_AND_RELA_PROPERTY_TYPE_CD),'99'),1,2),'99','0','-','0','1')
                                                     CUL_PROPERTY_FLG        --文化产业标志
    	    ,CASE SUBSTR(REPLACE(NVL(TRIM(A.STRTG_NEW_INDUS_TYPE_CD),'0'),'999999','0'),1,1) -- 零售部分的战略性新兴产业类型代码修正映射关系
                  WHEN '0' THEN '0' --非战略新兴产业
                  WHEN '7' THEN '1' --节能环保
                  WHEN '1' THEN '2' --新一代信息技术
                  WHEN '4' THEN '3' --生物医药
                  WHEN '2' THEN '4' --高端装备制造
                  WHEN '6' THEN '5' --新能源
                  WHEN '3' THEN '6' --新材料
                  WHEN '5' THEN '7' --新能源汽车
                  WHEN '8' THEN '8' --数字创意产业
                  WHEN '9' THEN '9' --相关服务业
                  ELSE '0' --非战略新兴产业
          END                                        STRATE_NEW_INDUS_TYPE_CD--战略性新兴产业类型代码
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO A --零售贷款合同信息
    LEFT JOIN(SELECT H.CONT_ID,SUM(H.RELA_AMT) RELA_AMT
              FROM O_IML_AGT_LOAN_CONT_RELA_TAB_INFO_H H
              WHERE H.OBJ_TYPE_NAME= 'GuarantyContract'
              GROUP BY H.CONT_ID) H1
         ON H1.CONT_ID = A.CONT_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO E --个人客户基本信息
      ON E.CUST_ID = A.CUST_ID
     AND E.ETL_DT = V_DATE
    LEFT JOIN RRP_MDL.ADD_LOAN_DUBIL_CUST_DATA_AUTH_ID TB --贷款合同对应客户数据授权书编号 目前只有网商小贷有，合同号不重复
      ON TB.CONT_ID = A.CONT_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO PROD --标准产品信息
      ON PROD.PROD_ID = A.PROD_ID
     AND PROD.ETL_DT = V_DATE
    LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD C --公共代码表  --CD1274贷款用途  ADD BY MW 20221126
      ON C.CD_VAL = A.BORW_USAGE_TYPE_CD
     AND C.CD_ID = 'CD1274'
    LEFT JOIN RRP_MDL.CODE_MAP TA --合同状态转码 CD1259-->D0117
      ON TA.SRC_VALUE_CODE = A.CONT_STATUS_CD
     AND TA.SRC_CLASS_CODE = 'CD2586'
     AND TA.TAR_CLASS_CODE = 'D0117'
     AND TA.MOD_FLG = 'MDM' --监管集市明细层
    LEFT JOIN RRP_MDL.CODE_MAP TC --担保方式1转码 CD1244-->D0037
      ON TC.SRC_VALUE_CODE = A.MAJOR_GUAR_WAY_CD
     AND TC.SRC_CLASS_CODE = 'CD2656'
     AND TC.TAR_CLASS_CODE = 'D0002'
     AND TC.MOD_FLG = 'MDM' --监管集市明细层
     LEFT JOIN RRP_MDL.CODE_MAP TE  --码值映射表(贷款类型) --modify by xieyugeng 20221021
      ON A.PROD_ID = TE.SRC_VALUE_CODE
      AND TE.SRC_CLASS_CODE = 'STD0002'
      AND TE.TAR_CLASS_CODE = 'T0001'
      AND TE.MOD_FLG = 'MDM'
   WHERE /*(D.CONT_ID IS NOT NULL OR A.TERMNT_DT >= V_MONTH_START_DATE OR A.TERMNT_DT = TO_DATE('00010101','YYYYMMDD'))
     AND*/ A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '贷款合同信息--联合网贷部分';
  V_STARTTIME := SYSDATE;
  INSERT INTO M_LOAN_CONT_INFO_TEMP02
  (
    DATA_DT                  --数据日期
    ,LGL_REP_ID              --法人编号
    ,CONT_ID                --合同编号
    ,CONT_NM                --合同名称
    ,PRIM_CONT_ID            --主合同号
    ,CUST_ID                --客户编号
    ,ORG_ID                  --机构编号
    ,APP_ID                  --申请编号
    ,CRDT_LMT_ID            --授信额度编号
    ,LOAN_PROD_TYP          --贷款产品类型
    ,LOAN_PROD_NM            --贷款产品名称
    ,CUR                    --币种
    ,CONT_AMT                --合同金额
    ,CONT_START_DT          --合同开始日期
    ,CONT_EXP_DT            --合同到期日期
    ,MAIN_GUA_MODE              --担保方式1
    ,SUB_GUA_MODE              --担保方式2
    ,CUST_MGR_NO            --客户经理工号
    ,LOAN_USEAGE            --贷款用途
    ,DIR_RGN_AREA_CD        --投向地区行政区划
    ,DIR_IDY                --投向行业
    ,FIN_LOAN_REL_LC_NO      --融资贷款关联信用证号
    ,CONT_SIGN_DT            --合同签订日期
    ,COOP_AGRT_ID            --合作协议编号
    ,CUST_DATA_AUTH_ID      --客户数据授权书编号
    ,GRANT_EFF_DT            --授权生效日期
    ,GRANT_END_DT            --授权终止日期
    ,PNR_RESP_AMT            --合作方责任金额
    ,APP_PSN_TEL            --申请人联系电话
    ,CONT_STAT              --合同状态
    ,DEPT_LINE              --部门条线
    ,DATA_SRC                --数据来源
    ,TERMNT_DT               --终止日期
    ,MON_FLG                 --月标识
    ,LOAN_HAPP_TYPE_CD       --贷款发生类型
    ,HIGH_TECH_PROPERTY_TYPE_CD
                             --高技术产业类型代码
    ,DIGIT_ECON_CORE_PROPERTY_TYPE_CD
                             --数字经济核心产业类型代码
    ,INTEL_PROP_INTE_PROPERTY_TYPE_CD
                             --知识产权密集型产业类型代码
    ,CUL_PROPERTY_FLG        --文化产业标志
    ,STRATE_NEW_INDUS_TYPE_CD--战略性新兴产业类型代码
    )
   WITH ADD_LOAN_NET_COOP_SUB_TMP AS (
      SELECT DISTINCT T.COOP_AGRT_ID,
             TO_DATE(T.AGRT_START_DT||' 000000','YYYYMMDD HH24MISS') AGRT_START_DT,
             CASE WHEN T.COOP_AGRT_ID ='XZI32018000164' THEN TO_DATE(T.ACT_END_DT||' 235959','YYYYMMDD HH24MISS')-1
                  ELSE TO_DATE(T.ACT_END_DT||' 235959','YYYYMMDD HH24MISS')
              END ACT_END_DT,
             T.DATA_SRC,T.COOP_PROD,
             SUBSTR(T.COOP_PROD, 1, INSTR(T.COOP_PROD, '、') - 1) COOP_PROD1,
             SUBSTR(T.COOP_PROD, INSTR(T.COOP_PROD, '、') + 1) COOP_PROD2
        FROM ADD_LOAN_NET_COOP_SUB T),
     ADD_LOAN_NET_COOP_SUB_TMP1 AS (
      SELECT COOP_AGRT_ID,
             AGRT_START_DT,
             ACT_END_DT,
             DATA_SRC,
             COOP_PROD1,
             COOP_PROD2,
             ROW_NUMBER() OVER(PARTITION BY COOP_PROD ORDER BY ACT_END_DT DESC,AGRT_START_DT DESC) RN
        FROM ADD_LOAN_NET_COOP_SUB_TMP T),
   UNITE_WL_DISTR_DTL AS (SELECT B.DUBIL_ID,SUM(B.DISTR_AMT) DISTR_AMT
           FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DISTR_DTL B
          INNER JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO TA
             ON TA.DUBIL_ID = B.DUBIL_ID
            AND TA.ETL_DT = V_DATE
          WHERE B.JOB_CD LIKE 'myhb%'
            AND B.DISTR_AMT > 0
            AND B.ETL_DT <= V_DATE
          GROUP BY B.DUBIL_ID) --花呗的放款金额从流水表中取数
  SELECT
          V_P_DATE                                    DATA_DT                    --数据日期
         ,A.LP_ID                                     LGL_REP_ID                 --法人编号
         ,A.DUBIL_ID                                  CONT_ID                    --合同编号
         ,A.DUBIL_ID                                  CONT_NM                    --合同名称
         ,A.DUBIL_ID                                  PRIM_CONT_ID               --主合同号
         ,A.CUST_ID                                   CUST_ID                    --客户编号
         ,A.ACCT_INSTIT_ID                            ORG_ID                     --机构编号
         ,A.RELA_APPL_FLOW_NUM                        APP_ID                     --申请编号    MODIFY  BY MW 2022/11/26
         ,T3.LMT_CONT_ID                              CRDT_LMT_ID                --授信额度编号
         ,CASE WHEN D.TAR_VALUE_CODE IS NOT NULL THEN D.TAR_VALUE_CODE
               ELSE '01'  --个人贷款
           END                                        LOAN_PROD_TYP              --贷款产品类型   --modify by xieyugeng 20221021
         ,T4.PROD_NAME                                LOAN_PROD_NM               --贷款产品名称 ----modify by hulj 20221021
         ,A.CURR_CD                                   CUR                        --币种
         ,NVL(DTL.DISTR_AMT,A.CONT_AMT)               LOAN_AMT                    --借款金额 --放款金额从流水表中取
         ,CASE WHEN TO_CHAR(A.DISTR_DT,'YYYYMMDD') IN ('00010101')
               THEN NULL
               ELSE TO_CHAR(A.DISTR_DT,'YYYYMMDD')
           END                                        CONT_START_DT              --合同开始日期
         ,CASE WHEN TO_CHAR(A.EXP_DT,'YYYYMMDD') IN ('00010101')
               THEN NULL
               ELSE TO_CHAR(A.EXP_DT,'YYYYMMDD')
           END                                        CONT_EXP_DT                --合同到期日期
         ,NVL(TB.TAR_VALUE_CODE,'Z')                  MAIN_GUA_MODE                  --担保方式1
         ,NULL                                        SUB_GUA_MODE                  --担保方式2
         ,/*CASE WHEN TRIM(A.CUST_MGR_ID) IS NOT NULL THEN TRIM(A.CUST_MGR_ID)
               WHEN A.STD_PROD_ID IN ('202020200004','202020100001') THEN '00200423'  --网商贷 杨光泽
               ELSE '00100673' --梁秋茹
           END*/
          A.CUST_MGR_ID                               CUST_MGR_NO                --客户经理工号  --modify by hulj 20221021
         ,T5.CD_DESCB                                 LOAN_USEAGE                --贷款用途
         ,NULL                                        DIR_RGN_AREA_CD            --投向地区行政区划代码
         ,A.DIR_INDUS_CD                              DIR_IDY                    --投向行业
         ,NULL                                        FIN_LOAN_REL_LC_NO         --融资贷款关联信用证号
         ,CASE WHEN TO_CHAR(A.OPEN_ACCT_DT,'YYYYMMDD') IN ('00010101','29991231')
               THEN NULL
               ELSE TO_CHAR(A.OPEN_ACCT_DT,'YYYYMMDD')
               END                                    CONT_SIGN_DT               --合同签订日期
         ,CASE WHEN TRIM(C.COOP_AGRT_ID) IS NOT NULL THEN TRIM(C.COOP_AGRT_ID)
               WHEN TRIM(F.COOP_AGRT_ID) IS NOT NULL THEN TRIM(F.COOP_AGRT_ID)
               WHEN TRIM(CC.COOP_AGRT_ID) IS NOT NULL THEN TRIM(CC.COOP_AGRT_ID)
               WHEN TRIM(FF.COOP_AGRT_ID) IS NOT NULL THEN TRIM(FF.COOP_AGRT_ID)
           END                                        COOP_AGRT_ID               --合作协议编号 --MODIFY BY LIP 20220530 根据张家伟反馈数据修改
         ,'合作方未提供'                              CUST_DATA_AUTH_ID          --客户数据授权书编号
         ,TO_CHAR(A.DISTR_DT,'YYYYMMDD')              GRANT_EFF_DT               --授权生效日期
         ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                GRANT_END_DT               --授权终止日期
         ,A.CONT_AMT * ( 1-
          CASE WHEN A.STD_PROD_ID = '202010100003' THEN NVL(A.BANK_CONTRI_RATIO,1)  --蚂蚁花呗
               WHEN A.STD_PROD_ID = '202010100001' THEN NVL(A.BANK_CONTRI_RATIO,1) --蚂蚁借呗二期
               WHEN A.STD_PROD_ID = '202020200004' THEN 1--网商贷 BSN_TYPE = '1900010_LHDZT' THEN '100'
               WHEN A.STD_PROD_ID = '202020100001'
                    AND A.DISTR_DT >= TO_DATE('20190901','YYYYMMDD')
                    AND A.DISTR_DT < TO_DATE('20201207','YYYYMMDD') THEN 1  --网商贷
               WHEN A.STD_PROD_ID = '202020100001'  THEN 0.9  --网商贷
               WHEN A.STD_PROD_ID = '202010100006' THEN NVL(A.BANK_CONTRI_RATIO,1)  --微粒贷
               WHEN A.STD_PROD_ID = '202010100002' THEN /*NVL(A.BANK_CONTRI_RATIO,1)*/1  --蚂蚁借呗三期
               ELSE 0.9   --京东金融
           END)                                       PNR_RESP_AMT               --合作方责任金额   --modify by hulj 20221021
         ,NVL(TRIM(E.OPEN_ACCT_RSRV_MOBILE_NO),TRIM(E.CONT_NUM)) APP_PSN_TEL     --申请人联系电话
         ,NVL(TA.TAR_VALUE_CODE,'99')                 CONT_STAT                  --合同状态 CD1278-->D0117
         ,NULL                                        DEPT_LINE                  --部门条线
         ,'联合网贷部分'                               DATA_SRC                   --数据来源
         ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                TERMNT_DT                  --终止日期
         ,CASE WHEN (((LEAST(CASE WHEN A.PAYOFF_DT = TO_DATE('00010101','YYYYMMDD') THEN V_DATE
                      ELSE A.PAYOFF_DT END,
                 CASE WHEN A.LAST_REPAY_DT = TO_DATE('00010101','YYYYMMDD') THEN V_DATE
                      ELSE A.LAST_REPAY_DT END) >= V_MONTH_START_DATE /*- 1*/
           AND NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0)+ NVL(A.OFF_BS_INT,0)+NVL(A.BAD_DEBT_PRIC,0) >= 0)
           OR NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0) > 0
           OR A.WRT_OFF_FLG = '1')
     AND (NVL(TFF.FIR_WRT_OFF_DT,V_DATE) >= V_MONTH_START_DATE /*- 1*/ OR TFF.FIR_WRT_OFF_DT = TO_DATE('00010101','YYYYMMDD')))
              THEN 'Y'
              ELSE 'N'
              END                                      MON_FLG                    --月口径标识
         ,NULL                                         LOAN_HAPP_TYPE_CD          --贷款发生类型
         ,NULL                                         HIGH_TECH_PROPERTY_TYPE_CD --高技术产业类型代码
    	   ,NULL                                         DIGIT_ECON_CORE_PROPERTY_TYPE_CD
                                                                                  --数字经济核心产业类型代码
         ,NULL                                         INTEL_PROP_INTE_PROPERTY_TYPE_CD
                                                                                  --知识产权密集型产业类型代码
    	   ,NULL                                         CUL_PROPERTY_FLG           --文化产业标志
         ,NULL                                         STRATE_NEW_INDUS_TYPE_CD   --战略性新兴产业类型代码
    FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO A --联合网贷借据信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO E --个人客户基本信息
      ON E.CUST_ID = A.CUST_ID
     AND E.ETL_DT = V_DATE
    LEFT JOIN O_ICL_CMM_UNITE_WL_LMT_INFO T3     --授信额度信息
         ON T3.LMT_RELA_APPL_ID = A.RELA_APPL_FLOW_NUM
         AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_WRT_OFF_INFO TFF  --联合网贷核销信息
      ON TFF.DUBIL_ID = A.DUBIL_ID
     AND TFF.ETL_DT = V_DATE
    LEFT JOIN UNITE_WL_DISTR_DTL DTL
      ON DTL.DUBIL_ID = A.DUBIL_ID
    LEFT JOIN O_ICL_CMM_STD_PROD_INFO  T4        --标准产品信息
         ON T4.PROD_ID = A.PROD_ID
         AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD T5 --公共代码表
      ON T5.CD_VAL=A.LOAN_USAGE_CD
     AND T5.CD_ID ='CD1274'
    LEFT JOIN RRP_MDL.CODE_MAP TA --合同状态转码 CD1278-->D0117
      ON TA.SRC_VALUE_CODE = A.CONT_STATUS_CD
     AND TA.SRC_CLASS_CODE = 'CD1278'
     AND TA.TAR_CLASS_CODE = 'D0117'
     AND TA.MOD_FLG = 'MDM' --监管集市明细层
    LEFT JOIN RRP_MDL.CODE_MAP TB --担保方式1转码 CD1518-->D0037
      ON TB.SRC_VALUE_CODE = A.GUAR_WAY_CD
     AND TB.SRC_CLASS_CODE = 'CD2656'
     AND TB.TAR_CLASS_CODE = 'D0002'
     AND TB.MOD_FLG = 'MDM' --监管集市明细层
    LEFT JOIN ADD_LOAN_NET_COOP_SUB_TMP C
      ON C.COOP_PROD1 = A.STD_PROD_ID
     AND C.AGRT_START_DT <= A.DISTR_DT
     AND C.ACT_END_DT >= A.DISTR_DT
     AND C.COOP_PROD1 IS NOT NULL
    LEFT JOIN ADD_LOAN_NET_COOP_SUB_TMP F
      ON F.COOP_PROD2 = A.STD_PROD_ID
     AND F.AGRT_START_DT <= A.DISTR_DT
     AND F.ACT_END_DT >= A.DISTR_DT
     AND F.COOP_PROD2 IS NOT NULL
    LEFT JOIN ADD_LOAN_NET_COOP_SUB_TMP1 CC
      ON CC.COOP_PROD1 = A.STD_PROD_ID
     AND CC.RN = 1
     AND CC.COOP_PROD1 IS NOT NULL
    LEFT JOIN ADD_LOAN_NET_COOP_SUB_TMP1 FF
      ON FF.COOP_PROD2 = A.STD_PROD_ID
     AND FF.RN = 1
     AND FF.COOP_PROD2 IS NOT NULL
/*    LEFT JOIN RRP_MDL.ADD_DUBILL_LOAN_BIZ_TYP D
      ON D.BUS_BREED_ID = A.BUS_BREED_ID
     AND D.DATE_SOURCESD = 'LHWD'
     AND D.MIAN_ACCT_TYP_FLAG = '1'*/
      LEFT JOIN RRP_MDL.CODE_MAP D  --码值映射表(贷款类型)  --modify by xieyugeng 20221021
      ON A.STD_PROD_ID = D.SRC_VALUE_CODE
      AND D.SRC_CLASS_CODE = 'STD0002'
      AND D.TAR_CLASS_CODE = 'T0001'
      AND D.MOD_FLG = 'MDM'
   WHERE  A.DUBIL_STATUS_CD NOT IN ('2','5') --失败、撤销
     AND A.ETL_DT = V_DATE;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '贷款合同信息--汇总';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_CONT_INFO
    (DATA_DT                          --数据日期
    ,LGL_REP_ID                       --法人编号
    ,CONT_ID                          --合同编号
    ,CONT_NM                          --合同名称
    ,PRIM_CONT_ID                     --主合同号
    ,CUST_ID                          --客户编号
    ,ORG_ID                           --机构编号
    ,APP_ID                           --申请编号
    ,CRDT_LMT_ID                      --授信额度编号
    ,LOAN_PROD_TYP                    --贷款产品类型
    ,LOAN_PROD_NM                     --贷款产品名称
    ,CUR                              --币种
    ,CONT_AMT                         --合同金额
    ,CONT_START_DT                    --合同开始日期
    ,CONT_EXP_DT                      --合同到期日期
    ,MAIN_GUA_MODE                    --主担保方式
    ,SUB_GUA_MODE                     --子担保方式
    ,CUST_MGR_NO                      --客户经理工号
    ,LOAN_USEAGE                      --贷款用途
    ,DIR_RGN_AREA_CD                  --投向地区行政区划代码
    ,DIR_IDY                          --投向行业
    ,FIN_LOAN_REL_LC_NO               --融资贷款关联信用证号
    ,CONT_SIGN_DT                     --合同签订日期
    ,COOP_AGRT_ID                     --合作协议编号
    ,CUST_DATA_AUTH_ID                --客户数据授权书编号
    ,GRANT_EFF_DT                     --授权生效日期
    ,GRANT_END_DT                     --授权终止日期
    ,PNR_RESP_AMT                     --合作方责任金额
    ,APP_PSN_TEL                      --申请人联系电话
    ,CONT_STAT                        --合同状态
    ,DEPT_LINE                        --部门条线
    ,DATA_SRC                         --数据来源
    ,GUAR_RATE                        --担保率
    ,CLERK_ID                         --行员编号
    ,DUBIL_BAL_TOT                    --借据总余额
    ,PAYOFF_FLG                       --结清标记
    ,TERMNT_DT                        --终止日期
    ,MON_FLG                          --月口径标识
    ,LOAN_HAPP_TYPE_CD                --贷款发生类型
    ,HIGH_TECH_PROPERTY_TYPE_CD       --高技术产业类型代码
    ,DIGIT_ECON_CORE_PROPERTY_TYPE_CD --数字经济核心产业类型代码
    ,INTEL_PROP_INTE_PROPERTY_TYPE_CD --知识产权密集型产业类型代码
    ,CUL_PROPERTY_FLG                 --文化产业标志
    ,STRATE_NEW_INDUS_TYPE_CD         --战略性新兴产业类型代码
     ,HIGH_NEW_TECH_CORP_FLG  --高新技术企业标志
    ,SCI_TECH_CORP_FLG       --科技型企业标志
    ,SCI_TECH_INOVT_CORP_FLG --科创企业标志
     )
    WITH TMP1 AS (
      SELECT TLR_NO AS TELLER_ID,EMP_ID AS CLERK_ID,TO_DATE(UPDATE_DT,'YYYYMMDD') AS DIMISSION_DT  FROM ADD_EMP_TLR
      UNION ALL
      SELECT TELLER_ID,CLERK_ID,DIMISSION_DT FROM RRP_MDL.O_ICL_CMM_CLERK_INFO
       WHERE TRIM(TELLER_ID) IS NOT NULL AND ETL_DT = V_DATE),
     CMM_CLERK_INFO AS (
          SELECT TC.TELLER_ID,
                 TC.CLERK_ID,
                 ROW_NUMBER() OVER(PARTITION BY TC.TELLER_ID ORDER BY TC.DIMISSION_DT DESC) RN
            FROM TMP1 TC)
  SELECT DISTINCT
         T.DATA_DT                                         AS DATA_DT                          --数据日期
        ,T.LGL_REP_ID                                      AS LGL_REP_ID                       --法人编号
        ,T.CONT_ID                                         AS CONT_ID                          --合同编号
        ,T.CONT_NM                                         AS CONT_NM                          --合同名称
        ,T.PRIM_CONT_ID                                    AS PRIM_CONT_ID                     --主合同号
        ,T.CUST_ID                                         AS CUST_ID                          --客户编号
        ,/*CASE WHEN TA.ORG_ID1 IS NOT NULL THEN TA.ORG_ID1
              WHEN TB.ORG_ID1 IS NOT NULL THEN TB.ORG_ID1
              WHEN T.ORG_ID LIKE '12%' THEN '898001'
              --ELSE T.ORG_ID
              ELSE '800'
           END*/
         T.ORG_ID                                          AS ORG_ID                           --机构编号
        ,T.APP_ID                                          AS APP_ID                           --申请编号
        ,T.CRDT_LMT_ID                                     AS CRDT_LMT_ID                      --授信额度编号
        ,T.LOAN_PROD_TYP                                   AS LOAN_PROD_TYP                    --贷款产品类型
        ,T.LOAN_PROD_NM                                    AS LOAN_PROD_NM                     --贷款产品名称
        ,T.CUR                                             AS CUR                              --币种
        ,T.CONT_AMT                                        AS CONT_AMT                         --合同金额
        ,T.CONT_START_DT                                   AS CONT_START_DT                    --合同开始日期
        ,T.CONT_EXP_DT                                     AS CONT_EXP_DT                      --合同到期日期
        ,T.MAIN_GUA_MODE                                   AS MAIN_GUA_MODE                    --主担保方式
        ,T.SUB_GUA_MODE                                    AS SUB_GUA_MODE                     --子担保方式
        ,/*CASE WHEN TRIM(C.CLERK_ID) IS NOT NULL THEN TRIM(C.CLERK_ID)
         ELSE TRIM(T.CUST_MGR_NO)
         END  */
        T.CUST_MGR_NO                                      AS CUST_MGR_NO                      --客户经理工号  --MODIFY BY MW 20221123 新一代柜员号和行员号是一致的
        ,T.LOAN_USEAGE                                     AS LOAN_USEAGE                      --贷款用途
        ,T.DIR_RGN_AREA_CD                                 AS DIR_RGN_AREA_CD                  --投向地区行政区划代码
        ,T.DIR_IDY                                         AS DIR_IDY                          --投向行业
        ,T.FIN_LOAN_REL_LC_NO                              AS FIN_LOAN_REL_LC_NO               --融资贷款关联信用证号
        ,T.CONT_SIGN_DT                                    AS CONT_SIGN_DT                     --合同签订日期
        ,T.COOP_AGRT_ID                                    AS COOP_AGRT_ID                     --合作协议编号
        ,T.CUST_DATA_AUTH_ID                               AS CUST_DATA_AUTH_ID                --客户数据授权书编号
        ,T.GRANT_EFF_DT                                    AS GRANT_EFF_DT                     --授权生效日期
        ,T.GRANT_END_DT                                    AS GRANT_END_DT                     --授权终止日期
        ,T.PNR_RESP_AMT                                    AS PNR_RESP_AMT                     --合作方责任金额
        ,T.APP_PSN_TEL                                     AS APP_PSN_TEL                      --申请人联系电话
        ,T.CONT_STAT                                       AS CONT_STAT                        --合同状态
        ,T.DEPT_LINE                                       AS DEPT_LINE                        --部门条线
        ,T.DATA_SRC                                        AS DATA_SRC                         --数据来源
        ,T.GUAR_RATE                                       AS GUAR_RATE                        --担保率
        ,C.CLERK_ID                                        AS CLERK_ID                         --行员编号
        ,T.DUBIL_BAL_TOT                                   AS DUBIL_BAL_TOT                    --借据总金额
        ,T.PAYOFF_FLG                                      AS PAYOFF_FLG                       --结清标记
        ,T.TERMNT_DT                                       AS TERMNT_DT                        --终止日期
        ,T.MON_FLG                                         AS MON_FLG                          --月标识
        ,T.LOAN_HAPP_TYPE_CD                               AS LOAN_HAPP_TYPE_CD                --贷款发生类型
        ,T.HIGH_TECH_PROPERTY_TYPE_CD                      AS HIGH_TECH_PROPERTY_TYPE_CD       --高技术产业类型代码
        ,T.DIGIT_ECON_CORE_PROPERTY_TYPE_CD                AS DIGIT_ECON_CORE_PROPERTY_TYPE_CD --数字经济核心产业类型代码
        ,T.INTEL_PROP_INTE_PROPERTY_TYPE_CD                AS INTEL_PROP_INTE_PROPERTY_TYPE_CD --知识产权密集型产业类型代码
        ,T.CUL_PROPERTY_FLG                                AS CUL_PROPERTY_FLG                 --文化产业标志
        ,T.STRATE_NEW_INDUS_TYPE_CD                        AS STRATE_NEW_INDUS_TYPE_CD         --战略性新兴产业类型代码
        ,T.HIGH_NEW_TECH_CORP_FLG                          AS HIGH_NEW_TECH_CORP_FLG           --高新技术企业标志
        ,T.SCI_TECH_CORP_FLG                               AS SCI_TECH_CORP_FLG                --科技型企业标志
        ,T.SCI_TECH_INOVT_CORP_FLG                         AS SCI_TECH_INOVT_CORP_FLG          --科创企业标志
   FROM RRP_MDL.M_LOAN_CONT_INFO_TEMP02 T
   LEFT JOIN CMM_CLERK_INFO C --行员信息
     ON C.TELLER_ID = TRIM(T.CUST_MGR_NO)
    AND C.RN = 1
/*   LEFT JOIN RRP_MDL.ORG_CONFIG TA
     ON TA.ORG_ID = T.ORG_ID
   LEFT JOIN RRP_MDL.ORG_CONFIG TB
     ON TB.ORG_ID = SUBSTR(T.ORG_ID,1,3)*/                 --MODIFY BY MW 20221123  模型层取消机构转码
  WHERE NVL(T.CONT_START_DT,V_P_DATE) <= V_P_DATE; --过滤开始时间大于采集日期的数据
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


  --记录正常日志
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '贷款合同信息--查询数据是否重复';
  V_STARTTIME := SYSDATE;

  WITH TMP1 AS (
  SELECT DATA_DT,CONT_ID,COUNT(1)
    FROM RRP_MDL.M_LOAN_CONT_INFO T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,CONT_ID
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  RETURN;
  END IF;

  -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

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
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;

   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_INIT_M_LOAN_CONT_INFO;
/

