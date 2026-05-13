CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_LOAN_CONT_INFO(I_P_DATE IN INTEGER, --跑批日期
                                                 O_ERRCODE OUT VARCHAR2 --错误代码
                                                 )
  /**************************************************************************
  *  程序名称：ETL_M_LOAN_CONT_INFO
  *  功能描述：贷款合同信息
  *  创建日期：20220519
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_LOAN_CONT_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220519  梅炜    首次创建
  *             2    20220819  HULJ    调整合同号和客户号逻辑，增加数据重复校验逻辑
  *             3    20221021  HULJ    调整对公、零售、联合网贷贷款产品类型,客户经理,合作方责任金额取值口径
  *             4    20221022  MW      调整合作协议、协议日期取值及产品编号映射关系
  *             5    20221108  HULJ    调整零售贷款部分三方,四方协议口径
  *             6    20221220  HULJ    调整零售贷款部分合作协议编号取值
  *             7    20230522  MW      新增微粒贷产品
  *             8    20230612  LIUYU   调整对公担保方式内部口径字段逻辑：业务合同层担保方式内部口径如有空值，取额度合同层担保方式内部口径
  *             9    20230615  HYF     零售部分的战略性新兴产业类型代码不做转换,S_LOAN已做转换
  *             10   20230810  HULJ    新增绿色消费子类代码逻辑
  *             11   20240507  YJY     对公部分加工：战略性新兴产业类型代码、是否投向文化产业
  *                                    新增工业转型升级标识、是否种业振兴贷款、是否县城区贷款、养老产业标志、投向政府和社会资本合作项目标志、新机制发放贷款标志
  *             12   20240528  HYF     新增知识产权产业类型代码、文化及相关产业类型代码
  *             13   20240618  HYF     补充对公部分数字经济核心产业类型代码
  *             14   20240704  LIP     调整京东的月标识标识
  *             15   20240822  LIP     调整零售信贷部分的信贷业务种类映射口径，与表内借据表保持一致，增加零售和联合网贷部分的产品编号取数
  *             16   20240829  YJY     新增高技术服务业贷款标志、高技术服务业贷款类型代码
  *             17   20241010  YJY     新增关系人保证贷款标志字段
  *             18   20241023  HYF     插入目标表那段加入关系人保证贷款
  *             19   20241202  LIP     增加新的平安普惠合作协议
  *             20   20250115  YJY     调整零售信贷部分的月口径标识，新增对房抵贷产品的判断;修改联合网贷部分口径，调整标准产品编号的取值
  *             21   20250219  YJY     新增对公联合网贷-微业贷逻辑
  *             22   20250310  LIP     调整零售信贷部分客户授权书相关信息的取数口径
  *             23   20250328  YJY     调整字节小微贷、微业贷的合作方责任金额取值逻辑
  *             24   20250509  YJY     调整微业贷相关标签逻辑
  *             25   20250605  YJY     新增投向高技术产业标志
  *             26   20250709  LIP     新增产品201010300041华兴好易贷（华强），调整部分字段取数口径
  *             27   20250716  HYF     修改微业贷部分是否投向知识产权密集型产业标志
  *             28   20250718  YJY     新增产品饲料e贷-海大集团-201020100062、兴采贷（大森林）201020100061，调整部分字段取数口径
                                       调整联合网贷部分‘合作方责任金额’逻辑：新增的联合网贷产品默认取借据表的银行出资比例
  *             29   20250811  YJY     调整互联网合作协议字段，华兴好易贷（经营-担保）201020100059 华兴好易贷（信用） 201010300040为JR20250300
  *             31   20250826  YJY     新增360借条产品，按互联网贷款报送
  *             32   20250829  LAL     一表通，增加创业担保贷款标志
  *             33   20250923  YJY     调整360借条的合作协议
  *             33   20250912  PSF     新增客户产业结构调整类型代码字段，调整 工业转型升级标志、战略新兴产业类型 取值
  *             34   20251014  LIP     根据张家伟提供口径，20250801后发放的字节贷款，报CT20250306101185和CT20250306101185-1两个协议
  *             35   20251016  CJJ     一表通，新增年标识
  *             36   20251017  ZLY     一表通，新增审批员工ID
  *             37   20251021  ZLY     工业企业技术改造升级标志、战略新兴产业类型取值逻辑还原为PSF修改前
  *             38   20251103  LIP     201020100062 饲料e贷-海大集团的互联网合作协议置空，是独立的非合作的
  *             39   20251104  YJY     联合网贷部分，调整月口径标识字段，对分期乐、好企贷-数据贷（微业贷3.0）的核销日期特殊处理
  *             40   20251110  LIP     互联网合作协议重新映射
  *             41   20251120  YJY     新增203050100002-微众对公联合贷（微业贷4.0）产品
  *             42   20251126  YJY     加工零售部分的养老产业逻辑
  *             43   20251203  LIP     对公部分月报和年报范围逻辑调整，增加合同终止日期的判断
  *             44   20260106  YJY     修改零售信贷部分的养老产业标识，上游信贷调整为码值类字段，模型直取该字段
  *             45   20260112  YJY     插入目标表高技术服务业贷款标志\高技术服务业贷款类型代码
  *             46   20260115  YJY     一表通张柳云反馈合同开始日期存在切日的情况，现调整当合同开始日期大于跑批日期一天时，默认数据为跑批日期
  *             47   20260116  LIP     互联网贷款产品合作协议信息表过滤停用的协议
  *             48   20260129  LIP     增加新授信合同编号，与授信表中授信合同号字段取数一致
  *             49   20260205  LIP     调整业务合同标志取数字段
  *             50   20260316  LIP     垫款和转贴现的贷款用途为空时，参考表内借据表中的用途赋值
  *             51   20260413  YJY     一表通严希婧反馈：203050100002-微众对公联合贷的取联合贷额度信息表的LMT_RELA_APPL_ID--额度关联申请编号（行内授信编号），其他产品取LMT_CONT_ID--额度合同编号
  ********************************************************/
AS
  --定义变量
  V_STEP             INTEGER := 0;               --处理步骤
  V_P_DATE           VARCHAR2(8);                --跑批数据日期
  V_STARTTIME        DATE;                       --处理开始时间
  V_ENDTIME          DATE;                       --处理结束时间
  V_SQLCOUNT         INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG           VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC        VARCHAR2(200);              --任务名称
  V_MONTH_START_DATE DATE;                       --系统时间对应月初日期
  V_YEAR_START_DATE  DATE;                       --系统时间对应月初日期
  V_PART_NAME        VARCHAR2(100);                     --分区名
  V_TAB_NAME         VARCHAR2(100) := 'M_LOAN_CONT_INFO'; --表名
  V_PROC_NAME        VARCHAR2(100) := 'ETL_M_LOAN_CONT_INFO'; --程序名称
  V_SYSTEM           VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_MONTH_START_DATE := TRUNC(TO_DATE(I_P_DATE,'YYYYMMDD'),'MM');
  V_YEAR_START_DATE := TRUNC(TO_DATE(I_P_DATE,'YYYYMMDD'),'YYYY');
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

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
  EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --清理临时表数据
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '贷款合同信息--清理临时表数据';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_LOAN_CONT_INFO_TEMP02';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '贷款合同信息--对公贷款部分';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_LOAN_CONT_INFO_TEMP02
    (DATA_DT                 --数据日期
    ,LGL_REP_ID              --法人编号
    ,CONT_ID                 --合同编号
    ,CONT_NM                 --合同名称
    ,PRIM_CONT_ID            --主合同号
    ,CUST_ID                 --客户编号
    ,ORG_ID                  --机构编号
    ,RGST_ORG_ID             --注册机构
    ,OPER_ORG_ID             --开户机构
    ,APP_ID                  --申请编号
    ,CRDT_LMT_ID             --授信额度编号
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
    ,GRANT_END_DT            --授权终止 日期
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
    ,HIGH_TECH_PROPERTY_TYPE_CD          --高技术产业类型代码
    ,DIGIT_ECON_CORE_PROPERTY_TYPE_CD    --数字经济核心产业类型代码
    ,INTEL_PROP_INTE_PROPERTY_TYPE_CD    --是否投向知识产权密集型产业
    ,CUL_PROPERTY_FLG                    --文化产业标志
    ,STRATE_NEW_INDUS_TYPE_CD            --战略性新兴产业类型代码
    ,HIGH_NEW_TECH_CORP_FLG              --高新技术企业标志
    ,SCI_TECH_CORP_FLG                   --科技型企业标志
    ,SCI_TECH_INOVT_CORP_FLG             --科创企业标志
    ,SPE_SOPH_UNQ_NEW_MED_SIDE_ENTER_FLG --专精特新中小企业标志
    ,SPE_SOPH_UNQ_NEW_LTE_GNT_CORP_FLG   --专精特新小巨人企业标志
    ,CONT_TYPE_CD                        --合同类型代码
    ,INDU_CORP_TECH_REM_UGD_FLG          --工业企业技术改造升级标志   ADD BY YJY 20240507
    ,SEED_LOAN_FLG                       --种业振兴贷款标志           ADD BY YJY 20240507
    ,COUNTY_LOAN_FLG                     --县城区贷款标志             ADD BY YJY 20240507
    ,PROVI_FOR_AGED_PROPERTY_FLG         --养老产业标志               ADD BY YJY 20240507
    ,PPP_PROJ_FLG                        --投向政府和社会资本合作项目标志  ADD BY YJY 20240507
    ,NEW_DISTR_FLG                       --新机制发放贷款标志         ADD BY YJY 20240507
    ,PROP_PROPERTY_TYPE_CD               --知识产权产业类型代码       ADD BY HYF 20240528
    ,CUL_AND_RELA_PPTY_TYPE_CD           --文化及相关产业类型代码     ADD BY HYF 20240528
    ,HIGH_TECH_SERV_LOAN_FLG             --高技术服务业贷款标志       ADD BY YJY 20240829
    ,HIGH_TECH_SERV_LOAN_TYPE_CD         --高技术服务业贷款类型代码   ADD BY YJY 20240829
    ,RELA_PEOP_GUAR_LOAN_FLG             --关系人保证贷款标志         ADD BY YJY 20241010
    ,HIGH_TECH_PROPERTY_FLG              --投向高技术产业标志         ADD BY YJY 20250605
    ,BUID_BUS_GUAR_LOAN_FLG              --创业担保贷款标志           ADD BY LAL 20250829
    ,CUST_INS_ADJ_TYPE_CD                --客户产业结构调整类型代码   ADD BY PSF 20250912
    ,YEAR_FLG                            --年标识                     ADD BY CJJ 20251016
    ,APRV_EMP_NO                         --审批员工ID                 ADD BY ZLY 20251017
    ,CRDT_LMT_ID_NEW                     --新授信合同编号 --ADD BY LIP 20260129
    )
  SELECT  V_P_DATE                                    AS DATA_DT                    --数据日期
         ,A.LP_ID                                     AS LGL_REP_ID                 --法人编号
         ,A.CONT_ID                                   AS CONT_ID                    --合同编号
         ,NVL(TRIM(A.MANU_CONT_ID),A.CONT_ID)         AS CONT_NM                    --合同名称
         ,A.CONT_ID                                   AS PRIM_CONT_ID               --主合同号
         ,A.CUST_ID                                   AS CUST_ID                    --客户编号 --转贴现、福费廷的取对手方的客户号
         ,TRIM(A.MGMT_ORG_ID)                         AS ORG_ID                     --管理机构
         ,TRIM(A.RGST_ORG_ID)                         AS RGST_ORG_ID                --注册机构
         ,TRIM(A.OPER_ORG_ID)                         AS OPER_ORG_ID                --开户机构 --MODIFY BY MW 20221122
         ,A.APV_FLOW_NUM                              AS APP_ID                     --申请编号
         ,A.LMT_CONT_ID                               AS CRDT_LMT_ID                --授信额度编号
         ,CASE WHEN E.TAR_VALUE_CODE IS NOT NULL THEN E.TAR_VALUE_CODE
               WHEN B.PROD_ID IS NOT NULL THEN B.PROD_ID
               ELSE '02'  --个人贷款
           END                                        AS LOAN_PROD_TYP              --贷款产品类型 --modify by xieyugeng 20221021
         ,B.PROD_NAME                                 AS LOAN_PROD_NM               --贷款产品名称
         ,A.CURR_CD                                   AS CUR                        --币种
         ,A.CONT_AMT                                  AS CONT_AMT                   --合同金额
         /*,CASE WHEN TO_CHAR(A.START_DT,'YYYYMMDD') NOT IN ('00010101','29991231') THEN TO_CHAR(A.START_DT,'YYYYMMDD')
               WHEN TO_CHAR(A.DISTR_DT,'YYYYMMDD') NOT IN ('00010101','29991231') THEN TO_CHAR(A.DISTR_DT,'YYYYMMDD')
               ELSE NULL
           END */
         --MOD BY YJY 20260115 一表通要求对切日的数据进行兜底，默认为跑批日当天
         ,CASE WHEN TO_CHAR(A.START_DT,'YYYYMMDD') NOT IN ('00010101','29991231') AND TO_CHAR(A.START_DT,'YYYYMMDD') <= V_P_DATE 
               THEN TO_CHAR(A.START_DT,'YYYYMMDD')
               WHEN TRUNC(A.START_DT) = TO_DATE(V_P_DATE,'YYYYMMDD') +1 
               THEN V_P_DATE --对切日的数据兜底
               WHEN TO_CHAR(A.DISTR_DT,'YYYYMMDD') NOT IN ('00010101','29991231') AND TO_CHAR(A.DISTR_DT,'YYYYMMDD') <= V_P_DATE 
               THEN TO_CHAR(A.DISTR_DT,'YYYYMMDD')
               WHEN TRUNC(A.DISTR_DT) = TO_DATE(V_P_DATE,'YYYYMMDD') +1 
               THEN V_P_DATE --对切日的数据兜底
               ELSE NULL
           END                                       AS CONT_START_DT              --合同开始日期  --modify by tangan at 20221125
         ,CASE WHEN TO_CHAR(A.EXP_DT,'YYYYMMDD') IN ('00010101','29991231')
               THEN NULL
               ELSE TO_CHAR(A.EXP_DT,'YYYYMMDD')
           END                                        AS CONT_EXP_DT                --合同到期日期
         ,NVL(TB.TAR_VALUE_CODE,'Z')                  AS MAIN_GUA_MODE              --主担保方式
         ,CASE WHEN NVL(A.SUB_GUAR_WAY_CD,'-') <> '-' THEN A.SUB_GUAR_WAY_CD
               ELSE D.SUB_GUAR_WAY_CD
           END                                        AS SUB_GUA_MODE               --子担保方式
         --MOD BY LIUYU 20230612 调整担保方式内部口径字段逻辑
         ,COALESCE(TRIM(A.MGMT_TELLER_ID),TRIM(A.RGST_TELLER_ID))
                                                      AS CUST_MGR_NO                --客户经理工号
         --,A.LOAN_USAGE_DESCB                          AS LOAN_USEAGE                --贷款用途
         --MOD BY LIP 20260316 与严希婧确认，垫款和转贴现的贷款用途为空时，参考表内借据表中的用途赋值
         ,CASE WHEN TRIM(A.LOAN_USAGE_DESCB) IS NOT NULL
               THEN TRIM(REPLACE(REPLACE(A.LOAN_USAGE_DESCB,CHR(10),''),CHR(13),''))
               WHEN A.STD_PROD_ID LIKE '20304%' THEN '其他-垫款'
               WHEN A.STD_PROD_ID LIKE '2040101%' THEN '上海票据交易所系统参与者间开展的票据交易'
           END                                        AS LOAN_USEAGE                --贷款用途
         ,NULL                                        AS DIR_RGN_AREA_CD            --投向地区行政区划代码
         ,A.DIR_INDUS_CD                              AS DIR_IDY                    --投向行业
         ,A.LC_ID                                     AS FIN_LOAN_REL_LC_NO         --融资贷款关联信用证号
         ,TO_CHAR(A.DISTR_DT,'YYYYMMDD')              AS CONT_SIGN_DT               --合同签订日期
         ,NULL                                        AS COOP_AGRT_ID               --合作协议编号
         ,NULL                                        AS CUST_DATA_AUTH_ID          --客户数据授权书编号
         ,NULL                                        AS GRANT_EFF_DT               --授权生效日期
         ,NULL                                        AS GRANT_END_DT               --授权终止日期
         ,NULL                                        AS PNR_RESP_AMT               --合作方责任金额
         ,NULL                                        AS APP_PSN_TEL                --申请人联系电话
         ,NVL(TA.TAR_VALUE_CODE,'99')                 AS CONT_STAT                  --合同状态 CD1371-->D0117
         ,NULL                                        AS DEPT_LINE                  --部门条线
         ,'对公信贷'                                  AS DATA_SRC                   --数据来源
         ,CASE WHEN A.CONT_AMT = 0 THEN 0
               WHEN NVL(H1.RELA_AMT,0)/ A.CONT_AMT >= 1 THEN 1
               ELSE ROUND( NVL(H1.RELA_AMT,0) / A.CONT_AMT ,8)
           END                                        AS GUAR_RATE                  --担保率
         ,A.STD_PROD_ID                               AS STD_PROD_ID                --标准产品编号
         ,CASE WHEN A.ACM_DISTR_AMT = A.ACM_CALLBK_AMT THEN 'Y'
               ELSE 'N'
           END                                        AS PAYOFF_FLG                 --结清标记
         ,CASE WHEN (A.VALID_FLG_CD = '2' --2生效，4终结（包括已结清失效和未结清失效）
                    OR (A.VALID_FLG_CD = '4' AND A.ACM_DISTR_AMT <> A.ACM_CALLBK_AMT)) --未结清
                    AND (A.STD_PROD_ID LIKE '2%' OR A.STD_PROD_ID IN ('602060100001','602060100002','602030100001','602030100001','602030100002'))
                    --AND A.CONT_TYPE_CD = '02' --02业务合同
                    AND A.CRDT_TYPE_CD = '02' --02业务合同 --MOD BY LIP 20260205
               THEN 'Y'
               WHEN (A.TERMNT_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') OR TO_CHAR(A.TERMNT_DT,'YYYYMMDD') IN ('00010101'))
                    AND (A.STD_PROD_ID LIKE '2%' OR A.STD_PROD_ID IN ('602060100001','602060100002','602030100001','602030100001','602030100002'))
                    --AND A.CONT_TYPE_CD = '02' --02业务合同
                    AND A.CRDT_TYPE_CD = '02' --02业务合同 --MOD BY LIP 20260205
               THEN 'Y' --通过合同的实际终止日期判断 --MOD BY LIP 20251203
               ELSE 'N'
           END                                        AS MON_FLG                    --月口径标识
         ,TO_CHAR(A.TERMNT_DT,'YYYYMMDD')             AS TERMNT_DT                  --终止日期
         ,A.LOAN_HAPP_TYPE_CD                         AS LOAN_HAPP_TYPE_CD          --贷款发生类型
         ,NULL                                        AS HIGH_TECH_PROPERTY_TYPE_CD --高技术产业类型代码
         ,CASE SUBSTR(REPLACE(NVL(TRIM(C.DIGIT_ECON_CORE_TYPE_CD),'06'),'999999','06'),1,2) --modify by weiyongzhao 20221116 优化逻辑
               WHEN '01' THEN '01' --数字产品制造业
               WHEN '02' THEN '02' --数字产品服务业
               WHEN '03' THEN '03' --数字技术应用业
               WHEN '04' THEN '04' --数字要素驱动业
               WHEN '05' THEN '05' --数字化效率提升业
               WHEN '06' THEN '06' --非数据经济核心产业
               ELSE '06' --非数据经济核心产业
           END                                        AS DIGIT_ECON_CORE_PROPERTY_TYPE_CD    --数字经济核心产业类型代码
         ,NULL                                        AS INTEL_PROP_INTE_PROPERTY_TYPE_CD    --是否投向知识产权密集型产业
         ,DECODE(SUBSTR(NVL(TRIM(C.CUL_PROPERTY_FLG),'99'),1,2),'99','0','-','0','1')
                                                      AS CUL_PROPERTY_FLG                    --文化产业标志     --MODIFY BY YJY 20240507
         ,SUBSTR(REPLACE(NVL(TRIM(C.STRATE_NEW_INDUS_TYPE_CD),'0'),'999999','0'),1,1)
                                                      AS STRATE_NEW_INDUS_TYPE_CD            --战略性新兴产业类型代码   --MODIFY BY YJY 20240507
         ,C.HIGH_NEW_TECH_CORP_FLG                    AS HIGH_NEW_TECH_CORP_FLG              --高新技术企业标志
         ,C.SCI_TECH_CORP_FLG                         AS SCI_TECH_CORP_FLG                   --科技型企业标志
         ,C.SCI_TECH_INOVT_CORP_FLG                   AS SCI_TECH_INOVT_CORP_FLG             --科创企业标志
         ,C.SPE_SOPH_UNQ_NEW_MED_SIDE_ENTER_FLG       AS SPE_SOPH_UNQ_NEW_MED_SIDE_ENTER_FLG --专精特新中小企业标志
         ,C.SPE_SOPH_UNQ_NEW_LTE_GNT_CORP_FLG         AS SPE_SOPH_UNQ_NEW_LTE_GNT_CORP_FLG   --专精特新小巨人企业标志
         ,A.CRDT_TYPE_CD                              AS CONT_TYPE_CD                        --合同类型代码
         ,C.INDU_CORP_TECH_REM_UGD_FLG                AS INDU_CORP_TECH_REM_UGD_FLG          --工业企业技术改造升级标志   ADD BY YJY 20240507
         --,DECODE(C.INDU_CORP_TECH_REM_UGD_FLG,'1','Y','N') AS INDU_CORP_TECH_REM_UGD_FLG     --工业企业技术改造升级标志   MODIFY BY PSF 20250912
         ,C.SEED_LOAN_FLG                             AS SEED_LOAN_FLG                       --种业振兴贷款标志           ADD BY YJY 20240507
         ,C.COUNTY_LOAN_FLG                           AS COUNTY_LOAN_FLG                     --县城区贷款标志             ADD BY YJY 20240507
         ,C.PROVI_FOR_AGED_PROPERTY_FLG               AS PROVI_FOR_AGED_PROPERTY_FLG         --养老产业标志               ADD BY YJY 20240507
         ,C.PPP_PROJ_FLG                              AS PPP_PROJ_FLG                        --投向政府和社会资本合作项目标志  ADD BY YJY 20240507
         ,C.NEW_DISTR_FLG                             AS NEW_DISTR_FLG                       --新机制发放贷款标志         ADD BY YJY 20240507
         ,NULL                                        AS PROP_PROPERTY_TYPE_CD               --知识产权产业类型代码       ADD BY HYF 20240528
         ,SUBSTR(NVL(TRIM(C.CUL_PROPERTY_FLG),'99'),1,2) AS CUL_AND_RELA_PPTY_TYPE_CD        --文化及相关产业类型代码     ADD BY HYF 20240528
         ,DECODE(C.HIGH_TECH_SERV_LOAN_FLG,'1','Y','N')  AS HIGH_TECH_SERV_LOAN_FLG             --高技术服务业贷款标志       ADD BY YJY 20240829
         ,C.HIGH_TECH_SERV_LOAN_TYPE_CD               AS HIGH_TECH_SERV_LOAN_TYPE_CD         --高技术服务业贷款类型代码   ADD BY YJY 20240829
         ,C.RELA_PEOP_GUAR_LOAN_FLG                   AS RELA_PEOP_GUAR_LOAN_FLG             --关系人保证贷款标志         ADD BY YJY 20241010
         ,DECODE(C.HIGH_TECH_PROPERTY_FLG,'1','Y','N') AS HIGH_TECH_PROPERTY_FLG             --投向高技术产业标志         ADD BY YJY 20250605
         ,A.BUID_BUS_GUAR_LOAN_FLG                     AS BUID_BUS_GUAR_LOAN_FLG             --创业担保贷款标志           ADD BY LAL 20250829
         ,F.CUST_INS_ADJ_TYPE_CD                       AS CUST_INS_ADJ_TYPE_CD               --客户产业结构调整类型代码   ADD BY PSF 20250912
         ,CASE WHEN (A.VALID_FLG_CD = '2' --2生效，4终结（包括已结清失效和未结清失效）
                    OR (A.VALID_FLG_CD = '4' AND A.ACM_DISTR_AMT <> A.ACM_CALLBK_AMT)) --未结清
                    AND (A.STD_PROD_ID LIKE '2%' OR A.STD_PROD_ID IN ('602060100001','602060100002','602030100001','602030100001','602030100002'))
                    --AND A.CONT_TYPE_CD = '02' THEN 'Y'  --02业务合同
                    AND A.CRDT_TYPE_CD = '02' --02业务合同 --MOD BY LIP 20260205
               THEN 'Y'  --02业务合同
               WHEN (A.TERMNT_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') OR TO_CHAR(A.TERMNT_DT,'YYYYMMDD') IN ('00010101'))
                    AND (A.STD_PROD_ID LIKE '2%' OR A.STD_PROD_ID IN ('602060100001','602060100002','602030100001','602030100001','602030100002'))
                    --AND A.CONT_TYPE_CD = '02' --02业务合同
                    AND A.CRDT_TYPE_CD = '02' --02业务合同 --MOD BY LIP 20260205
               THEN 'Y' --通过合同的实际终止日期判断 --MOD BY LIP 20251203
               ELSE 'N'
           END                                          AS YEAR_FLG                            --年标识                   ADD BY CJJ 20251016
         ,NULL                                          AS APRV_EMP_NO                         --审批员工ID               ADD BY ZLY 20251017
         ,NVL(TRIM(A.LMT_CONT_ID),A.CONT_ID)            AS CRDT_LMT_ID_NEW                     --新授信合同编号 --ADD BY LIP 20260129 没有综合授信时，用合同号兜底
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO A --对公贷款合同信
    LEFT JOIN (SELECT H.CONT_ID CONT_ID,SUM(H.RELA_AMT) RELA_AMT
                 FROM RRP_MDL.O_IML_AGT_LOAN_CONT_RELA_TAB_INFO_H H  --贷款合同关联表信息历史
                WHERE H.OBJ_TYPE_NAME = 'GuarantyContract'
                GROUP BY H.CONT_ID) H1
      ON H1.CONT_ID = A.CONT_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO B --标准产品信息
      ON B.PROD_ID = A.STD_PROD_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_BUS_CONT_ATTACH_INFO C --对公贷款业务合同附加信息
      ON C.CONT_ID = A.CONT_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO D --对公贷款合同信息 --ADD BY LIUYU 取额度合同的担保方式
      ON D.CONT_ID = TRIM(A.LMT_CONT_ID)
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP TA --合同状态转码 CD1371-->D0117
      ON TA.SRC_VALUE_CODE = A.VALID_FLG_CD
     AND TA.SRC_CLASS_CODE = 'CD2586'
     AND TA.TAR_CLASS_CODE = 'D0117'
     AND TA.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TB --担保方式1转码 CD1244-->D0037
      ON TB.SRC_VALUE_CODE = A.MAJOR_GUAR_WAY_CD
     AND TB.SRC_CLASS_CODE = 'CD2656'
     AND TB.TAR_CLASS_CODE = 'D0002'
     AND TB.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP E --码值映射表(贷款类型)
      ON E.SRC_VALUE_CODE = A.STD_PROD_ID
     AND E.SRC_CLASS_CODE = 'STD0002'
     AND E.TAR_CLASS_CODE = 'T0001'
     AND E.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.O_IML_AGT_LOAN_CONT_CORP_LOAN_ATTACH_INFO_H F --对公贷款附属信息历史 --ADD BY PSF 20250912
      ON F.CONT_ID = A.CONT_ID
     AND F.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND F.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY YJY 20250219 对公互联网贷款-微业贷的逻辑
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '贷款合同信息--对公联合网贷-微业贷';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_LOAN_CONT_INFO_TEMP02
    (DATA_DT                  --数据日期
    ,LGL_REP_ID               --法人编号
    ,CONT_ID                  --合同编号
    ,CONT_NM                  --合同名称
    ,PRIM_CONT_ID             --主合同号
    ,CUST_ID                  --客户编号
    ,ORG_ID                   --机构编号
    ,APP_ID                   --申请编号
    ,CRDT_LMT_ID              --授信额度编号
    ,LOAN_PROD_TYP            --贷款产品类型
    ,LOAN_PROD_NM             --贷款产品名称
    ,CUR                      --币种
    ,CONT_AMT                 --合同金额
    ,CONT_START_DT            --合同开始日期
    ,CONT_EXP_DT              --合同到期日期
    ,MAIN_GUA_MODE            --担保方式1
    ,SUB_GUA_MODE             --担保方式2
    ,CUST_MGR_NO              --客户经理工号
    ,LOAN_USEAGE              --贷款用途
    ,DIR_RGN_AREA_CD          --投向地区行政区划
    ,DIR_IDY                  --投向行业
    ,FIN_LOAN_REL_LC_NO       --融资贷款关联信用证号
    ,CONT_SIGN_DT             --合同签订日期
    ,COOP_AGRT_ID             --合作协议编号
    ,CUST_DATA_AUTH_ID        --客户数据授权书编号
    ,GRANT_EFF_DT             --授权生效日期
    ,GRANT_END_DT             --授权终止日期
    ,PNR_RESP_AMT             --合作方责任金额
    ,APP_PSN_TEL              --申请人联系电话
    ,CONT_STAT                --合同状态
    ,DEPT_LINE                --部门条线
    ,DATA_SRC                 --数据来源
    ,TERMNT_DT                --终止日期
    ,MON_FLG                  --月标识
    ,LOAN_HAPP_TYPE_CD        --贷款发生类型
    ,HIGH_TECH_PROPERTY_TYPE_CD            --高技术产业类型代码
    ,DIGIT_ECON_CORE_PROPERTY_TYPE_CD      --数字经济核心产业类型代码
    ,INTEL_PROP_INTE_PROPERTY_TYPE_CD      --是否投向知识产权密集型产业
    ,CUL_PROPERTY_FLG                      --文化产业标志
    ,STRATE_NEW_INDUS_TYPE_CD              --战略性新兴产业类型代码
    ,SPE_SOPH_UNQ_NEW_MED_SIDE_ENTER_FLG   --专精特新中小企业标志
    ,SPE_SOPH_UNQ_NEW_LTE_GNT_CORP_FLG     --专精特新小巨人企业标志
    ,ACP_DISTR_AMT                         --花呗放款金额               ADD BY 20240103
    ,INDU_CORP_TECH_REM_UGD_FLG            --工业企业技术改造升级标志   add by yjy 20240507
    ,SEED_LOAN_FLG                         --种业振兴贷款标志           add by yjy 20240507
    ,COUNTY_LOAN_FLG                       --县城区贷款标志             add by yjy 20240507
    ,PROVI_FOR_AGED_PROPERTY_FLG           --养老产业标志               add by yjy 20240507
    ,PPP_PROJ_FLG                          --投向政府和社会资本合作项目标志  add by yjy 20240507
    ,NEW_DISTR_FLG                         --新机制发放贷款标志         add by yjy 20240507
    ,PROP_PROPERTY_TYPE_CD                 --知识产权产业类型代码       add by HYF 20240528
    ,CUL_AND_RELA_PPTY_TYPE_CD             --文化及相关产业类型代码     add by HYF 20240528
    ,STD_PROD_ID                           --标准产品编号               ADD BY LIP 20240822
    ,HIGH_TECH_PROPERTY_FLG                --投向高技术产业标志         ADD BY YJY 20250605
    ,YEAR_FLG                              --年标识                     ADD BY CJJ 20251016
    ,APRV_EMP_NO                           --审批员工ID                 ADD BY ZLY 20251017
    ,CRDT_LMT_ID_NEW                       --新授信合同编号 --ADD BY LIP 20260129
    )
    WITH HLW_LOAN_AGREEMENT_INFO AS (--MOD BY LIP 20251111 根据信贷登记的互联网合作协议信息调整映射口径
  SELECT /*+MATERIALIZE*/T1.PRODUCTID,T1.PRODUCTNAME,
         LISTAGG(DISTINCT T1.MAINAGREEMENTNO,';') WITHIN GROUP(ORDER BY 1) AS MAINAGREEMENTNO
    FROM RRP_MDL.O_IOL_ICMS_HLW_LOAN_AGREEMENT_INFO T1 --互联网贷款产品合作协议信息表
   WHERE T1.PRODUCTID NOT LIKE '%202020200004%' --网商贷的单独处理
     AND T1.PRODUCTID NOT LIKE '%202020100001%' --网商贷的单独处理
     AND T1.PRODUCTID NOT LIKE '%202020200002%' --平安普惠的单独处理
     AND T1.PRODUCTID NOT LIKE '%202010200005%' --平安普惠的单独处理
     AND NVL(T1.DATASTATUS,'01') = '01' --01有效 02停用 --ADD BY LIP 20260116 过滤停用的数据
     AND T1.ID_MARK <> 'D'
     AND T1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   GROUP BY T1.PRODUCTID,T1.PRODUCTNAME),
   ADD_LOAN_NET_COOP_SUB AS (
  SELECT /*+MATERIALIZE*/REGEXP_SUBSTR(PRODUCTID,'[^,]+', 1,LEVEL) PRODUCTID,MAINAGREEMENTNO
    FROM HLW_LOAN_AGREEMENT_INFO
 CONNECT BY LEVEL <= LENGTH(PRODUCTID) - LENGTH(REPLACE(PRODUCTID, ',')) + 1
   GROUP BY REGEXP_SUBSTR(PRODUCTID, '[^,]+', 1, LEVEL),MAINAGREEMENTNO),
   CMM_UNITE_WL_LMT_INFO_QC AS ( --ADD BY LIP 20260129 取授信额度中最新的一笔记录
  SELECT /*+MATERIALIZE*/T.CUST_ID      AS CUST_ID      --客户号
        /*,T.LMT_CONT_ID  AS LMT_CONT_ID  --额度合同编号*/
        --UPDATE BY YJY 20260413 203050100002-微众对公联合贷的取联合贷额度信息表的LMT_RELA_APPL_ID--额度关联申请编号，其他产品取LMT_CONT_ID--额度合同编号
        ,CASE WHEN T.BUS_BREED_ID = '203050100002' THEN T.LMT_RELA_APPL_ID
              ELSE T.LMT_CONT_ID
          END                                   AS LMT_CONT_ID  --额度合同编号
        ,T.BUS_BREED_ID AS BUS_BREED_ID --统一后的授信品种
        ,ROW_NUMBER() OVER(PARTITION BY CUST_ID,BUS_BREED_ID ORDER BY BEGIN_DT DESC,T.LMT_CONT_ID DESC) AS RN --去重
    FROM RRP_MDL.O_ICL_CMM_UNITE_WL_LMT_INFO T --联合网贷额度信息
   WHERE TRIM(T.CUST_ID) IS NOT NULL
     AND T.CRDT_LMT > 0
     AND T.BUS_BREED_ID IN ('203050100001','203050100002')
     AND (NVL(T.BEGIN_DT,TO_DATE('00010101','YYYYMMDD')) <= TO_DATE(V_P_DATE,'YYYYMMDD') - 1
          OR T.BEGIN_DT IN (TO_DATE('20991231','YYYYMMDD'),TO_DATE('99991231','YYYYMMDD')))
     AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT  V_P_DATE                                    AS DATA_DT                    --数据日期
         ,A.LP_ID                                     AS LGL_REP_ID                 --法人编号
         ,A1.CONT_ID                                  AS CONT_ID                    --合同编号 --MOD BY YJY 20250509
         ,A1.CONT_ID                                  AS CONT_NM                    --合同名称 --MOD BY YJY 20250509
         ,A1.CONT_ID                                  AS PRIM_CONT_ID               --主合同号 --MOD BY YJY 20250509
         ,A1.CUST_ID                                  AS CUST_ID                    --客户编号 --MOD BY YJY 20250509
         ,A.ACCT_INSTIT_ID                            AS ORG_ID                     --机构编号
         ,A.RELA_APPL_FLOW_NUM                        AS APP_ID                     --申请编号
         ,C.LMT_CONT_ID                               AS CRDT_LMT_ID                --授信额度编号
         ,CASE WHEN TD.TAR_VALUE_CODE IS NOT NULL
               THEN TD.TAR_VALUE_CODE
               ELSE '02' --对公
           END                                        AS LOAN_PROD_TYP              --贷款产品类型
         ,TE.PROD_NAME                                AS LOAN_PROD_NM               --贷款产品名称
         ,A1.CURR_CD                                  AS CUR                        --币种   --MOD BY YJY 20250509
         ,CASE WHEN NVL(A1.CONT_AMT,0) <> 0
               THEN A1.CONT_AMT
               ELSE 0
           END                                        AS CONT_AMT                   --合同金额 --MOD BY YJY 20250509
         /*,CASE WHEN TO_CHAR(A1.BEGIN_DT,'YYYYMMDD') NOT IN ('00010101','29991231') THEN TO_CHAR(A1.BEGIN_DT,'YYYYMMDD')
               WHEN TO_CHAR(A1.DISTR_DT,'YYYYMMDD') NOT IN ('00010101','29991231') THEN TO_CHAR(A1.DISTR_DT,'YYYYMMDD')
               ELSE NULL
           END*/
          --MOD BY YJY 20260115 一表通要求对切日的数据进行兜底，默认为跑批日当天
         ,CASE WHEN TO_CHAR(A1.BEGIN_DT,'YYYYMMDD') NOT IN ('00010101','29991231') AND TO_CHAR(A1.BEGIN_DT,'YYYYMMDD') <= V_P_DATE 
               THEN TO_CHAR(A1.BEGIN_DT,'YYYYMMDD')
               WHEN TRUNC(A1.BEGIN_DT) = TO_DATE(V_P_DATE,'YYYYMMDD') +1 
               THEN V_P_DATE --对切日的数据兜底
               WHEN TO_CHAR(A1.DISTR_DT,'YYYYMMDD') NOT IN ('00010101','29991231') AND TO_CHAR(A1.DISTR_DT,'YYYYMMDD') <= V_P_DATE 
               THEN TO_CHAR(A1.DISTR_DT,'YYYYMMDD')
               WHEN TO_CHAR(A1.DISTR_DT,'YYYYMMDD') = TO_DATE(V_P_DATE,'YYYYMMDD') +1 
               THEN V_P_DATE --对切日的数据兜底
               ELSE NULL
           END                                        AS CONT_START_DT              --合同开始日期 --MOD BY YJY 20250509
         ,CASE WHEN TO_CHAR(A1.EXP_DT,'YYYYMMDD') IN ('00010101','29991231')
               THEN NULL
               ELSE TO_CHAR(A1.EXP_DT,'YYYYMMDD')
           END                                        AS CONT_EXP_DT                --合同到期日期 --MOD BY YJY 20250509
         ,NVL(TB.TAR_VALUE_CODE,'Z')                  AS MAIN_GUA_MODE              --担保方式1
         ,NULL                                        AS SUB_GUA_MODE               --担保方式2
         ,A.CUST_MGR_ID                               AS CUST_MGR_NO                --客户经理工号
         ,TC.CD_DESCB                                 AS LOAN_USEAGE                --贷款用途
         ,NULL                                        AS DIR_RGN_AREA_CD            --投向地区行政区划代码
         ,/*A.DIR_INDUS_CD*/A1.DIR_INDUS_CD           AS DIR_IDY                    --投向行业 --MOD BY YJY 20250509
         ,NULL                                        AS FIN_LOAN_REL_LC_NO         --融资贷款关联信用证号
         ,CASE WHEN TO_CHAR(A1.SIGN_DT,'YYYYMMDD') IN ('00010101','29991231') THEN NULL
               ELSE TO_CHAR(A1.SIGN_DT,'YYYYMMDD')
           END                                        AS CONT_SIGN_DT               --合同签订日期
         /*,CASE WHEN TRIM(D.COOP_AGRT_ID) IS NOT NULL THEN TRIM(D.COOP_AGRT_ID)
               WHEN TRIM(E.COOP_AGRT_ID) IS NOT NULL THEN TRIM(E.COOP_AGRT_ID)
               WHEN TRIM(DD.COOP_AGRT_ID) IS NOT NULL THEN TRIM(DD.COOP_AGRT_ID)
               WHEN TRIM(EE.COOP_AGRT_ID) IS NOT NULL THEN TRIM(EE.COOP_AGRT_ID)
           END                                        AS COOP_AGRT_ID               --合作协议编号*/
         ,D.MAINAGREEMENTNO                           AS COOP_AGRT_ID               --合作协议编号 --MOD BY LIP 20251111
         ,'合作方未提供'                              AS CUST_DATA_AUTH_ID          --客户数据授权书编号
         ,TO_CHAR(A1.BEGIN_DT,'YYYYMMDD')             AS GRANT_EFF_DT               --授权生效日期 --MOD BY YJY 20250509
         ,TO_CHAR(A1.EXP_DT,'YYYYMMDD')               AS GRANT_END_DT               --授权终止日期 --MOD BY YJY 20250509
         /*,A.CONT_AMT * ( 1- CASE WHEN A.GUAR_WAY_CD = 'C' THEN 0 END --保证的都是100%)*/
         ,A.CONT_AMT * (1 - A.BANK_CONTRI_RATIO)      AS PNR_RESP_AMT               --合作方责任金额 --MOD BY YJY 20250328 合作方责任金额=合同金额*（1-银行出资比例）
         ,TRIM(B.PHONE_CRDTC)                         AS APP_PSN_TEL                --申请人联系电话
         ,NVL(TA.TAR_VALUE_CODE,'99')                 AS CONT_STAT                  --合同状态 CD1278-->D0117
         ,NULL                                        AS DEPT_LINE                  --部门条线
         ,'对公联合网贷'                              AS DATA_SRC                   --数据来源
         ,TO_CHAR(A1.TERMNT_DT,'YYYYMMDD')            AS TERMNT_DT                  --终止日期  --MOD BY YJY 20250509
         ,CASE WHEN A.WRT_OFF_FLG = '1' AND (F.FIR_WRT_OFF_DT = TO_DATE('00010101','YYYYMMDD')
                   OR NVL(F.FIR_WRT_OFF_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= V_MONTH_START_DATE - 1)
               THEN 'Y' --核销了且核销日期大于月初
               WHEN A.WRT_OFF_FLG = '1'
               THEN 'N' --核销了的且核销日期小于月初的
               WHEN A.PAYOFF_DT = TO_DATE('00010101','YYYYMMDD')
               THEN 'Y' --结清日期为空，或者非京东的结清日期大于月初
               WHEN A.PAYOFF_DT < V_MONTH_START_DATE - 1
               THEN 'N' --结清日期小于月初
               WHEN NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0)+ NVL(A.OFF_BS_INT,0)+NVL(A.BAD_DEBT_PRIC,0) > 0
               THEN 'Y' --有余额
               WHEN NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0)+ NVL(A.OFF_BS_INT,0)+NVL(A.BAD_DEBT_PRIC,0) = 0
                AND ((A.LAST_REPAY_DT = TO_DATE('00010101','YYYYMMDD') AND A.LAST_REPAY_DT >= A.DISTR_DT)
                      OR A.LAST_REPAY_DT >= V_MONTH_START_DATE - 1)
               THEN 'Y'
               ELSE 'N'
           END                                         AS MON_FLG                    --月口径标识
         ,NULL                                         AS LOAN_HAPP_TYPE_CD                     --贷款发生类型
         ,NULL                                         AS HIGH_TECH_PROPERTY_TYPE_CD            --高技术产业类型代码
         ,A1.DIGIT_ECON_CORE_TYPE_CD                   AS DIGIT_ECON_CORE_PROPERTY_TYPE_CD      --数字经济核心产业类型代码  --MOD BY YJY 20250509
         ,CASE WHEN T9.SFDX = 'Y' THEN '0'
               WHEN T9.CODE IS NOT NULL THEN '1'
          ELSE '0' END                                 AS INTEL_PROP_INTE_PROPERTY_TYPE_CD      --是否投向知识产权密集型产业 --MOD BY 20250716
         ,DECODE(SUBSTR(NVL(TRIM(A1.CUL_PROPERTY_FLG),'99'),1,2),'99','0','-','0','1')   AS CUL_PROPERTY_FLG           --文化产业标志           --MOD BY YJY 20250509
         ,SUBSTR(REPLACE(NVL(TRIM(A1.STRATE_NEW_INDUS_TYPE_CD),'0'),'999999','0'),1,1)  AS STRATE_NEW_INDUS_TYPE_CD   --战略性新兴产业类型代码 --MOD BY YJY 20250509
         /*,CASE SUBSTR(REPLACE(NVL(TRIM(A1.STRATE_NEW_INDUS_TYPE_CD),'0'),'999999','0'),1,1)
               WHEN '7' THEN 'C' --节能环保
               WHEN '1' THEN 'D' --新一代信息技术
               WHEN '4' THEN 'E' --生物医药
               WHEN '2' THEN 'F' --高端装备制造
               WHEN '6' THEN 'G' --新能源
               WHEN '3' THEN 'H' --新材料
               WHEN '5' THEN 'I' --新能源汽车
               WHEN '8' THEN 'J' --数字创意产业
               WHEN '9' THEN 'K' --相关服务业
               ELSE 'NA' END                           AS STRATE_NEW_INDUS_TYPE_CD   --战略性新兴产业类型代码 --MOD BY PSF 202509 */
         ,A1.SPE_SOPH_UNQ_NEW_MED_SIDE_ENTER_FLG       AS SPE_SOPH_UNQ_NEW_MED_SIDE_ENTER_FLG   --专精特新中小企业标志  --MOD BY YJY 20250509
         ,A1.SPE_SOPH_UNQ_NEW_LTE_GNT_CORP_FLG         AS SPE_SOPH_UNQ_NEW_LTE_GNT_CORP_FLG     --专精特新小巨人企业标志--MOD BY YJY 20250509
         ,A.ACP_DISTR_AMT                              AS ACP_DISTR_AMT                         --花呗放款金额
         ,A1.INDU_CORP_TECH_REM_UGD_FLG                AS INDU_CORP_TECH_REM_UGD_FLG            --工业企业技术改造升级标志   --MOD BY YJY 20250509
         --,DECODE(A1.INDU_CORP_TECH_REM_UGD_FLG,'1','Y','N') AS INDU_CORP_TECH_REM_UGD_FLG       --工业企业技术改造升级标志   --MOD BY PSF 20250912
         ,A1.SEED_LOAN_FLG                             AS SEED_LOAN_FLG                         --种业振兴贷款标志           --MOD BY YJY 20250509
         ,A1.COUNTY_LOAN_FLG                           AS COUNTY_LOAN_FLG                       --县城区贷款标志             --MOD BY YJY 20250509
         ,A1.PROVI_FOR_AGED_PROPERTY_FLG               AS PROVI_FOR_AGED_PROPERTY_FLG           --养老产业标志              --MOD BY YJY 20250509
         ,A1.PPP_PROJ_FLG                              AS PPP_PROJ_FLG                          --投向政府和社会资本合作项目标志   --MOD BY YJY 20250509
         ,A1.NEW_DISTR_FLG                             AS NEW_DISTR_FLG                         --新机制发放贷款标志        --MOD BY YJY 20250509
         ,NULL                                         AS PROP_PROPERTY_TYPE_CD                 --知识产权产业类型代码
         ,SUBSTR(NVL(TRIM(A1.CUL_PROPERTY_FLG),'99'),1,2) AS CUL_AND_RELA_PPTY_TYPE_CD          --文化及相关产业类型代码    --MOD BY YJY 20250509
         ,A1.STD_PROD_ID                                AS STD_PROD_ID                          --标准产品编号
         ,DECODE(A1.HIGH_TECH_PROPERTY_FLG,'1','Y','N') AS HIGH_TECH_PROPERTY_FLG               --投向高技术产业标志        --ADD BY YJY 20250605
         ,CASE WHEN A.WRT_OFF_FLG = '1' AND (F.FIR_WRT_OFF_DT = TO_DATE('00010101','YYYYMMDD')
                   OR NVL(F.FIR_WRT_OFF_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= V_YEAR_START_DATE - 1)
               THEN 'Y' --核销了且核销日期大于年初
               WHEN A.WRT_OFF_FLG = '1'
               THEN 'N' --核销了的且核销日期小于月初的
               WHEN A.PAYOFF_DT = TO_DATE('00010101','YYYYMMDD')
               THEN 'Y' --结清日期为空，或者非京东的结清日期大于月初
               WHEN A.PAYOFF_DT < V_YEAR_START_DATE - 1
               THEN 'N' --结清日期小于年初
               WHEN NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0)+ NVL(A.OFF_BS_INT,0)+NVL(A.BAD_DEBT_PRIC,0) > 0
               THEN 'Y' --有余额
               WHEN NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0)+ NVL(A.OFF_BS_INT,0)+NVL(A.BAD_DEBT_PRIC,0) = 0
                AND ((A.LAST_REPAY_DT = TO_DATE('00010101','YYYYMMDD') AND A.LAST_REPAY_DT >= A.DISTR_DT)
                      OR A.LAST_REPAY_DT >= V_YEAR_START_DATE - 1)
               THEN 'Y'
               ELSE 'N'
           END                                           AS YEAR_FLG                            --年标识     ADD BY CJJ 20251016
          ,NULL                                          AS APRV_EMP_NO                         --审批员工ID ADD BY ZLY 20251017
          ,NVL(T1.LMT_CONT_ID,A.DUBIL_ID)                AS CRDT_LMT_ID_NEW                     --新授信合同编号 --ADD BY LIP 20260129 优先取授信申请表中最新的授信，没有授信时用借据号做授信合同号
     FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO A --联合网贷借据信息
    --ADD BY YJY 20250509 新增关联联合网贷合同信息表，取微业贷相关标签
    INNER JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_LOAN_CONT_INFO A1 --联合网贷贷款合同信息
      ON A1.CONT_ID = A.CONT_ID
     AND A1.STD_PROD_ID IN ('203050100001','203050100002')--MOD BY YJY 20251120 新增203050100002-微众对公联合贷
     AND A1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO B --对公客户基本信息
      ON B.CUST_ID = A.CUST_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_LMT_INFO C --授信额度信息
      ON C.LMT_RELA_APPL_ID = TRIM(A.RELA_APPL_FLOW_NUM)
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN CMM_UNITE_WL_LMT_INFO_QC T1 --授信表最新申请记录 --ADD BY LIP 20260129
      ON T1.CUST_ID = A.CUST_ID
     AND T1.BUS_BREED_ID = A.STD_PROD_ID
     AND T1.RN = 1
    LEFT JOIN ADD_LOAN_NET_COOP_SUB D --MOD BY LIP 20251111 根据信贷登记的互联网合作协议编号调整映射
      ON D.PRODUCTID = A.STD_PROD_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_WRT_OFF_INFO F --联合网贷核销信息
      ON F.DUBIL_ID = A.DUBIL_ID
     AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP TA  --合同状态转码 CD1278-->D0117
      ON TA.SRC_VALUE_CODE = A.CONT_STATUS_CD
     AND TA.SRC_CLASS_CODE = 'CD1278'
     AND TA.TAR_CLASS_CODE = 'D0117'
     AND TA.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TB --担保方式1转码 CD1518-->D0037
      ON TB.SRC_VALUE_CODE = A.GUAR_WAY_CD
     AND TB.SRC_CLASS_CODE = 'CD2656'
     AND TB.TAR_CLASS_CODE = 'D0002'
     AND TB.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD TC --公共代码表
      ON TC.CD_VAL = A.LOAN_USAGE_CD
     AND TC.CD_ID = 'CD1274'
    LEFT JOIN RRP_MDL.CODE_MAP TD  --码值映射表(贷款类型)
      ON TD.SRC_VALUE_CODE = A.STD_PROD_ID
     AND TD.SRC_CLASS_CODE = 'STD0002'
     AND TD.TAR_CLASS_CODE = 'T0001'
     AND TD.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO TE --标准产品信息
      ON TE.PROD_ID = A.STD_PROD_ID
     AND TE.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT DISTINCT CODE,NAME,SFDX FROM M_DICT_G0107_REMAPPING_BL WHERE TYPE_CODE = 'G010703') T9--知识产权密集型产业
      ON A1.DIR_INDUS_CD = T9.CODE
   WHERE A.DUBIL_STATUS_CD NOT IN ('2','5') --失败、撤销
     AND A.STD_PROD_ID IN ('203050100001','203050100002') --203050100001-微业贷 --MOD BY YJY 20251120 新增203050100002-微众对公联合贷
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '贷款合同信息--处理对公贷款合同余额';
  V_STARTTIME := SYSDATE;
  MERGE INTO RRP_MDL.M_LOAN_CONT_INFO_TEMP02 A
  USING (SELECT /*+PARALLEL*/
                C.CONT_ID,SUM(B.PRIC_BAL) AS LOAN_ACCT_BAL --金数不考虑核销、减值等情况，只考虑原始余额是否结清
           FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO B --对公贷款账户信息
          INNER JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO A --对公贷款借据信息表
             ON B.DUBIL_NUM = A.DUBIL_ID
            AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
           LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO C --对公贷款合同信息表
             ON C.CONT_ID = A.CONT_ID
            AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
          WHERE (B.OPEN_ACCT_DT <> B.CLOS_ACCT_DT)
            AND (C.CRDT_TYPE_CD = '02' OR C.CRDT_TYPE_CD IS NULL) --00未知 01额度合同 02业务合同
            AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
          GROUP BY C.CONT_ID) B
     ON (A.CONT_ID = B.CONT_ID AND A.DATA_DT = V_P_DATE)
   WHEN MATCHED THEN UPDATE SET
     A.DUBIL_BAL_TOT = B.LOAN_ACCT_BAL;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY LIP 20250310 处理客户授权书相关信息
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '贷款合同信息--客户授权书相关信息';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_LOAN_CONT_INFO_TEMP03';
  INSERT INTO RRP_MDL.M_LOAN_CONT_INFO_TEMP03(
     CONT_ID                    --合同编号
    ,CUST_ID                    --客户编号
    ,APV_FLOW_NUM               --合同审批流水号
    ,PROD_ID                    --产品编号
    ,RELA_CRDT_LMT_APV_FLOW_NUM --关联授信额度审批流水号
    ,AUTHOSTRDATE               --授权起始时间
    ,AUTHOENDDATE               --授权结束时间
    ,AUTHOBKID                  --客户数据授权书编号
    )
  SELECT  T.CONT_ID                           AS CONT_ID                    --合同编号
         ,T.CUST_ID                           AS CUST_ID                    --客户编号
         ,T.APV_FLOW_NUM                      AS APV_FLOW_NUM               --合同审批流水号
         ,T.PROD_ID                           AS PROD_ID                    --产品编号
         ,TA.RELA_CRDT_LMT_APV_FLOW_NUM       AS RELA_CRDT_LMT_APV_FLOW_NUM --关联授信额度审批流水号
         ,CASE WHEN TO_CHAR(TB.AUTHOSTRDATE,'YYYYMMDD') NOT IN ('00010101','29991231','20991231')
               THEN TO_CHAR(TB.AUTHOSTRDATE,'YYYYMMDD')
               WHEN TO_CHAR(T.START_DT,'YYYYMMDD') NOT IN ('00010101','29991231','20991231')
               THEN TO_CHAR(T.START_DT,'YYYYMMDD')
               WHEN TO_CHAR(T.SIGN_DT,'YYYYMMDD') NOT IN ('00010101','29991231','20991231')
               THEN TO_CHAR(T.SIGN_DT,'YYYYMMDD')
           END                                AS AUTHOSTRDATE               --授权起始时间
         ,CASE WHEN TO_CHAR(TB.AUTHOENDDATE,'YYYYMMDD') NOT IN ('00010101','29991231','20991231')
               THEN TO_CHAR(TB.AUTHOENDDATE,'YYYYMMDD')
               WHEN TO_CHAR(T.EXP_DT,'YYYYMMDD') NOT IN ('00010101','29991231','20991231')
               THEN TO_CHAR(T.EXP_DT,'YYYYMMDD')
               WHEN TO_CHAR(T.TERMNT_DT,'YYYYMMDD') NOT IN ('00010101','29991231','20991231')
               THEN TO_CHAR(T.TERMNT_DT,'YYYYMMDD')
           END                                AS AUTHOENDDATE               --授权结束时间
         ,CASE WHEN T.PROD_ID IN ('202010200005','202020200002') THEN TRIM(TB.REPORTID) --平安普惠
               WHEN T.PROD_ID IN ('201010300035','201010300040') THEN TRIM(TB.AUTHOBKID) --华兴易贷
               WHEN T.PROD_ID IN ('201010300041') THEN TRIM(TB.AUTHOBKID) --华兴好易贷（华强） --ADD BY LIP 20250709
               WHEN T.PROD_ID IN ('202020200006') THEN NVL(TC.CUST_DATA_AUTH_ID,TRIM(TB.AUTHOBKID))
           END                                AS AUTHOBKID                   --客户数据授权书编号
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO T --零售贷款合同信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_CRDT_LMT_APV_INFO TA --零售授信额度审批信息
      ON TA.CRDT_LMT_APV_FLOW_NUM = TRIM(T.APV_FLOW_NUM)
     AND TA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IOL_ICMS_BA_IND_CREDIT_INFO TB --个人客户征信信息
      ON TB.BASERIALNO = TRIM(TA.RELA_CRDT_LMT_APV_FLOW_NUM)
     AND TB.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.ADD_LOAN_DUBIL_CUST_DATA_AUTH_ID TC --贷款合同对应客户数据授权书编号 目前只有网商小贷有，合同号不重复
      ON TC.CONT_ID = T.CONT_ID
   WHERE NVL(TB.BASERIALNO,TC.CONT_ID) IS NOT NULL
     AND T.PROD_ID IN ('202010200005','202020200002','201010300035','201010300040','202020200006'
                       ,'201010300041','201020100062','201020100059','202010200012')
                       --平安普惠、华兴易贷、网商小贷（非循环）、饲料e贷-海大集团、360借条
     AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '贷款合同信息--零售信贷部分';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_LOAN_CONT_INFO_TEMP02
    (DATA_DT                 --数据日期
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
    ,MAIN_GUA_MODE           --担保方式1
    ,SUB_GUA_MODE            --担保方式2
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
    ,HIGH_TECH_PROPERTY_TYPE_CD        --高技术产业类型代码
    ,DIGIT_ECON_CORE_PROPERTY_TYPE_CD  --数字经济核心产业类型代码
    ,INTEL_PROP_INTE_PROPERTY_TYPE_CD  --是否投向知识产权密集型产业
    ,CUL_PROPERTY_FLG                  --文化产业标志
    ,STRATE_NEW_INDUS_TYPE_CD          --战略性新兴产业类型代码
    ,SPE_SOPH_UNQ_NEW_MED_SIDE_ENTER_FLG --专精特新中小企业标志
    ,SPE_SOPH_UNQ_NEW_LTE_GNT_CORP_FLG   --专精特新小巨人企业标志
    ,CONT_TYPE_CD                        --合同类型代码
    ,GREEN_CONSM_SUB_TYPE_CD             --绿色消费子类代码
    ,INDU_CORP_TECH_REM_UGD_FLG          --工业企业技术改造升级标志   ADD BY YJY 20240507
    ,SEED_LOAN_FLG                       --种业振兴贷款标志           ADD BY YJY 20240507
    ,COUNTY_LOAN_FLG                     --县城区贷款标志             ADD BY YJY 20240507
    ,PROVI_FOR_AGED_PROPERTY_FLG         --养老产业标志               ADD BY YJY 20240507
    ,PPP_PROJ_FLG                        --投向政府和社会资本合作项目标志  ADD BY YJY 20240507
    ,NEW_DISTR_FLG                       --新机制发放贷款标志         ADD BY YJY 20240507
    ,PROP_PROPERTY_TYPE_CD               --知识产权产业类型代码       ADD BY HYF 20240528
    ,CUL_AND_RELA_PPTY_TYPE_CD           --文化及相关产业类型代码     ADD BY HYF 20240528
    ,STD_PROD_ID                         --标准产品编号               ADD BY LIP 20240822
    ,HIGH_TECH_PROPERTY_FLG              --投向高技术产业标志         ADD BY YJY 20250605
    ,YEAR_FLG                            --年标识                     ADD BY CJJ 20251016
    ,APRV_EMP_NO                         --审批员工ID                 ADD BY ZLY 20251017
    ,CRDT_LMT_ID_NEW                     --新授信合同编号 --ADD BY LIP 20260129
    )
    WITH CMM_RETL_LOAN_DUBIL_INFO_TMP AS ( --ADD BY YJY 20250718 通过借据号关联信贷标签表，判断海大集团、兴采贷（大参林）互联网业务
  SELECT DISTINCT A.CONT_ID  AS CONT_ID --合同号
         --,A.STD_PROD_ID AS STD_PROD_ID --标准产品编号
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO A --零售贷款借据信息
   INNER JOIN RRP_MDL.O_IOL_ICMS_TAG_TERM_FINAL_DATA B --标签值最终表
      ON B.OBJECTNO = A.DUBIL_ID
     AND B.TAGHIREARCHY = '60' --标签层级
     AND B.TAGID = '2025080800000001' --标签编号：互联网业务
     AND B.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND B.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_IOL_ICMS_TAG_CODE_CONFIG C --标签码值配置表
      ON C.TAGID = B.TAGID --标签编号
     AND C.ITEMNO = B.TAGVALUE --标签值
     AND C.ITEMNAME = '是'
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.STD_PROD_ID = '201020100062' --201020100062 饲料e贷-海大集团 --兴采贷（大参林）没有互联网合作协议，不做数据加工
     AND TRIM(B.OBJECTNO) IS NOT NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')),
    HLW_LOAN_AGREEMENT_INFO AS (--MOD BY LIP 20251111 根据信贷登记的互联网合作协议信息调整映射口径
  SELECT T1.PRODUCTID,T1.PRODUCTNAME,
         LISTAGG(DISTINCT T1.MAINAGREEMENTNO,';') WITHIN GROUP(ORDER BY 1) AS MAINAGREEMENTNO
    FROM RRP_MDL.O_IOL_ICMS_HLW_LOAN_AGREEMENT_INFO T1 --互联网贷款产品合作协议信息表
   WHERE T1.PRODUCTID NOT LIKE '%202020200004%' --网商贷的单独处理
     AND T1.PRODUCTID NOT LIKE '%202020100001%' --网商贷的单独处理
     AND T1.PRODUCTID NOT LIKE '%202020200002%' --平安普惠的单独处理
     AND T1.PRODUCTID NOT LIKE '%202010200005%' --平安普惠的单独处理
     AND NVL(T1.DATASTATUS,'01') = '01' --01有效 02停用 --ADD BY LIP 20260116 过滤停用的数据
     AND T1.ID_MARK <> 'D'
     AND T1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   GROUP BY T1.PRODUCTID,T1.PRODUCTNAME),
   ADD_LOAN_NET_COOP_SUB AS (
  SELECT REGEXP_SUBSTR(PRODUCTID,'[^,]+', 1,LEVEL) PRODUCTID,MAINAGREEMENTNO
    FROM HLW_LOAN_AGREEMENT_INFO
 CONNECT BY LEVEL <= LENGTH(PRODUCTID) - LENGTH(REPLACE(PRODUCTID, ',')) + 1
   GROUP BY REGEXP_SUBSTR(PRODUCTID, '[^,]+', 1, LEVEL),MAINAGREEMENTNO),
    LOAN_LMT_INFO AS (--需要特殊处理的授信合同号 --ADD BY LIP 20260129
  SELECT /*+MATERIALIZE*/A.CUST_ID,A.PROD_ID,A.LOAN_APPL_FLOW_NUM,
         ROW_NUMBER() OVER(PARTITION BY A.CUST_ID ORDER BY A.APPL_AMT DESC,A.LOAN_APPL_FLOW_NUM DESC) AS RN --按大的一笔授信申请取数
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_APPL_INFO A --零售贷款申请信息      
   WHERE A.PROD_ID = '202020200007' --新心金融
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')),
   XXD_LMT_INFO AS ( --ADD BY LIP 20260129
  --360 借条 --能关联上有效授信的和合同表中的批复流水号相同，关联不上的要取借据号，取借据号的先不做处理
  --201010300005 新兴贷的单笔单批，授信合同号用的借据号
  SELECT /*+MATERIALIZE*/T.DUBIL_ID,T.CONT_ID,ROW_NUMBER() OVER(PARTITION BY T.CONT_ID ORDER BY T.DUBIL_OPEN_DT,T.DUBIL_ID) RN
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO T
   WHERE T.STD_PROD_ID IN ('201010300005') --个人消费信用贷（新兴贷2.0）
     AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT  V_P_DATE                                    AS DATA_DT                    --数据日期
         ,A.LP_ID                                     AS LGL_REP_ID                 --法人编号
         ,A.CONT_ID                                   AS CONT_ID                    --合同编号
         ,NVL(TRIM(A.CONT_NAME),A.CONT_ID)            AS CONT_NM                    --合同名称
         ,A.CONT_ID                                   AS PRIM_CONT_ID               --主合同号
         ,A.CUST_ID                                   AS CUST_ID                    --客户编号
         --MOD BY 20231127 账务机构为空时，取管理机构和登记机构
         ,COALESCE(TRIM(A.ACCT_INSTIT_ID),TRIM(A.MGMT_ORG_ID),TRIM(A.RGST_ORG_ID))
                                                      AS ORG_ID                     --机构编号
         ,A.APV_FLOW_NUM                              AS APP_ID                     --申请编号     MODIFY BY MW 2022/11/26
         ,A.LMT_CONT_ID                               AS CRDT_LMT_ID                --授信额度编号 MODIFY BY MW 2022/11/26
         --MOD BY LIP 20240822 按表内借据表的映射逻辑调整零售部分的贷款产品类型
         ,CASE WHEN TE.TAR_VALUE_CODE LIKE '0103%' AND A.BORW_USAGE_TYPE_CD = '100101' THEN '010301' --个人汽车贷款
               WHEN TE.TAR_VALUE_CODE LIKE '0103%' AND A.BORW_USAGE_TYPE_CD = '100102' THEN '010302' --房屋装修贷款
               WHEN TE.TAR_VALUE_CODE LIKE '0103%' AND A.BORW_USAGE_TYPE_CD IN ('100109') THEN '010301' --个人汽车贷款
               WHEN TE.TAR_VALUE_CODE LIKE '0102%' AND A.BORW_USAGE_TYPE_CD IN ('100201') THEN '010202' --商用车贷款
               WHEN A.PROD_ID IN ('201030200001','201030200002','201030200003') THEN '010101' --个人住房按揭商业贷款
               WHEN A.PROD_ID IN ('201030200001','201030200002') AND A.BORW_USAGE_TYPE_CD <> '100301'
               THEN '010101' --个人中长期住房贷款(个人住房按揭商业贷款)
               WHEN A.PROD_ID IN ('201030100001','201030100002') AND A.BORW_USAGE_TYPE_CD = '100301'
               THEN '010201' --个人中长期住房贷款(商业用房贷款)
               WHEN TE.TAR_VALUE_CODE IS NOT NULL THEN TE.TAR_VALUE_CODE
               WHEN PROD.PROD_ID IS NOT NULL THEN PROD.PROD_ID
               ELSE '01' --个人贷款
           END                                        AS LOAN_PROD_TYP              --贷款产品类型   --MODIFY BY XIEYUGENG 20221021
         ,A.PROD_NAME                                 AS LOAN_PROD_NM               --贷款产品名称
         ,A.CURR_CD                                   AS CUR                        --币种
         ,A.CONT_AMT                                  AS CONT_AMT                   --合同金额
         /*,CASE WHEN TO_CHAR(A.START_DT,'YYYYMMDD') IN ('00010101','29991231')
               THEN NULL
               ELSE TO_CHAR(A.START_DT,'YYYYMMDD')
           END */
          --MOD BY YJY 20260115 一表通要求对切日的数据进行兜底，默认为跑批日当天
         ,CASE WHEN TO_CHAR(A.START_DT,'YYYYMMDD') NOT IN ('00010101','29991231') AND TO_CHAR(A.START_DT,'YYYYMMDD') <= V_P_DATE 
               THEN TO_CHAR(A.START_DT,'YYYYMMDD')
               WHEN TRUNC(A.START_DT) = TO_DATE(V_P_DATE,'YYYYMMDD') +1 
               THEN V_P_DATE --对切日的数据兜底 
               ELSE NULL
           END                                        AS CONT_START_DT              --合同开始日期
         ,CASE WHEN TO_CHAR(A.EXP_DT,'YYYYMMDD') NOT IN ('00010101','29991231')
               THEN TO_CHAR(A.EXP_DT,'YYYYMMDD')                                 --Hulj7月版数仓才加到期日期
               WHEN TO_CHAR(A.TERMNT_DT,'YYYYMMDD') NOT IN ('00010101','29991231')
               THEN TO_CHAR(A.TERMNT_DT,'YYYYMMDD')
           END                                        AS CONT_EXP_DT                --合同到期日期
         ,NVL(TC.TAR_VALUE_CODE,'Z')                  AS MAIN_GUA_MODE              --主担保方式
         ,A.SUB_GUAR_WAY_CD                           AS SUB_GUA_MODE               --子担保方式
         ,A.CUST_MGR_ID                               AS CUST_MGR_NO                --客户经理工号
         ,C.CD_DESCB                                  AS LOAN_USEAGE                --贷款用途
         ,NULL                                        AS DIR_RGN_AREA_CD            --投向地区行政区划代码
         ,A.DIR_INDUS_CD                              AS DIR_IDY                    --投向行业
         ,NULL                                        AS FIN_LOAN_REL_LC_NO         --融资贷款关联信用证号  --零售无
         ,CASE WHEN TO_CHAR(A.SIGN_DT,'YYYYMMDD') IN ('00010101','29991231') THEN NULL
               ELSE TO_CHAR(A.SIGN_DT,'YYYYMMDD')
           END                                        AS CONT_SIGN_DT               --合同签订日期
         /*,CASE WHEN A.PROD_ID IN ('202020200005','202020200006')
               THEN '华兴深分后海合字第20191007001号' --网商小贷
               WHEN A.PROD_ID IN ('202010200003')
               THEN '业务合作协议20181206号'  --玖富万卡
               WHEN A.PROD_ID IN ('202020200003','202010200004')
               THEN '华兴微贷合作字第201904001号华兴普惠20191216001'  --人保助贷（经营/消费）
               WHEN A.PROD_ID IN ('202010200008')
               THEN '粤华银零售审批【2019】0029号' --趣店引流贷
               WHEN A.PROD_ID IN ('202020200002','202010200005') --平安普惠/平安普惠（消费）
                AND A.START_DT >= TO_DATE('20201010','YYYYMMDD')
                AND A.START_DT <= TO_DATE('20210118','YYYYMMDD')
                AND (NVL(TRIM(A.INCRE_CRDT_MODE_CD),' ') IN ('共保','44INS_36GR_20GUR','49.5INS_40.5GR_10GUR')
                 OR NVL(TRIM(A.INCRE_CRDT_MODE_CD),' ') LIKE '%\_%\_%' ESCAPE '\')  --增信模式
               THEN '华兴R20201010-0'  --平安普惠（经营/消费）+四方+2020年10月10日至2022年10月9日
               WHEN A.PROD_ID IN ('202020200002','202010200005')
                AND A.START_DT >= TO_DATE('20210119','YYYYMMDD')
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
                --AND A.START_DT <= TO_DATE('20241108','YYYYMMDD')
                AND A.START_DT <= TO_DATE('20241024','YYYYMMDD') --MOD BY LIP 20241202 签署了新的协议就按新的协议执行
                AND NVL(TRIM(A.INCRE_CRDT_MODE_CD),'0') IN ('100%GUR')  --增信模式
               THEN '华兴R20221115-01'  --平安普惠（经营/消费）+两方+2022年11月15日至2024年10月24日
               --ADD BY LIP 20241202 增加新增的两方协议 现在新放款的只有两方协议的模式，以前的三方协议、四方协议都没新投放的业务，所以没签订新的三方、四方协议。
               WHEN A.PROD_ID IN ('202020200002','202010200005')
                AND A.START_DT >= TO_DATE('20241025','YYYYMMDD')
                AND A.START_DT <= TO_DATE('20261007','YYYYMMDD')
                AND NVL(TRIM(A.INCRE_CRDT_MODE_CD),'0') IN ('100%GUR')  --增信模式
               THEN '华兴R20241025-01'  --平安普惠（经营/消费）+两方+2024年10月25日至2026年10月7日
               WHEN A.PROD_ID IN ('201010300035'\*,'201010300040'*\,'201020100059') THEN 'JR20250300' --ADD BY LIP 20250403 华兴好易贷（担保） --MOD BY YJY 20250811华兴好易贷（经营-担保）201020100059、华兴好易贷（信用） 201010300040
               --WHEN A.PROD_ID = '201010300041' THEN '201010300041华兴好易贷华强' --华兴好易贷（华强） ADD BY LIP 20250709 --协议号先虚拟一个
               --WHEN A.PROD_ID = '201020100062' AND F.CONT_ID IS NOT NULL THEN '201020100062饲料e贷-海大集团'  --饲料e贷-海大集团 ADD BY YJY 20250718 --协议号先虚拟一个
               --WHEN A.PROD_ID = '201020100061' AND F.CONT_ID IS NOT NULL THEN '201020100061兴采贷（大参林）'  --兴采贷（大参林） ADD BY YJY 20250718 --协议号先虚拟一个
               WHEN A.PROD_ID = '202010200012' THEN '20250919004' --360借条 ADD BY LIP 20250826 --协议号先虚拟一个 --MOD BY YJY 20250923
          END                                         AS COOP_AGRT_ID               --合作协议编号 --MOD BY HULJ 20221220*/
         ,CASE WHEN H.PRODUCTID IS NOT NULL THEN MAINAGREEMENTNO
               WHEN A.PROD_ID IN ('202020200002','202010200005') --平安普惠/平安普惠（消费）
                AND (NVL(TRIM(A.INCRE_CRDT_MODE_CD),' ') IN ('共保','44INS_36GR_20GUR','49.5INS_40.5GR_10GUR')
                     OR NVL(TRIM(A.INCRE_CRDT_MODE_CD),' ') LIKE '%\_%\_%' ESCAPE '\')  --增信模式
               THEN 'PA2025091601;PA2022112502' --平安普惠（经营/消费）+四方
               WHEN A.PROD_ID IN ('202020200002','202010200005')
                AND (NVL(TRIM(A.INCRE_CRDT_MODE_CD),'0') IN ('0','-','非共保','80%INS_20%GUR','99%ins_1%gur','90%INS_10%GU')
                     OR NVL(TRIM(A.INCRE_CRDT_MODE_CD),' ') LIKE '%\_%' ESCAPE '\') --增信模式
               THEN 'PA2025091601;PA2022112501' --平安普惠（经营/消费）+三方
               WHEN A.PROD_ID IN ('202020200002','202010200005') --AND NVL(TRIM(A.INCRE_CRDT_MODE_CD),'0') IN ('100%GUR') --增信模式
               THEN 'PA2025091601' --平安普惠（经营/消费）+两方
          END                                         AS COOP_AGRT_ID               --合作协议编号 --MOD BY LIP 20251111
         --,NVL(TB.CUST_DATA_AUTH_ID,'合作方未提供')   AS CUST_DATA_AUTH_ID          --客户数据授权书编号
         ,NVL(TB.AUTHOBKID,'合作方未提供')            AS CUST_DATA_AUTH_ID          --客户数据授权书编号 --MOD BY LIP 20250310
         ,CASE WHEN TB.AUTHOBKID IS NOT NULL THEN TB.AUTHOSTRDATE --MOD BY LIP 20250310
               ELSE TO_CHAR(A.SIGN_DT,'YYYYMMDD') --ADD BYY YJY 20250718 兜底处理
           END                                        AS GRANT_EFF_DT               --授权生效日期
         ,CASE WHEN TB.AUTHOBKID IS NOT NULL THEN TB.AUTHOENDDATE --MOD BY LIP 20250310
               WHEN TO_CHAR(A.EXP_DT,'YYYYMMDD') NOT IN ('00010101','29991231')
               THEN TO_CHAR(A.EXP_DT,'YYYYMMDD')
               WHEN TO_CHAR(A.TERMNT_DT,'YYYYMMDD') NOT IN ('00010101','29991231')
               THEN TO_CHAR(A.TERMNT_DT,'YYYYMMDD')
           END                                        AS GRANT_END_DT               --授权终止日期
         ,CASE WHEN A.PROD_ID IN ('202020200005','202020200005','202020200006') THEN A.CONT_AMT --网商小贷
               WHEN A.PROD_ID IN ('202010200003') THEN A.CONT_AMT --0 --玖富万卡 20220422张家伟邮件
               WHEN A.PROD_ID IN ('202020200003','202020200004','202010200004') THEN A.CONT_AMT --人保助贷（经营/消费）
               WHEN A.PROD_ID IN ('202010200008') THEN A.CONT_AMT --0 --趣店 20220422张家伟邮件
               WHEN A.PROD_ID IN ('202010200005','202020200002') THEN A.CONT_AMT  --平安普惠（经营/消费）
               WHEN A.PROD_ID IN ('201010300035','201010300041') THEN A.CONT_AMT --华兴好易贷（担保） 华兴好易贷（华强）--ADD BY LIP 20250403
               ELSE A.CONT_AMT --ADD BY YJY 20250718 兜底处理
           END                                        AS PNR_RESP_AMT               --合作方责任金额
         ,NVL(TRIM(E.OPEN_ACCT_RSRV_MOBILE_NO),TRIM(E.CONT_NUM)) AS APP_PSN_TEL     --申请人联系电话
         ,NVL(TA.TAR_VALUE_CODE,'99')                 AS CONT_STAT                  --合同状态
         ,NULL                                        AS DEPT_LINE                  --部门条线
         ,'零售贷款'                                  AS DATA_SRC                   --数据来源
         ,CASE WHEN A.CONT_AMT = 0 THEN 0
               WHEN NVL(H1.RELA_AMT,0)/ A.CONT_AMT >= 1 THEN 1
               ELSE ROUND( NVL(H1.RELA_AMT,0) / A.CONT_AMT ,8)
           END                                        AS GUAR_RATE                  --担保率
         ,CASE -- ADD BY YJY 20250115 新增对房抵贷产品的日期判断
               WHEN A.PROD_ID = '201020100057'
                AND (A.TERMNT_DT >= V_MONTH_START_DATE - 1 OR A.TERMNT_DT = TO_DATE('00010101','YYYYMMDD'))
               THEN 'Y'
               WHEN (A.TERMNT_DT >= V_MONTH_START_DATE OR A.TERMNT_DT = TO_DATE('00010101','YYYYMMDD'))
               THEN 'Y'
               ELSE 'N'
           END                                        AS MON_FLG                    --月口径标识
         ,TO_CHAR(A.TERMNT_DT,'YYYYMMDD')             AS TERMNT_DT                  --终止日期
         ,A.LOAN_HAPP_TYPE_CD                         AS LOAN_HAPP_TYPE_CD          --贷款发生类型
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
           END                                        AS HIGH_TECH_PROPERTY_TYPE_CD  --高技术产业类型代码
         ,CASE SUBSTR(REPLACE(NVL(TRIM(A.DIGIT_ECON_CORE_PROPERTY_TYPE_CD),'06'),'999999','06'),1,2) --modify by weiyongzhao 20221116 优化逻辑
               WHEN '01' THEN '01' --数字产品制造业
               WHEN '02' THEN '02' --数字产品服务业
               WHEN '03' THEN '03' --数字技术应用业
               WHEN '04' THEN '04' --数字要素驱动业
               WHEN '05' THEN '05' --数字化效率提升业
               WHEN '06' THEN '06' --非数据经济核心产业
               ELSE '06' --非数据经济核心产业
           END                                        AS DIGIT_ECON_CORE_PROPERTY_TYPE_CD  --数字经济核心产业类型代码
         ,DECODE(SUBSTR(NVL(TRIM(A.INTEL_PROP_INTE_PROPERTY_TYPE_CD),'99'),1,2),'99','0','-','0','1') AS INTEL_PROP_INTE_PROPERTY_TYPE_CD  --是否投向知识产权密集型产业
         ,DECODE(SUBSTR(NVL(TRIM(A.CUL_AND_RELA_PROPERTY_TYPE_CD),'99'),1,2),'99','0','-','0','1')    AS CUL_PROPERTY_FLG        --文化产业标志
         ,SUBSTR(REPLACE(NVL(TRIM(A.STRTG_NEW_INDUS_TYPE_CD),'0'),'999999','0'),1,1)                  AS STRATE_NEW_INDUS_TYPE_CD--战略性新兴产业类型代码 --零售部分的战略性新兴产业类型代码修正映射关系
         /*,CASE SUBSTR(REPLACE(NVL(TRIM(A.STRTG_NEW_INDUS_TYPE_CD),'0'),'999999','0'),1,1)
               WHEN '7' THEN 'C' --节能环保
               WHEN '1' THEN 'D' --新一代信息技术
               WHEN '4' THEN 'E' --生物医药
               WHEN '2' THEN 'F' --高端装备制造
               WHEN '6' THEN 'G' --新能源
               WHEN '3' THEN 'H' --新材料
               WHEN '5' THEN 'I' --新能源汽车
               WHEN '8' THEN 'J' --数字创意产业
               WHEN '9' THEN 'K' --相关服务业
               ELSE 'NA' END                          AS STRATE_NEW_INDUS_TYPE_CD            --战略性新兴产业类型代码 --modify by PSF 20250912  */
         ,NULL                                        AS SPE_SOPH_UNQ_NEW_MED_SIDE_ENTER_FLG --专精特新中小企业标志
         ,NULL                                        AS SPE_SOPH_UNQ_NEW_LTE_GNT_CORP_FLG   --专精特新小巨人企业标志
         ,NULL                                        AS CONT_TYPE_CD                        --合同类型代码
         ,D.GREEN_CONSM_SUB_TYPE_CD                   AS GREEN_CONSM_SUB_TYPE_CD             --绿色消费子类代码
         ,NULL                                        AS INDU_CORP_TECH_REM_UGD_FLG          --工业企业技术改造升级标志   ADD BY YJY 20240507
         ,NULL                                        AS SEED_LOAN_FLG                       --种业振兴贷款标志           ADD BY YJY 20240507
         ,NULL                                        AS COUNTY_LOAN_FLG                     --县城区贷款标志             ADD BY YJY 20240507
         /*,DECODE(SUBSTR(NVL(TRIM(A.PROVI_FOR_AGED_PROPERTY_FLG),'99'),1,2),'99','0','-','0','1')*/  --MOD BY YJY 20260106 直取信贷字段
         ,A.PROVI_FOR_AGED_PROPERTY_FLG               AS PROVI_FOR_AGED_PROPERTY_FLG         --养老产业标志ADD BY YJY 20240507 MOD BY YJY 20251126
         ,NULL                                        AS PPP_PROJ_FLG                        --投向政府和社会资本合作项目标志  ADD BY YJY 20240507
         ,NULL                                        AS NEW_DISTR_FLG                       --新机制发放贷款标志         ADD BY YJY 20240507
         ,SUBSTR(NVL(TRIM(A.INTEL_PROP_INTE_PROPERTY_TYPE_CD),'99'),1,2) AS PROP_PROPERTY_TYPE_CD  --知识产权产业类型代码 ADD BY HYF 20240528
         ,SUBSTR(NVL(TRIM(A.CUL_AND_RELA_PROPERTY_TYPE_CD),'99'),1,2)    AS CUL_AND_RELA_PPTY_TYPE_CD --文化及相关产业类型代码 ADD BY HYF 20240528
         ,A.PROD_ID                                   AS STD_PROD_ID                         --标准产品编号 --ADD BY LIP 20240822
         ,CASE WHEN SUBSTR(REPLACE(NVL(TRIM(A.HIGH_TECH_PROPERTY_TYPE_CD),'08'),'999999','08'),1,2) IN ('01','02','03','04','05','06')
               THEN 'Y' --零售贷款合同表没有投向高技术产业标志，通过高技术产业类型代码判断
               ELSE 'N'
           END                                         AS HIGH_TECH_PROPERTY_FLG             --投向高技术产业标志  ADD BY YJY 20250605
         ,CASE --ADD BY YJY 20250115 新增对房抵贷产品的日期判断
               WHEN A.PROD_ID = '201020100057'
                AND (A.TERMNT_DT >= V_YEAR_START_DATE - 1 OR A.TERMNT_DT = TO_DATE('00010101','YYYYMMDD'))
               THEN 'Y'
               WHEN (A.TERMNT_DT >= V_YEAR_START_DATE OR A.TERMNT_DT = TO_DATE('00010101','YYYYMMDD'))
               THEN 'Y'
               ELSE 'N'
           END                                         AS YEAR_FLG                            --年标识     ADD BY CJJ 20251016
        ,G.USERID                                      AS APRV_EMP_NO                         --审批员工ID ADD BY ZLY 20251017
        ,CASE WHEN A.PROD_ID NOT IN ('202020200007','201010300005','202010200012') AND TRIM(A.LMT_CONT_ID) IS NOT NULL --新心金融 新兴贷 360借条 的授信单独处理
              THEN A.LMT_CONT_ID
              WHEN A.PROD_ID NOT IN ('202020200007','201010300005','202010200012')
              THEN A.CONT_ID
              WHEN A.PROD_ID = '202010200012' THEN TRIM(A.APLV_FLOW_NUM) --360借条
              WHEN T1.PROD_ID IS NOT NULL THEN T1.LOAN_APPL_FLOW_NUM --新心金融
              WHEN T2.CONT_ID IS NOT NULL THEN T2.DUBIL_ID --新兴贷
          END                                          AS CRDT_LMT_ID_NEW                     --新授信合同编号 --ADD BY LIP 20260129 与授信表中的各产品的授信保持一致
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO A --零售贷款合同信息
    LEFT JOIN (SELECT H.CONT_ID,SUM(H.RELA_AMT) RELA_AMT
                 FROM RRP_MDL.O_IML_AGT_LOAN_CONT_RELA_TAB_INFO_H H --贷款合同关联表信息历史
                WHERE H.OBJ_TYPE_NAME = 'GuarantyContract'
                GROUP BY H.CONT_ID) H1
      ON H1.CONT_ID = A.CONT_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO E --个人客户基本信息
      ON E.CUST_ID = A.CUST_ID
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    /*LEFT JOIN RRP_MDL.ADD_LOAN_DUBIL_CUST_DATA_AUTH_ID TB --贷款合同对应客户数据授权书编号 目前只有网商小贷有，合同号不重复
      ON TB.CONT_ID = A.CONT_ID*/
    LEFT JOIN RRP_MDL.M_LOAN_CONT_INFO_TEMP03 TB --信贷合同表--客户授权书相关信息 --ADD BY LIP 20250310
      ON TB.CONT_ID = A.CONT_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO PROD --标准产品信息
      ON PROD.PROD_ID = A.PROD_ID
     AND PROD.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD C --公共代码表  --CD1274贷款用途  ADD BY MW 20221126
      ON C.CD_VAL = A.BORW_USAGE_TYPE_CD
     AND C.CD_ID = 'CD1274'
    LEFT JOIN RRP_MDL.CODE_MAP TA --合同状态转码 CD1259-->D0117
      ON TA.SRC_VALUE_CODE = A.CONT_STATUS_CD
     AND TA.SRC_CLASS_CODE = 'CD2586'
     AND TA.TAR_CLASS_CODE = 'D0117'
     AND TA.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TC --担保方式1转码 CD1244-->D0037
      ON TC.SRC_VALUE_CODE = A.MAJOR_GUAR_WAY_CD
     AND TC.SRC_CLASS_CODE = 'CD2656'
     AND TC.TAR_CLASS_CODE = 'D0002'
     AND TC.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TE  --码值映射表(贷款类型) --MODIFY BY XIEYUGENG 20221021
      ON TE.SRC_VALUE_CODE = A.PROD_ID
     AND TE.SRC_CLASS_CODE = 'STD0002'
     AND TE.TAR_CLASS_CODE = 'T0001'
     AND TE.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.O_IML_AGT_LOAN_CONT_INDV_LOAN_ATTACH_INFO_H D --贷款合同个人贷款附属信息历史 add by hulj20230810
      ON D.CONT_ID = A.CONT_ID
     AND D.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND D.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN CMM_RETL_LOAN_DUBIL_INFO_TMP F --ADD BY YJY 20250718 海大集团互联网贷款临时表
      ON F.CONT_ID = A.CONT_ID
    LEFT JOIN (SELECT ROW_NUMBER() OVER(PARTITION BY OBJECTNO ORDER BY SERIALNO DESC) AS RN
                      ,USERID      --审批员工ID
                      ,USERNAME
                      ,ORGID
                      ,OBJECTNO
                 FROM RRP_MDL.O_IOL_ICMS_FLOW_TASK  --
                WHERE OBJECTTYPE = 'RetailContractApprove' --零售
                  AND START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')) G
      ON G.OBJECTNO = A.CONT_ID
     AND G.RN = 1
    LEFT JOIN ADD_LOAN_NET_COOP_SUB H --MOD BY LIP 20251111 根据信贷登记的互联网合作协议编号调整映射
      ON H.PRODUCTID = A.PROD_ID
    LEFT JOIN LOAN_LMT_INFO T1 --ADD BY LIP 20260129 需特殊处理的授信合同号，新兴金融
      ON T1.CUST_ID = A.CUST_ID
     AND T1.PROD_ID = A.PROD_ID
     AND T1.RN = 1
    LEFT JOIN XXD_LMT_INFO T2 --ADD BY LIP 20260129 需特殊处理的授信合同号,新兴贷
      ON T2.CONT_ID = A.CONT_ID
     AND T2.RN = 1
   WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '贷款合同信息--联合网贷部分';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_LOAN_CONT_INFO_TEMP02
    (DATA_DT                  --数据日期
    ,LGL_REP_ID               --法人编号
    ,CONT_ID                  --合同编号
    ,CONT_NM                  --合同名称
    ,PRIM_CONT_ID             --主合同号
    ,CUST_ID                  --客户编号
    ,ORG_ID                   --机构编号
    ,APP_ID                   --申请编号
    ,CRDT_LMT_ID              --授信额度编号
    ,LOAN_PROD_TYP            --贷款产品类型
    ,LOAN_PROD_NM             --贷款产品名称
    ,CUR                      --币种
    ,CONT_AMT                 --合同金额
    ,CONT_START_DT            --合同开始日期
    ,CONT_EXP_DT              --合同到期日期
    ,MAIN_GUA_MODE            --担保方式1
    ,SUB_GUA_MODE             --担保方式2
    ,CUST_MGR_NO              --客户经理工号
    ,LOAN_USEAGE              --贷款用途
    ,DIR_RGN_AREA_CD          --投向地区行政区划
    ,DIR_IDY                  --投向行业
    ,FIN_LOAN_REL_LC_NO       --融资贷款关联信用证号
    ,CONT_SIGN_DT             --合同签订日期
    ,COOP_AGRT_ID             --合作协议编号
    ,CUST_DATA_AUTH_ID        --客户数据授权书编号
    ,GRANT_EFF_DT             --授权生效日期
    ,GRANT_END_DT             --授权终止日期
    ,PNR_RESP_AMT             --合作方责任金额
    ,APP_PSN_TEL              --申请人联系电话
    ,CONT_STAT                --合同状态
    ,DEPT_LINE                --部门条线
    ,DATA_SRC                 --数据来源
    ,TERMNT_DT                --终止日期
    ,MON_FLG                  --月标识
    ,LOAN_HAPP_TYPE_CD        --贷款发生类型
    ,HIGH_TECH_PROPERTY_TYPE_CD            --高技术产业类型代码
    ,DIGIT_ECON_CORE_PROPERTY_TYPE_CD      --数字经济核心产业类型代码
    ,INTEL_PROP_INTE_PROPERTY_TYPE_CD      --是否投向知识产权密集型产业
    ,CUL_PROPERTY_FLG                      --文化产业标志
    ,STRATE_NEW_INDUS_TYPE_CD              --战略性新兴产业类型代码
    ,SPE_SOPH_UNQ_NEW_MED_SIDE_ENTER_FLG   --专精特新中小企业标志
    ,SPE_SOPH_UNQ_NEW_LTE_GNT_CORP_FLG     --专精特新小巨人企业标志
    ,ACP_DISTR_AMT                         --花呗放款金额               ADD BY 20240103
    ,INDU_CORP_TECH_REM_UGD_FLG            --工业企业技术改造升级标志   add by yjy 20240507
    ,SEED_LOAN_FLG                         --种业振兴贷款标志           add by yjy 20240507
    ,COUNTY_LOAN_FLG                       --县城区贷款标志             add by yjy 20240507
    ,PROVI_FOR_AGED_PROPERTY_FLG           --养老产业标志               add by yjy 20240507
    ,PPP_PROJ_FLG                          --投向政府和社会资本合作项目标志  add by yjy 20240507
    ,NEW_DISTR_FLG                         --新机制发放贷款标志         add by yjy 20240507
    ,PROP_PROPERTY_TYPE_CD                 --知识产权产业类型代码       add by HYF 20240528
    ,CUL_AND_RELA_PPTY_TYPE_CD             --文化及相关产业类型代码     add by HYF 20240528
    ,STD_PROD_ID                           --标准产品编号               ADD BY LIP 20240822
    ,HIGH_TECH_PROPERTY_FLG                --投向高技术产业标志         ADD BY YJY 20250605
    ,YEAR_FLG                              --年标识                     ADD BY CJJ 20251016
    ,APRV_EMP_NO                           --审批员工ID                 ADD BY ZLY 20251017
    ,CRDT_LMT_ID_NEW                       --新授信合同编号 --ADD BY LIP 20260129
    )
    /*WITH ADD_LOAN_NET_COOP_SUB_TMP AS ( --只拿信用的
  SELECT DISTINCT T.COOP_AGRT_ID
         ,TO_DATE(T.AGRT_START_DT||' 000000','YYYYMMDD HH24MISS') AGRT_START_DT
         ,CASE WHEN T.COOP_AGRT_ID = 'XZI32018000164'
               THEN TO_DATE(T.ACT_END_DT||' 235959','YYYYMMDD HH24MISS')-1
               ELSE TO_DATE(T.ACT_END_DT||' 235959','YYYYMMDD HH24MISS')
          END ACT_END_DT
         ,T.DATA_SRC
         ,T.COOP_PROD
         ,SUBSTR(T.COOP_PROD, 1, INSTR(T.COOP_PROD, '、') - 1) COOP_PROD1
         ,SUBSTR(T.COOP_PROD, INSTR(T.COOP_PROD, '、') + 1) COOP_PROD2
    FROM RRP_MDL.ADD_LOAN_NET_COOP_SUB T
   WHERE T.DBFS IS NULL
    AND T.COOP_AGRT_ID NOT IN ('CT20250306101185-1')), --字节的四方合同单独判断  -- MOD BY LIP 20251014
  ADD_LOAN_NET_COOP_SUB_TMP1 AS (
  SELECT COOP_AGRT_ID
         ,AGRT_START_DT
         ,ACT_END_DT
         ,DATA_SRC
         ,COOP_PROD1
         ,COOP_PROD2
         ,ROW_NUMBER() OVER(PARTITION BY COOP_PROD ORDER BY ACT_END_DT DESC,AGRT_START_DT DESC) RN
    FROM ADD_LOAN_NET_COOP_SUB_TMP T),*/
    WITH HLW_LOAN_AGREEMENT_INFO AS (--MOD BY LIP 20251111 根据信贷登记的互联网合作协议信息调整映射口径
  SELECT T1.PRODUCTID,T1.PRODUCTNAME,
         LISTAGG(DISTINCT T1.MAINAGREEMENTNO,';') WITHIN GROUP(ORDER BY 1) AS MAINAGREEMENTNO
    FROM RRP_MDL.O_IOL_ICMS_HLW_LOAN_AGREEMENT_INFO T1 --互联网贷款产品合作协议信息表
   WHERE T1.PRODUCTID NOT LIKE '%202020200004%' --网商贷的单独处理
     AND T1.PRODUCTID NOT LIKE '%202020100001%' --网商贷的单独处理
     AND T1.PRODUCTID NOT LIKE '%202020200002%' --平安普惠的单独处理
     AND T1.PRODUCTID NOT LIKE '%202010200005%' --平安普惠的单独处理
     AND NVL(T1.DATASTATUS,'01') = '01' --01有效 02停用 --ADD BY LIP 20260116 过滤停用的数据
     AND T1.ID_MARK <> 'D'
     AND T1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   GROUP BY T1.PRODUCTID,T1.PRODUCTNAME),
   ADD_LOAN_NET_COOP_SUB AS (
  SELECT REGEXP_SUBSTR(PRODUCTID,'[^,]+', 1,LEVEL) PRODUCTID,MAINAGREEMENTNO
    FROM HLW_LOAN_AGREEMENT_INFO
 CONNECT BY LEVEL <= LENGTH(PRODUCTID) - LENGTH(REPLACE(PRODUCTID, ',')) + 1
   GROUP BY REGEXP_SUBSTR(PRODUCTID, '[^,]+', 1, LEVEL),MAINAGREEMENTNO),
   UNITE_WL_DISTR_DTL AS (
  SELECT /*+MATERIALIZE*/B.DUBIL_ID,SUM(B.DISTR_AMT) AS DISTR_AMT
    FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DISTR_DTL B
   INNER JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO TA
      ON TA.DUBIL_ID = B.DUBIL_ID
     AND TA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE B.JOB_CD LIKE 'myhb%'
     AND B.DISTR_AMT > 0
     AND B.ETL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   GROUP BY B.DUBIL_ID), --花呗的放款金额从流水表中取数
  WSD_COOP_AGRT_ID AS (
  --ADD BY LIP 20250725 网商贷的部分互联网合作协议无法通过放款日期或借据类型判断，需根据担保人来判断对应的合作协议
  SELECT /*+MATERIALIZE*/
         TB.DUBIL_ID,T.GUARTOR_NAME,TB.PROD_ID,TB.LOAN_TYPE_CD,TB.DISTR_DT,TB.GUAR_WAY_CD,
         CASE WHEN SUBSTR(TB.LOAN_TYPE_CD,1,2) = '00' AND SUBSTR(TB.LOAN_TYPE_CD,7,1) = '1' --网商贷（债权直转）
              THEN CASE /*WHEN T.GUARTOR_NAME = '商诚融资担保有限公司' THEN '2023081859072'
                        WHEN T.GUARTOR_NAME = '中国投融资担保股份有限公司' THEN '2024-A01-ZTB-026-DBHZ7'*/
                        WHEN T.GUARTOR_NAME = '重庆进出口融资担保有限公司' THEN 'CQEXG融-拓1-2022-019-E'
                        WHEN T.GUARTOR_NAME = '中证信用融资担保有限公司' THEN 'GDHX-ZZ-JHZZ-2024-01'
                    END --网商贷债权直转数据
              WHEN SUBSTR(TB.LOAN_TYPE_CD,1,2) = '14' AND SUBSTR(TB.LOAN_TYPE_CD,4,1) = '2' AND SUBSTR(TB.LOAN_TYPE_CD,7,1) = '1'--助贷
              THEN CASE WHEN T.GUARTOR_NAME = '商诚融资担保有限公司' THEN '2024012391692'
                        WHEN T.GUARTOR_NAME = '中国投融资担保股份有限公司' THEN '2024-A01-ZTB-026-DBHZ7'
                        WHEN T.GUARTOR_NAME = '重庆进出口融资担保有限公司' THEN 'CQEXG融-拓1-2022-019-E'
                        WHEN T.GUARTOR_NAME = '中证信用融资担保有限公司' THEN 'GDHX-ZZ-JHZD-2024-01'
                    END --均衡助贷
              WHEN TB.LOAN_TYPE_CD IN ('13111210') AND T.GUARTOR_NAME = '重庆进出口融资担保有限公司'
              THEN 'CQEXG融-拓1-2022-019-E'
              WHEN TB.LOAN_TYPE_CD IN ('13111210') AND T.GUARTOR_NAME = '商诚融资担保有限公司'
              THEN '2023081859072'
              /*WHEN T.GUARTOR_NAME = '商诚融资担保有限公司' THEN 'WSD20230920004'
              WHEN T.GUARTOR_NAME = '中国投融资担保股份有限公司' THEN '2024-A01-ZTB-026-DBHZ7'
              WHEN T.GUARTOR_NAME = '中证信用融资担保有限公司' THEN 'GDHX-ZZ-JHZD-2024-01'
              WHEN T.GUARTOR_NAME = '重庆进出口融资担保有限公司' THEN 'CQEXG融-拓-1-2022-019' --张家伟反馈有担保方式，其他的是信用
              ELSE 'CQEXG融-拓-1-2022-019'*/
          END AS COOP_AGRT_ID, --其他网商贷数据
         ROW_NUMBER() OVER(PARTITION BY TB.DUBIL_ID ORDER BY TRIM(T.GUARTOR_NAME)) RN
    FROM RRP_MDL.O_ICL_CMM_UNITE_WL_LOAN_GUAR_CONT_RELA T --联合网贷贷款与担保合同关系
   INNER JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_LOAN_CONT_INFO TA
      ON TA.CONT_ID = T.LOAN_CONT_ID
     AND TA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO TB
      ON TB.CONT_ID = TA.CONT_ID
     AND TB.GUAR_WAY_CD = 'C' --担保方式是保证的
     AND TB.DUBIL_STATUS_CD NOT IN ('2','5')
     AND TB.STD_PROD_ID IN ('202020100001','202020200004') --网商贷
     AND TB.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE TRIM(T.GUARTOR_NAME) IS NOT NULL
     AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')),
    CMM_UNITE_WL_LMT_INFO_QC AS ( --ADD BY LIP 20260129
  SELECT /*+MATERIALIZE*/T.CUST_ID              AS CUST_ID      --客户号
        ,TRIM(T.LMT_CONT_ID)                    AS LMT_CONT_ID  --额度合同编号
        ,CASE WHEN T.BUS_BREED_ID IN ('02001004165051','02001004120222','202010100001','202010100002') THEN '202010100001' --借呗
              WHEN T.BUS_BREED_ID IN ('02001004165085','202010100004','202010100005') THEN '202010100004' --京东
              WHEN T.BUS_BREED_ID IN ('02001004135021','202010100003') THEN '202010100003' --花呗
              WHEN T.BUS_BREED_ID IN ('0900600100001','202010100006') THEN '202010100006' --微粒贷
              ELSE T.BUS_BREED_ID
          END                                   AS BUS_BREED_ID1 --统一后的授信品种
        ,ROW_NUMBER() OVER(PARTITION BY CUST_ID,
                          CASE WHEN T.BUS_BREED_ID IN ('02001004165051','02001004120222','202010100001','202010100002') THEN '202010100001' --借呗
                               WHEN T.BUS_BREED_ID IN ('02001004165085','202010100004','202010100005') THEN '202010100004' --京东
                               WHEN T.BUS_BREED_ID IN ('02001004135021','202010100003') THEN '202010100003' --花呗
                               WHEN T.BUS_BREED_ID IN ('0900600100001','202010100006') THEN '202010100006' --微粒贷
                               ELSE T.BUS_BREED_ID
                           END
                          ORDER BY BEGIN_DT DESC,T.LMT_CONT_ID DESC) AS RN          --去重
    FROM RRP_MDL.O_ICL_CMM_UNITE_WL_LMT_INFO T --联合网贷额度信息
   WHERE TRIM(T.CUST_ID) IS NOT NULL
     AND T.CRDT_LMT > 0
     AND ((T.BUS_BREED_ID IN ('202010100008','202020100003') AND T.STATUS_CD = '01')
         OR T.BUS_BREED_ID NOT IN ('202020100001','202020200004','02001006135011',
                                   '02001006160048','202010100008','202020100003')) --微粒贷只取审批通过 剔除网商贷
     AND ((NVL(T.BEGIN_DT,TO_DATE('00010101','YYYYMMDD')) <= TO_DATE(V_P_DATE,'YYYYMMDD') - 1 
           AND T.BUS_BREED_ID NOT IN ('202010200011','202010200010','201020100063'))
          OR (NVL(T.BEGIN_DT,TO_DATE('00010101','YYYYMMDD')) <= TO_DATE(V_P_DATE,'YYYYMMDD')
              AND T.BUS_BREED_ID IN ('202010200011','202010200010','201020100063'))
          OR T.BEGIN_DT = TO_DATE('20991231','YYYYMMDD')
          OR T.BEGIN_DT = TO_DATE('99991231','YYYYMMDD'))
     AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT  V_P_DATE                                    AS DATA_DT                    --数据日期
         ,A.LP_ID                                     AS LGL_REP_ID                 --法人编号
         ,A.DUBIL_ID                                  AS CONT_ID                    --合同编号
         ,A.DUBIL_ID                                  AS CONT_NM                    --合同名称
         ,A.DUBIL_ID                                  AS PRIM_CONT_ID               --主合同号
         ,A.CUST_ID                                   AS CUST_ID                    --客户编号
         ,A.ACCT_INSTIT_ID                            AS ORG_ID                     --机构编号
         ,A.RELA_APPL_FLOW_NUM                        AS APP_ID                     --申请编号 MODIFY BY MW 2022/11/26
         ,T3.LMT_CONT_ID                              AS CRDT_LMT_ID                --授信额度编号
         ,CASE WHEN D.TAR_VALUE_CODE IS NOT NULL THEN D.TAR_VALUE_CODE
               ELSE '01'  --个人贷款
           END                                        AS LOAN_PROD_TYP              --贷款产品类型   --MODIFY BY XIEYUGENG 20221021
         --MOD BY LIP 20230915 将网商贷债权直转的标记出来以便区分
         ,CASE WHEN A.STD_PROD_ID IN ('202020100001','202020200004')
                AND SUBSTR(A.LOAN_TYPE_CD,1,2) = '00' AND SUBSTR(A.LOAN_TYPE_CD,7,1) = '1' --网商贷（债权直转）
               THEN '网商贷（债权直转）'
               ELSE T4.PROD_NAME
           END                                        AS LOAN_PROD_NM               --贷款产品名称
         ,A.CURR_CD                                   AS CUR                        --币种
         --MOD BY LIP 20230915 网商贷债权直转的取原本的放款金额
         ,CASE WHEN A.STD_PROD_ID IN ('202020100001','202020200004')
                AND SUBSTR(A.LOAN_TYPE_CD,1,2) = '00' AND SUBSTR(A.LOAN_TYPE_CD,7,1) = '1' --网商贷（债权直转）
               THEN A.INIT_DISTR_AMT
               WHEN NVL(A.CONT_AMT,0) <> 0 THEN A.CONT_AMT
               WHEN NVL(DTL.DISTR_AMT,0) <> 0 THEN DTL.DISTR_AMT
               WHEN NVL(A.DISTR_AMT,0) <> 0 THEN A.DISTR_AMT --MOD BY 20250702
               ELSE 0
           END                                        AS CONT_AMT                   --合同金额
         --MOD BY LIP 20230925 因网商贷债权直转的放款时间是转入时间，该字段改成取原始放款日期
         /*,CASE WHEN TO_CHAR(A.INIT_DISTR_DT,'YYYYMMDD') IN ('00010101')
               THEN NULL
               ELSE TO_CHAR(A.INIT_DISTR_DT,'YYYYMMDD')
           END*/
         --MOD BY YJY 20260115 一表通要求对切日的数据进行兜底，默认为跑批日当天     
         ,CASE WHEN TO_CHAR(A.INIT_DISTR_DT,'YYYYMMDD') NOT IN ('00010101','29991231') AND TO_CHAR(A.INIT_DISTR_DT,'YYYYMMDD') <= V_P_DATE 
               THEN TO_CHAR(A.INIT_DISTR_DT,'YYYYMMDD')
               WHEN TRUNC(A.INIT_DISTR_DT) = TO_DATE(V_P_DATE,'YYYYMMDD') +1 
               THEN V_P_DATE --对切日的数据兜底
               ELSE NULL
           END                                        AS CONT_START_DT              --合同开始日期
         ,CASE WHEN TO_CHAR(A.EXP_DT,'YYYYMMDD') IN ('00010101')
               THEN NULL
               ELSE TO_CHAR(A.EXP_DT,'YYYYMMDD')
           END                                        AS CONT_EXP_DT                --合同到期日期
         ,NVL(TB.TAR_VALUE_CODE,'Z')                  AS MAIN_GUA_MODE              --担保方式1
         ,NULL                                        AS SUB_GUA_MODE               --担保方式2
         ,A.CUST_MGR_ID                               AS CUST_MGR_NO                --客户经理工号  --MODIFY BY HULJ 20221021
         ,T5.CD_DESCB                                 AS LOAN_USEAGE                --贷款用途
         ,NULL                                        AS DIR_RGN_AREA_CD            --投向地区行政区划代码
         ,A.DIR_INDUS_CD                              AS DIR_IDY                    --投向行业
         ,NULL                                        AS FIN_LOAN_REL_LC_NO         --融资贷款关联信用证号
         ,CASE WHEN TO_CHAR(A.OPEN_ACCT_DT,'YYYYMMDD') IN ('00010101','29991231')
               THEN NULL
               ELSE TO_CHAR(A.OPEN_ACCT_DT,'YYYYMMDD')
           END                                        AS CONT_SIGN_DT               --合同签订日期
         /*,CASE WHEN A.PROD_ID IN ('202020100001','202020200004')
                AND SUBSTR(A.LOAN_TYPE_CD,1,2) = '00' AND SUBSTR(A.LOAN_TYPE_CD,7,1) = '1' --网商贷（债权直转）
               THEN '2023081859072' --网商贷债权直转数据
               --MOD BY LIP 20231017 均衡助贷的数据先按主协议编号
               WHEN A.PROD_ID = '202020200004' AND SUBSTR(A.LOAN_TYPE_CD,1,2) = '14'
                AND SUBSTR(A.LOAN_TYPE_CD,4,1) = '2' AND SUBSTR(A.LOAN_TYPE_CD,7,1) = '1'
               THEN 'WSD20230920001' --均衡助贷
               WHEN A.PROD_ID IN ('202020100001','202020200004') AND A.DISTR_DT >= TO_DATE('20221209','YYYYMMDD') --网商贷、网商贷（引流）
                AND NVL(TRIM(A.GUAR_WAY_CD),' ') NOT IN ('D')
               THEN 'CQEXG融-拓-1-2022-019'--张家伟反馈有担保方式，其他的是信用
               WHEN TRIM(C.COOP_AGRT_ID) IS NOT NULL THEN TRIM(C.COOP_AGRT_ID)
               WHEN TRIM(F.COOP_AGRT_ID) IS NOT NULL THEN TRIM(F.COOP_AGRT_ID)
               WHEN TRIM(CC.COOP_AGRT_ID) IS NOT NULL THEN TRIM(CC.COOP_AGRT_ID)
               WHEN TRIM(FF.COOP_AGRT_ID) IS NOT NULL THEN TRIM(FF.COOP_AGRT_ID)
           END                                        AS COOP_AGRT_ID               --合作协议编号 --MODIFY BY LIP 20220530 根据张家伟反馈数据修改*/
         --MOD BY LIP 20250731 因网商贷要根据担保人判断对应的合作协议，所以讲合作协议编号调整成取多个的情况，用;分割
         /*,CASE WHEN T6.DUBIL_ID IS NOT NULL THEN T6.COOP_AGRT_ID
               WHEN A.STD_PROD_ID IN ('202020100001','202020200004')
                AND SUBSTR(A.LOAN_TYPE_CD,1,2) = '00' AND SUBSTR(A.LOAN_TYPE_CD,7,1) = '1' --网商贷（债权直转）
               THEN '2023081859072' --网商贷债权直转数据
               --MOD BY LIP 20231017 均衡助贷的数据先按主协议编号
               WHEN A.STD_PROD_ID = '202020200004' AND SUBSTR(A.LOAN_TYPE_CD,1,2) = '14'
                AND SUBSTR(A.LOAN_TYPE_CD,4,1) = '2' AND SUBSTR(A.LOAN_TYPE_CD,7,1) = '1'
               THEN 'WSD20230920001;WSD20230920004' --均衡助贷
               WHEN A.STD_PROD_ID IN ('202020100001','202020200004') AND A.DISTR_DT >= TO_DATE('20221209','YYYYMMDD') --网商贷、网商贷（引流）
                AND NVL(TRIM(A.GUAR_WAY_CD),' ') NOT IN ('D')
               THEN 'CQEXG融-拓-1-2022-019' --张家伟反馈有担保方式，其他的是信用
               \*字节业务2025年7月30日前的合同是只关联主协议号CT20250306101185
               2025年8月1日后的合同同时关联CT20250306101185和CT20250306101185-1两个协议
               --MOD BY LIP 20251014 根据张家伟提供口径，20250801后发放的字节贷款，报CT20250306101185和CT20250306101185-1两个协议*\
               WHEN A.STD_PROD_ID IN ('202020200001','202010200009') AND A.DISTR_DT >= TO_DATE('20250801','YYYYMMDD')
               THEN 'CT20250306101185;CT20250306101185-1'
               WHEN TRIM(C.COOP_AGRT_ID) IS NOT NULL THEN TRIM(C.COOP_AGRT_ID)
               WHEN TRIM(F.COOP_AGRT_ID) IS NOT NULL THEN TRIM(F.COOP_AGRT_ID)
               WHEN TRIM(CC.COOP_AGRT_ID) IS NOT NULL THEN TRIM(CC.COOP_AGRT_ID)
               WHEN TRIM(FF.COOP_AGRT_ID) IS NOT NULL THEN TRIM(FF.COOP_AGRT_ID)
           END                                        AS COOP_AGRT_ID               --合作协议编号*/
         ,CASE WHEN H.PRODUCTID IS NOT NULL THEN H.MAINAGREEMENTNO
               WHEN A.STD_PROD_ID IN ('202020100001','202020200004')
                AND SUBSTR(A.LOAN_TYPE_CD,1,2) = '00' AND SUBSTR(A.LOAN_TYPE_CD,7,1) = '1' --网商贷（债权直转）
               THEN '8202409240425901'||CASE WHEN T6.DUBIL_ID IS NOT NULL AND T6.COOP_AGRT_ID IS NOT NULL THEN ';'||T6.COOP_AGRT_ID END --网商贷债权直转数据
               --MOD BY LIP 20231017 均衡助贷的数据先按主协议编号
               WHEN A.STD_PROD_ID IN ('202020100001','202020200004') AND SUBSTR(A.LOAN_TYPE_CD,1,2) = '14'
                AND SUBSTR(A.LOAN_TYPE_CD,4,1) = '2' AND SUBSTR(A.LOAN_TYPE_CD,7,1) = '1' --均衡助贷
               THEN 'WSD20230920001'||CASE WHEN T6.DUBIL_ID IS NOT NULL AND T6.COOP_AGRT_ID IS NOT NULL THEN ';'||T6.COOP_AGRT_ID END --均衡助贷担保协议
               WHEN A.STD_PROD_ID IN ('202020100001','202020200004') --AND A.LOAN_TYPE_CD IN ('01111200','01121200') --联合贷
               THEN 'WSD20230505001'||CASE WHEN T6.DUBIL_ID IS NOT NULL AND T6.COOP_AGRT_ID IS NOT NULL THEN ';'||T6.COOP_AGRT_ID END --联合贷也有有保的
           END                                        AS COOP_AGRT_ID               --合作协议编号
         ,'合作方未提供'                              AS CUST_DATA_AUTH_ID          --客户数据授权书编号
         ,TO_CHAR(A.DISTR_DT,'YYYYMMDD')              AS GRANT_EFF_DT               --授权生效日期
         ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                AS GRANT_END_DT               --授权终止日期
          --MOD BY LIP 20230915 根据张家伟和吴楚非的口径调整
         ,A.CONT_AMT * ( 1-
          CASE WHEN A.GUAR_WAY_CD = 'C' THEN 0 --保证的都是100%
               WHEN A.STD_PROD_ID = '202010100003' THEN NVL(A.BANK_CONTRI_RATIO,1)  --蚂蚁花呗
               WHEN A.STD_PROD_ID = '202010100001' THEN NVL(A.BANK_CONTRI_RATIO,1) --蚂蚁借呗二期
               WHEN A.STD_PROD_ID IN ('202010100006','202010100008','202020100003') THEN NVL(A.BANK_CONTRI_RATIO,1)  --微粒贷 --modify by mw 20230522 新增微粒贷产品
               WHEN A.STD_PROD_ID = '202010100004' THEN 0.9
               WHEN A.STD_PROD_ID = '202010100002' THEN 1  --蚂蚁借呗三期
               WHEN A.STD_PROD_ID IN ('202020100001','202020200004')
                AND SUBSTR(A.LOAN_TYPE_CD,1,2) = '00' AND SUBSTR(A.LOAN_TYPE_CD,7,1) = '1' --网商贷（债权直转）
               THEN 1 --债权直转的出资比例 100
               WHEN (A.STD_PROD_ID IN ('202020100001','202020200004') AND A.GUAR_WAY_CD = 'D' --信用
                AND A.DISTR_DT >= TO_DATE('20180901','YYYYMMDD')
                AND A.DISTR_DT < TO_DATE('20190901','YYYYMMDD')) --日期带时间戳，用小于下一天
               THEN 0.9
               WHEN (A.STD_PROD_ID IN ('202020100001','202020200004') AND A.GUAR_WAY_CD = 'D' --信用
                AND A.DISTR_DT >= TO_DATE('20190901','YYYYMMDD')
                AND A.DISTR_DT < TO_DATE('20201208','YYYYMMDD'))
               THEN 1
               WHEN (A.STD_PROD_ID IN ('202020100001','202020200004') AND A.GUAR_WAY_CD = 'D' --信用
                AND A.DISTR_DT >= TO_DATE('20201208','YYYYMMDD')
                AND A.DISTR_DT < TO_DATE('20211125','YYYYMMDD'))
               THEN 0.9
               WHEN (A.STD_PROD_ID IN ('202020100001','202020200004') AND A.GUAR_WAY_CD = 'D' --信用
                AND A.DISTR_DT >= TO_DATE('20211125','YYYYMMDD')
                AND A.DISTR_DT < TO_DATE('20230412','YYYYMMDD'))
               THEN 0.65
               WHEN (A.STD_PROD_ID IN ('202020100001','202020200004') AND A.GUAR_WAY_CD = 'D' --信用
                AND A.DISTR_DT >= TO_DATE('20230412','YYYYMMDD'))
               THEN 0.7
               --WHEN A.STD_PROD_ID = '202020200001' THEN A.BANK_CONTRI_RATIO  --字节小微贷  MOD BY YJY 20250328
               ELSE A.BANK_CONTRI_RATIO  --MOD BY YJY 20250718 新增的联合网贷产品默认取借据表的银行出资比例
           END)                                       AS PNR_RESP_AMT               --合作方责任金额   --MODIFY BY HULJ 20221021
         ,NVL(TRIM(E.OPEN_ACCT_RSRV_MOBILE_NO),TRIM(E.CONT_NUM)) AS APP_PSN_TEL     --申请人联系电话
         ,NVL(TA.TAR_VALUE_CODE,'99')                 AS CONT_STAT                  --合同状态 CD1278-->D0117
         ,NULL                                        AS DEPT_LINE                  --部门条线
         ,'联合网贷部分'                              AS DATA_SRC                   --数据来源
         --,TO_CHAR(A.EXP_DT,'YYYYMMDD')                AS TERMNT_DT                  --终止日期
         ,TO_CHAR(A.PAYOFF_DT,'YYYYMMDD')             AS TERMNT_DT                  --终止日期 --MOD BY LIP 20251117
         ,CASE --MOD BY YJY 20251104 BEGIN 对分期乐、好企贷-数据贷（微业贷3.0）产品特殊处理
               WHEN A.STD_PROD_ID IN ('202010200011','202010200010','201020100063')  
                AND A.WRT_OFF_FLG = '1'
                AND (TFF.FIR_WRT_OFF_DT = TO_DATE('00010101','YYYYMMDD') OR NVL(TFF.FIR_WRT_OFF_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= V_MONTH_START_DATE)
               THEN 'Y' --分期乐、好企贷-数据贷（微业贷3.0）产品核销过且核销日期大于月初
               WHEN A.STD_PROD_ID IN ('202010200011','202010200010','201020100063') 
                AND A.WRT_OFF_FLG = '1'  
               THEN 'N' --分期乐、好企贷-数据贷（微业贷3.0）产品核销过的且核销日期小于月初的
               WHEN A.STD_PROD_ID IN ('202010200011','202010200010','201020100063')
                AND (A.PAYOFF_DT = TO_DATE('00010101','YYYYMMDD') OR A.PAYOFF_DT >= V_MONTH_START_DATE)     
               THEN 'Y' --分期乐、好企贷-数据贷（微业贷3.0）产品的结清日期为空，或者结清日期大于月初
               WHEN A.STD_PROD_ID IN ('202010200011','202010200010','201020100063')
                AND A.PAYOFF_DT < V_MONTH_START_DATE 
               THEN 'N' --分期乐、好企贷-数据贷（微业贷3.0）产品的结清日期小于月初
               --MOD BY YJY 20251104 END
               WHEN A.STD_PROD_ID IN ('202010100004') AND V_P_DATE > '20240601'
               THEN 'N' --数仓改造，与业务确认20240531之前京东金条的已经全部结清/核销
               WHEN A.STD_PROD_ID IN ('202010100004') AND A.WRT_OFF_FLG = '1' AND TFF.DUBIL_ID IS NULL
               THEN 'N' --MOD BY 20240704 调整京东金条的月标识
               WHEN A.WRT_OFF_FLG = '1' AND (TFF.FIR_WRT_OFF_DT = TO_DATE('00010101','YYYYMMDD')
                 OR NVL(TFF.FIR_WRT_OFF_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= V_MONTH_START_DATE - 1)
               THEN 'Y' --核销了且核销日期大于月初
               WHEN A.WRT_OFF_FLG = '1' THEN 'N' --核销了的且核销日期小于月初的
               WHEN A.PAYOFF_DT = TO_DATE('00010101','YYYYMMDD') OR (A.PAYOFF_DT >= V_MONTH_START_DATE - 1
                AND A.STD_PROD_ID NOT IN ('202010100004'))--'202010100004' 京东
               THEN 'Y' --结清日期为空，或者非京东的结清日期大于月初
               WHEN A.PAYOFF_DT < V_MONTH_START_DATE - 1 AND A.STD_PROD_ID NOT IN ('202010100004')
               THEN 'N' --非京东的结清日期小于月初
               WHEN NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0)+ NVL(A.OFF_BS_INT,0)+NVL(A.BAD_DEBT_PRIC,0) > 0
               THEN 'Y' --京东的有余额
               WHEN NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0)+ NVL(A.OFF_BS_INT,0)+NVL(A.BAD_DEBT_PRIC,0) = 0
                AND ((A.LAST_REPAY_DT = TO_DATE('00010101','YYYYMMDD') AND A.LAST_REPAY_DT >= A.DISTR_DT)
                     OR A.LAST_REPAY_DT >= V_MONTH_START_DATE - 1)
               THEN 'Y'
               ELSE 'N'
          END                                          AS MON_FLG                          --月口径标识
         ,NULL                                         AS LOAN_HAPP_TYPE_CD                --贷款发生类型
         ,NULL                                         AS HIGH_TECH_PROPERTY_TYPE_CD       --高技术产业类型代码
         ,NULL                                         AS DIGIT_ECON_CORE_PROPERTY_TYPE_CD --数字经济核心产业类型代码
         ,NULL                                         AS INTEL_PROP_INTE_PROPERTY_TYPE_CD --是否投向知识产权密集型产业
         ,CASE WHEN A.DIR_INDUS_CD = G.CODE THEN 1 ELSE 0 END AS CUL_PROPERTY_FLG          --文化产业标志
         ,NULL                                         AS STRATE_NEW_INDUS_TYPE_CD         --战略性新兴产业类型代码
         ,NULL                                         AS SPE_SOPH_UNQ_NEW_MED_SIDE_ENTER_FLG --专精特新中小企业标志
         ,NULL                                         AS SPE_SOPH_UNQ_NEW_LTE_GNT_CORP_FLG   --专精特新小巨人企业标志
         ,A.ACP_DISTR_AMT                              AS ACP_DISTR_AMT                       --花呗放款金额 --ADD BY 20240103
         ,NULL                                         AS INDU_CORP_TECH_REM_UGD_FLG          --工业企业技术改造升级标志   ADD BY YJY 20240507
         ,NULL                                         AS SEED_LOAN_FLG                       --种业振兴贷款标志           ADD BY YJY 20240507
         ,NULL                                         AS COUNTY_LOAN_FLG                     --县城区贷款标志             ADD BY YJY 20240507
         ,NULL                                         AS PROVI_FOR_AGED_PROPERTY_FLG         --养老产业标志               ADD BY YJY 20240507
         ,NULL                                         AS PPP_PROJ_FLG                        --投向政府和社会资本合作项目标志  ADD BY YJY 20240507
         ,NULL                                         AS NEW_DISTR_FLG                       --新机制发放贷款标志         ADD BY YJY 20240507
         ,NULL                                         AS PROP_PROPERTY_TYPE_CD               --知识产权产业类型代码       ADD BY HYF 20240528
         ,CASE WHEN G.L_CORE = '1' THEN '01'
               WHEN G.L_CORE = '2' THEN '02'
               WHEN G.L_CORE = '3' THEN '03'
               WHEN G.L_CORE = '4' THEN '04'
               WHEN G.L_CORE = '5' THEN '05'
               WHEN G.L_CORE = '6' THEN '06'
               WHEN G.L_CORE = '7' THEN '07'
               WHEN G.L_CORE = '8' THEN '08'
               WHEN G.L_CORE = '9' THEN '09'
               ELSE '99'
           END                                         AS CUL_AND_RELA_PPTY_TYPE_CD --文化及相关产业类型代码  ADD BY HYF 20240528
        ,A.STD_PROD_ID                                 AS STD_PROD_ID               --标准产品编号 --ADD BY LIP 20240822
        ,'N'                                           AS HIGH_TECH_PROPERTY_FLG    --投向高技术产业标志  ADD BY YJY 20250605
        ,CASE  --MOD BY YJY 20251104 BEGIN 对分期乐、好企贷-数据贷（微业贷3.0）产品特殊处理
              WHEN A.STD_PROD_ID IN ('202010200011','202010200010','201020100063')  
               AND A.WRT_OFF_FLG = '1'
               AND (TFF.FIR_WRT_OFF_DT = TO_DATE('00010101','YYYYMMDD') OR NVL(TFF.FIR_WRT_OFF_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= V_YEAR_START_DATE)
              THEN 'Y' --分期乐、好企贷-数据贷（微业贷3.0）产品核销过且核销日期大于月初
              WHEN A.STD_PROD_ID IN ('202010200011','202010200010','201020100063') 
               AND A.WRT_OFF_FLG = '1'  
              THEN 'N' --分期乐、好企贷-数据贷（微业贷3.0）产品核销过的且核销日期小于月初的
              WHEN A.STD_PROD_ID IN ('202010200011','202010200010','201020100063')
               AND (A.PAYOFF_DT = TO_DATE('00010101','YYYYMMDD') OR A.PAYOFF_DT >= V_YEAR_START_DATE)     
              THEN 'Y' --分期乐、好企贷-数据贷（微业贷3.0）产品的结清日期为空，或者结清日期大于月初
              WHEN A.STD_PROD_ID IN ('202010200011','202010200010','201020100063')
               AND A.PAYOFF_DT < V_YEAR_START_DATE 
              THEN 'N' --分期乐、好企贷-数据贷（微业贷3.0）产品的结清日期小于月初
               --MOD BY YJY 20251104 END
              WHEN A.STD_PROD_ID IN ('202010100004') AND V_P_DATE > '20240601'
              THEN 'N' --数仓改造，与业务确认20240531之前京东金条的已经全部结清/核销
              WHEN A.STD_PROD_ID IN ('202010100004') AND A.WRT_OFF_FLG = '1' AND TFF.DUBIL_ID IS NULL
              THEN 'N' --MOD BY 20240704 调整京东金条的月标识
              WHEN A.WRT_OFF_FLG = '1' AND (TFF.FIR_WRT_OFF_DT = TO_DATE('00010101','YYYYMMDD')
                OR NVL(TFF.FIR_WRT_OFF_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= V_YEAR_START_DATE - 1)
              THEN 'Y' --核销了且核销日期大于年初
              WHEN A.WRT_OFF_FLG = '1' THEN 'N' --核销了的且核销日期小于年初的
              WHEN A.PAYOFF_DT = TO_DATE('00010101','YYYYMMDD') OR (A.PAYOFF_DT >= V_YEAR_START_DATE - 1
               AND A.STD_PROD_ID NOT IN ('202010100004'))--'202010100004' 京东
              THEN 'Y' --结清日期为空，或者非京东的结清日期大于年初
              WHEN A.PAYOFF_DT < V_YEAR_START_DATE - 1 AND A.STD_PROD_ID NOT IN ('202010100004')
              THEN 'N' --非京东的结清日期小于年初
              WHEN NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0)+ NVL(A.OFF_BS_INT,0)+NVL(A.BAD_DEBT_PRIC,0) > 0
              THEN 'Y' --京东的有余额
              WHEN NVL(A.IN_BS_INT,0) + NVL(A.CURRT_BAL,0)+ NVL(A.OFF_BS_INT,0)+NVL(A.BAD_DEBT_PRIC,0) = 0
               AND ((A.LAST_REPAY_DT = TO_DATE('00010101','YYYYMMDD') AND A.LAST_REPAY_DT >= A.DISTR_DT)
                     OR A.LAST_REPAY_DT >= V_YEAR_START_DATE - 1)
              THEN 'Y'
              ELSE 'N'
          END                                      AS YEAR_FLG                            --年标识     ADD BY CJJ 20251016
         ,NULL                                     AS APRV_EMP_NO                         --审批员工ID ADD BY ZLY 20251017
         ,NVL(T7.LMT_CONT_ID,A.DUBIL_ID)           AS CRDT_LMT_ID_NEW                     --新授信合同编号 --ADD BY LIP 20260129 与授信表中的授信合同取数保持一致
    FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO A --联合网贷借据信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO E --个人客户基本信息
      ON E.CUST_ID = A.CUST_ID
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_LMT_INFO T3 --授信额度信息
      ON TRIM(T3.LMT_RELA_APPL_ID) = TRIM(A.RELA_APPL_FLOW_NUM) --mod by yjy 20250801
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN CMM_UNITE_WL_LMT_INFO_QC T7 --MOD BY LIP 20260129
      ON T7.CUST_ID = A.CUST_ID
     AND T7.BUS_BREED_ID1 = (CASE WHEN A.STD_PROD_ID IN ('202010100004','202010100005') THEN '202010100004' --京东白条
                                  WHEN A.STD_PROD_ID IN ('202010100002','202010100001') THEN '202010100001' --借呗
                                  ELSE A.STD_PROD_ID
                              END)
     AND T7.RN = 1
    LEFT JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_WRT_OFF_INFO TFF --联合网贷核销信息
      ON TFF.DUBIL_ID = A.DUBIL_ID
     AND TFF.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN UNITE_WL_DISTR_DTL DTL
      ON DTL.DUBIL_ID = A.DUBIL_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO T4 --标准产品信息
      ON T4.PROD_ID = /*A.PROD_ID*/ A.STD_PROD_ID
     AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD T5 --公共代码表
      ON T5.CD_VAL=A.LOAN_USAGE_CD
     AND T5.CD_ID ='CD1274'
    LEFT JOIN RRP_MDL.CODE_MAP TA --合同状态转码 CD1278-->D0117
      ON TA.SRC_VALUE_CODE = A.CONT_STATUS_CD
     AND TA.SRC_CLASS_CODE = 'CD1278'
     AND TA.TAR_CLASS_CODE = 'D0117'
     AND TA.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TB --担保方式1转码 CD1518-->D0037
      ON TB.SRC_VALUE_CODE = A.GUAR_WAY_CD
     AND TB.SRC_CLASS_CODE = 'CD2656'
     AND TB.TAR_CLASS_CODE = 'D0002'
     AND TB.MOD_FLG = 'MDM'
    /*LEFT JOIN ADD_LOAN_NET_COOP_SUB_TMP C
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
     AND FF.COOP_PROD2 IS NOT NULL*/
    LEFT JOIN RRP_MDL.CODE_MAP D --码值映射表(贷款类型) --MODIFY BY XIEYUGENG 20221021
      ON D.SRC_VALUE_CODE = A.STD_PROD_ID
     AND D.SRC_CLASS_CODE = 'STD0002'
     AND D.TAR_CLASS_CODE = 'T0001'
     AND D.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.M_DICT_G19_REMAPPING G --G19行业映射关系表
      ON G.CODE = A.DIR_INDUS_CD
     AND G.TYPE_CODE = 'G1901' --文化及相关产业
    LEFT JOIN WSD_COOP_AGRT_ID T6 --ADD BY LIP 20250731 网商贷保证方式的互联网合作协议
      ON T6.DUBIL_ID = A.DUBIL_ID
     AND T6.RN = 1
    LEFT JOIN ADD_LOAN_NET_COOP_SUB H --MOD BY LIP 20251111 根据信贷登记的互联网合作协议编号调整映射
      ON H.PRODUCTID = A.STD_PROD_ID
   WHERE A.DUBIL_STATUS_CD NOT IN ('2','5') --失败、撤销
     AND A.STD_PROD_ID NOT IN ( '203050100001','203050100002' )--MOD BY YJY 20250219 剔除产品微业贷的数据 --MOD BY YJY 20251120 新增203050100002-微众对公联合贷
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '贷款合同信息--汇总';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_LOAN_CONT_INFO
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
    ,INTEL_PROP_INTE_PROPERTY_TYPE_CD --是否投向知识产权密集型产业
    ,CUL_PROPERTY_FLG                 --文化产业标志
    ,STRATE_NEW_INDUS_TYPE_CD         --战略性新兴产业类型代码
     ,HIGH_NEW_TECH_CORP_FLG          --高新技术企业标志
    ,SCI_TECH_CORP_FLG                --科技型企业标志
    ,SCI_TECH_INOVT_CORP_FLG          --科创企业标志
    ,SPE_SOPH_UNQ_NEW_MED_SIDE_ENTER_FLG --专精特新中小企业标志
    ,SPE_SOPH_UNQ_NEW_LTE_GNT_CORP_FLG   --专精特新小巨人企业标志
    ,CONT_TYPE_CD                        --合同类型代码
    ,STD_PROD_ID                         --标准产品编号
    ,GREEN_CONSM_SUB_TYPE_CD             --绿色消费子类代码
    ,ACP_DISTR_AMT                       --花呗放款金额 --ADD BY 20240103
    ,INDU_CORP_TECH_REM_UGD_FLG          --工业企业技术改造升级标志   ADD BY YJY 20240507
    ,SEED_LOAN_FLG                       --种业振兴贷款标志           ADD BY YJY 20240507
    ,COUNTY_LOAN_FLG                     --县城区贷款标志             ADD BY YJY 20240507
    ,PROVI_FOR_AGED_PROPERTY_FLG         --养老产业标志               ADD BY YJY 20240507
    ,PPP_PROJ_FLG                        --投向政府和社会资本合作项目标志  ADD BY YJY 20240507
    ,NEW_DISTR_FLG                       --新机制发放贷款标志         ADD BY YJY 20240507
    ,PROP_PROPERTY_TYPE_CD               --知识产权产业类型代码       ADD BY HYF 20240528
    ,CUL_AND_RELA_PPTY_TYPE_CD           --文化及相关产业类型代码     ADD BY HYF 20240528
    ,RELA_PEOP_GUAR_LOAN_FLG             --关系人保证贷款标志         ADD BY HYF 20241023
    ,HIGH_TECH_PROPERTY_FLG              --投向高技术产业标志         ADD BY YJY 20250605
    ,BUID_BUS_GUAR_LOAN_FLG              --创业担保贷款标志           ADD BY LAL 20250829
    ,CUST_INS_ADJ_TYPE_CD                --客户产业结构调整类型代码   ADD BY PSF 20250912
    ,YEAR_FLG                            --年标识                   ADD BY CJJ 20251016
    ,APRV_EMP_NO                         --审批员工ID               ADD BY ZLY 20251017
    ,HIGH_TECH_SERV_LOAN_FLG             --高技术服务业贷款标志     ADD BY YJY 20240829 
    ,HIGH_TECH_SERV_LOAN_TYPE_CD         --高技术服务业贷款类型代码   ADD BY YJY 20240829
    ,CRDT_LMT_ID_NEW                     --新授信合同编号 --ADD BY LIP 20260129
     )
    WITH TMP1 AS (
  SELECT TLR_NO AS TELLER_ID,EMP_ID AS CLERK_ID,TO_DATE(UPDATE_DT,'YYYYMMDD') AS DIMISSION_DT FROM RRP_MDL.ADD_EMP_TLR
   UNION ALL
  SELECT TELLER_ID,CLERK_ID,DIMISSION_DT FROM RRP_MDL.O_ICL_CMM_CLERK_INFO
   WHERE TRIM(TELLER_ID) IS NOT NULL AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')),
   CMM_CLERK_INFO AS (
  SELECT TC.TELLER_ID,TC.CLERK_ID,
         ROW_NUMBER() OVER(PARTITION BY TC.TELLER_ID ORDER BY TC.DIMISSION_DT DESC) RN
    FROM TMP1 TC)
  SELECT DISTINCT
         T.DATA_DT                                         AS DATA_DT                          --数据日期
        ,T.LGL_REP_ID                                      AS LGL_REP_ID                       --法人编号
        ,T.CONT_ID                                         AS CONT_ID                          --合同编号
        ,T.CONT_NM                                         AS CONT_NM                          --合同名称
        ,T.PRIM_CONT_ID                                    AS PRIM_CONT_ID                     --主合同号
        ,T.CUST_ID                                         AS CUST_ID                          --客户编号
        ,T.ORG_ID                                          AS ORG_ID                           --机构编号
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
        ,TRIM(T.CUST_MGR_NO)                               AS CUST_MGR_NO                      --客户经理工号  --MODIFY BY MW 20221123 新一代柜员号和行员号是一致的
        ,TRIM(REPLACE(REPLACE(T.LOAN_USEAGE,CHR(10),''),CHR(13),'')) AS LOAN_USEAGE            --贷款用途 --MOD BY LIP 20230616
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
        ,T.INTEL_PROP_INTE_PROPERTY_TYPE_CD                AS INTEL_PROP_INTE_PROPERTY_TYPE_CD --是否投向知识产权密集型产业
        ,T.CUL_PROPERTY_FLG                                AS CUL_PROPERTY_FLG                 --文化产业标志
        ,T.STRATE_NEW_INDUS_TYPE_CD                        AS STRATE_NEW_INDUS_TYPE_CD         --战略性新兴产业类型代码
        ,T.HIGH_NEW_TECH_CORP_FLG                          AS HIGH_NEW_TECH_CORP_FLG           --高新技术企业标志
        ,T.SCI_TECH_CORP_FLG                               AS SCI_TECH_CORP_FLG                --科技型企业标志
        ,T.SCI_TECH_INOVT_CORP_FLG                         AS SCI_TECH_INOVT_CORP_FLG          --科创企业标志
        ,T.SPE_SOPH_UNQ_NEW_MED_SIDE_ENTER_FLG             AS SPE_SOPH_UNQ_NEW_MED_SIDE_ENTER_FLG--专精特新中小企业标志
        ,T.SPE_SOPH_UNQ_NEW_LTE_GNT_CORP_FLG               AS SPE_SOPH_UNQ_NEW_LTE_GNT_CORP_FLG  --专精特新小巨人企业标志
        ,T.CONT_TYPE_CD                                    AS CONT_TYPE_CD
        ,T.STD_PROD_ID                                     AS STD_PROD_ID                      --标准产品编号
        ,T.GREEN_CONSM_SUB_TYPE_CD                         AS GREEN_CONSM_SUB_TYPE_CD          --绿色消费子类代码
        ,T.ACP_DISTR_AMT                                   AS ACP_DISTR_AMT                    --花呗放款金额 --ADD BY 20240103
        ,T.INDU_CORP_TECH_REM_UGD_FLG                      AS INDU_CORP_TECH_REM_UGD_FLG       --工业企业技术改造升级标志   add by yjy 20240507
        ,T.SEED_LOAN_FLG                                   AS SEED_LOAN_FLG                    --种业振兴贷款标志           add by yjy 20240507
        ,T.COUNTY_LOAN_FLG                                 AS COUNTY_LOAN_FLG                  --县城区贷款标志             add by yjy 20240507
        ,T.PROVI_FOR_AGED_PROPERTY_FLG                     AS PROVI_FOR_AGED_PROPERTY_FLG      --养老产业标志               add by yjy 20240507
        ,T.PPP_PROJ_FLG                                    AS PPP_PROJ_FLG                     --投向政府和社会资本合作项目标志  add by yjy 20240507
        ,T.NEW_DISTR_FLG                                   AS NEW_DISTR_FLG                    --新机制发放贷款标志         add by yjy 20240507
        ,T.PROP_PROPERTY_TYPE_CD                           AS PROP_PROPERTY_TYPE_CD            --知识产权产业类型代码       add by HYF 20240528
        ,T.CUL_AND_RELA_PPTY_TYPE_CD                       AS CUL_AND_RELA_PPTY_TYPE_CD        --文化及相关产业类型代码     add by HYF 20240528
        ,T.RELA_PEOP_GUAR_LOAN_FLG                         AS RELA_PEOP_GUAR_LOAN_FLG          --关系人保证贷款标志
        ,T.HIGH_TECH_PROPERTY_FLG                          AS HIGH_TECH_PROPERTY_FLG           --投向高技术产业标志         ADD BY YJY 20250605
        ,T.BUID_BUS_GUAR_LOAN_FLG                          AS BUID_BUS_GUAR_LOAN_FLG           --创业担保贷款标志           ADD BY LAL 20250829
        ,T.CUST_INS_ADJ_TYPE_CD                            AS CUST_INS_ADJ_TYPE_CD             --客户产业结构调整类型代码   ADD BY PSF 20250912
        ,T.YEAR_FLG                                        AS YEAR_FLG                         --年标识                  ADD BY CJJ 20251016
        ,T.APRV_EMP_NO                                     AS APRV_EMP_NO                      --审批员工ID               ADD BY ZLY 20251017
        ,T.HIGH_TECH_SERV_LOAN_FLG                         AS HIGH_TECH_SERV_LOAN_FLG          --高技术服务业贷款标志     ADD BY YJY 20240829 
        ,T.HIGH_TECH_SERV_LOAN_TYPE_CD                     AS HIGH_TECH_SERV_LOAN_TYPE_CD      --高技术服务业贷款类型代码   ADD BY YJY 20240829
        ,T.CRDT_LMT_ID_NEW                                 AS CRDT_LMT_ID_NEW                  --新授信合同编号 --ADD BY LIP 20260129
   FROM RRP_MDL.M_LOAN_CONT_INFO_TEMP02 T
   LEFT JOIN CMM_CLERK_INFO C --行员信息
     ON C.TELLER_ID = TRIM(T.CUST_MGR_NO)
    AND C.RN = 1
  WHERE NVL(T.CONT_START_DT,V_P_DATE) <= V_P_DATE; --过滤开始时间大于采集日期的数据

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

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
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  IF V_SQLCOUNT > 0 THEN
    O_ERRCODE := '1';
    V_SQLMSG  := '数据重复';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
    RETURN;
  END IF;

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE); --表分析
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

--程序异常处理部分
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_LOAN_CONT_INFO;
/

