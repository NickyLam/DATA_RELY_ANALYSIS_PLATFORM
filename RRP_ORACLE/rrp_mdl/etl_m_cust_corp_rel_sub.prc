CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_CUST_CORP_REL_SUB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_CUST_CORP_REL_SUB
  *  功能描述：监管集市对公客户的关联方相关信息，包括但不仅限于股东、上下游关系、共同出资组建企业关系、亲属关系、担保关系、
  *             实际控制人、共同受同一自然人控制、集团成员、法定代表人、董事长（理事长）、监事长、总经理、财务主管、个人股东等关联关系。
  *  创建日期：20220608
  *  开发人员：HULIJUAN
  *  来源表：  ICL.CMM_CORP_CUST_BASIC_INFO    --对公客户信息表
  *            ICL.CMM_CORP_CUST_RELA_PS_INFO  --对公关联人
  *            ICL.CMM_GUAR_CONT               --担保合同
  *            ICL.CMM_LOAN_GUAR_CONT_RELA     --贷款合同与担保合同关系
  *            ICL.CMM_CORP_LOAN_CONT_INFO C   --对公贷款合同信息
  *            ICL.CMM_CORP_CUST_BASIC_INFO    --对公客户基础信息
  *            ICL.CMM_INTNAL_ORG_INFO         --内部机构信息表
  *
  *  目标表：  M_CUST_CORP_REL_SUB --对公客户关联人子表
  *
  *  配置表：  CODE_MAP --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220507  程序员   首次创建
  *             2    20221022  HULJ     调整关联人类型取值
  *             3    20221107  HULJ     增加数据重复校验
  *             4    20221129  XUCX     增加字段取数仓的关联人证件类型
  *             5    20230116  HULJ     新增字段ECIF客户号
  *             6    20240419  YJY      调整'插入对公客户关联人子表:逻辑1-ECIF系统数据信息'，去掉排序
  *             7    20240617  YJY      补充'插入对公客户关联人子表:逻辑1-ECIF系统数据信息'，更新信息日期
  *             8    20240701  YJY      对更新信息日期字段进行日期转换
  *             9    20241129  YJY      调整‘逻辑1-ECIF系统数据信息’，关联人类型中其他公司方自然人类型添加个人证件判断
  *             10   20260302  LIP      REL_PSN_CUST_ID字段，因信贷没有关联人客户编号字段,为空时取关联人编号
  *             11   20260409  LIP      对公客户录入了财务负责人名称，但是没有录入证件信息，补充该部分数据明细
  ***********************************************************************/
AS
  --定义变量
  V_STEP_DESC VARCHAR2(100);                              --处理步骤描述
  V_P_DATE    VARCHAR2(8);                                --跑批数据日期
  V_STARTTIME DATE;                                       --处理开始时间
  V_ENDTIME   DATE;                                       --处理结束时间
  V_SQLMSG    VARCHAR2(300);                              --SQL执行描述信息
  V_PART_NAME VARCHAR2(50);                               --表分区名字
  V_STEP      INTEGER := 0;                               --处理步骤
  V_SQLCOUNT  INTEGER := 0;                               --更新或删除影响的记录数
  V_TAB_NAME  VARCHAR2(50) := 'M_CUST_CORP_REL_SUB';      --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_CUST_CORP_REL_SUB'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送';                 --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR( I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  --支持重跑
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批开始';
  V_STARTTIME := SYSDATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
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
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入对公客户关联人子表:逻辑1-ECIF系统数据信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CUST_CORP_REL_SUB
    (DATA_DT               --数据日期
    ,LGL_REP_ID            --法人编号
    ,CUST_ID               --客户编号
    ,REL_TYP               --关系类型
    ,REL_PSN_TYP           --关联人类型
    ,REL_PSN_CUST_NM       --关联人客户名称
    ,REL_PSN_CUST_ID       --关联人客户编号
    ,REL_PSN_CTRY_CD       --关联人国家代码
    ,REL_PSN_CRDL_TYP      --关联人证件类型
    ,REL_PSN_CRDL_NO       --关联人证件号码
    ,PBC_NO                --人行支付行号
    ,FIN_PERMIT_NO         --金融许可证号
    ,ACT_CNTLR_FLG         --实际控制人标志
    ,ACT_CNTLR_TYP         --实际控制人类型
    ,REGD_CD_RSK           --登记注册代码（客户风险）
    ,UPD_INFO_DT           --更新信息日期
    ,SENIOR_IMPT_PSN_FLG   --高管及重要联系人标志
    ,REL_STAT              --关联关系状态
    ,PP1_NO                --护照1号码
    ,PP1_ISU_DT            --护照1签发日期
    ,PP1_EXP_DT            --护照1到期日期
    ,PP2_NO                --护照2号码
    ,PP2_ISU_DT            --护照2签发日期
    ,PP2_EXP_DT            --护照2到期日期
    ,PP3_NO                --护照3号码
    ,PP3_ISU_DT            --护照3签发日期
    ,PP3_EXP_DT            --护照3到期日期
    ,OTH_CRDL_TYP1         --其他证件类型1
    ,OTH_CRDL_NO1          --其他证件号码1
    ,OTH_CRDL_TYP2         --其他证件类型2
    ,OTH_CRDL_NO2          --其他证件号码2
    ,DEPT_LINE             --部门条线
    ,DATA_SRC              --数据来源
    ,REL_PSN_TYP_ORIG      --原始关联人类型
    ,HOLD_TYPE_CD          --持股类型代码
    ,DEPOSITR_CATE_CD      --存款人类型代码
    ,RELA_PS_CERT_TYPE_CD  --数仓关联人证件类型 ADD BY 20221129 XUCX
    ,ECIF_CUST_ID          --ECIF客户号
    )
    WITH TMP1 AS (
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')                          AS DATA_DT               --数据日期
        ,A.LP_ID                                               AS LGL_REP_ID            --法人编号
        ,A.CUST_ID                                             AS CUST_ID               --客户编号
        ,NVL(B.TAR_VALUE_CODE,'99')                            AS REL_TYP               --关系类型 --modify by hulj20221022
        ,CASE WHEN A.RELA_TYPE_CD = '30101' THEN '01' --法定代表人
              WHEN A.RELA_TYPE_CD = '30102' THEN '02' --董事长
              WHEN A.RELA_TYPE_CD = '30103' THEN '03' --监事长
              WHEN A.RELA_TYPE_CD = '30104' THEN '04' --总经理
              WHEN A.RELA_TYPE_CD = '30105' THEN '05' --财务主管
              WHEN A.RELA_TYPE_CD IN ('30111','40100') AND SUBSTR(A.RELA_PS_CERT_TYPE_CD,1,1) = '1' THEN '06' --个人股东
              WHEN A.RELA_TYPE_CD IN ('30200','30201','30202','30203','30204','30205') THEN '011' --公司法人代表的其他关系  --ADD BY LHQ AT 20220316 增加新的码值映射
              /*30200公司法人代表亲属关系/30201公司法人代表的配偶/30202公司法人代表的父母/30203公司法人代表的子女/30204公司法人代表的其他血亲/30205公司法人代表的其他姻亲*/
              WHEN A.RELA_TYPE_CD IN ('30100','30106','30107','30108','30109','30110','40301','40302','40303')
              --mod by yjy 20241129 EAST需求：加个证件类型是个人的判断
                AND SUBSTR(A.RELA_PS_CERT_TYPE_CD,1,1) = '1' THEN '012' --其他公司方自然人类型   --add by LHQ at 20220316 增加新的码值映射
              WHEN C.HOLD_TYPE_CD LIKE 'A01%' THEN '07'               --国有企业
              WHEN C.HOLD_TYPE_CD LIKE 'B01%' THEN '08'               --民营企业
              WHEN C.NATNAL_ECON_DEPT_TYPE_CD LIKE 'A%' THEN '09'     --政府机关
              WHEN C.DEPOSITR_CATE_CD IN ('04','05') THEN '10'        --事业单位
              WHEN C.DEPOSITR_CATE_CD IN ('08') THEN '11'             --社会团体
              WHEN C.NATNAL_ECON_DEPT_TYPE_CD LIKE 'E%' THEN '12'     --境外机构
              ELSE '99'                                               --其他
          END                                                  AS REL_PSN_TYP           --关联人类型
        ,A.RELA_PS_NAME                                        AS REL_PSN_CUST_NM       --关联人客户名称
        --,A.RELA_PS_CUST_ID                                     AS REL_PSN_CUST_ID       --关联人客户编号
        ,NVL(TRIM(A.RELA_PS_CUST_ID),TRIM(A.RELA_PS_ID))       AS REL_PSN_CUST_ID       --关联人客户编号 --MOD BY LIP 20260302 关联人客户编号为空时，用关联人编号兜底
        ,A.RELA_PS_NATION_CD                                   AS REL_PSN_CTRY_CD       --关联人国家代码
        ,A.RELA_PS_CERT_TYPE_CD                                AS REL_PSN_CRDL_TYP      --关联人证件类型
        --,A.RELA_PS_CERT_NO                                     AS REL_PSN_CRDL_NO       --关联人证件号码
        ,TRIM(A.RELA_PS_CERT_NO)                               AS REL_PSN_CRDL_NO       --关联人证件号码 --MOD BY LIP 20260409
        ,C.PBC_PAY_BANK_NO                                     AS PBC_NO                --人行支付行号
        ,C.FIN_LICS_NUM                                        AS FIN_PERMIT_NO         --金融许可证号
        ,CASE WHEN A.RELA_TYPE_CD IN ('30110' ,'30111') THEN 'Y'
              ELSE 'N'
          END                                                  AS ACT_CNTLR_FLG         --实际控制人标志
        ,CASE WHEN A.RELA_TYPE_CD IN ('30110' ,'30111') 
              THEN CASE WHEN SUBSTR(A.RELA_PS_CERT_TYPE_CD,1,1) = '1' AND A.RELA_PS_NATION_CD IN ('CHN','XXX') THEN '01' --自然人（中国公民）
                        WHEN SUBSTR(A.RELA_PS_CERT_TYPE_CD,1,1) = '1' AND A.RELA_PS_NATION_CD NOT IN ('CHN','XXX') THEN '02' --自然人（非中国公民）
                        WHEN C.NATNAL_ECON_DEPT_TYPE_CD LIKE 'C%' THEN '03' --境内非金融机构
                        WHEN C.NATNAL_ECON_DEPT_TYPE_CD IN ('B03','B04') THEN '04' --境内银行业金融机构
                        WHEN C.NATNAL_ECON_DEPT_TYPE_CD LIKE 'B%' AND C.NATNAL_ECON_DEPT_TYPE_CD NOT IN ('B03','B04') THEN '05' --境内非银行金融机构
                        WHEN C.NATNAL_ECON_DEPT_TYPE_CD = 'E03' THEN '06'   --境外银行
                        WHEN SUBSTR(C.HOLD_TYPE_CD,1,2) = 'A01' THEN '09'   --国有控股企业
                        WHEN SUBSTR(C.HOLD_TYPE_CD,1,2) = 'A02' THEN '10'   --国有参股企业
                        WHEN SUBSTR(C.HOLD_TYPE_CD,1,2) = 'B01' THEN '11'   --民营企业
                        WHEN C.NATNAL_ECON_DEPT_TYPE_CD LIKE 'A%' THEN '12' --政府机关
                        WHEN C.DEPOSITR_CATE_CD IN ('04','05') THEN '13'    --事业单位
                        WHEN C.DEPOSITR_CATE_CD IN ('08') THEN '14'         --社会团体
                        WHEN SUBSTR(C.HOLD_TYPE_CD,1,2) = 'E02' THEN '15'   --中外合资企业
                        WHEN SUBSTR(C.HOLD_TYPE_CD,1,2) = 'E01' THEN '16'   --外商独资企业
                        WHEN C.NATNAL_ECON_DEPT_TYPE_CD = 'E04' THEN '17'   --境外机构
                        ELSE '99'  --其他
                   END
              ELSE NULL
          END                                                  AS ACT_CNTLR_TYP         --实际控制人类型
        ,C.RGSTION_CD                                          AS REGD_CD_RSK           --登记注册代码（客户风险）
        ,TO_CHAR(A.RELA_PS_LATEST_UPDATE_TM,'YYYYMMDD')        AS UPD_INFO_DT           --更新信息日期   --MOD IN 20240701
        ,CASE WHEN A.RELA_PS_SENIOR_MAN_FLG = '1' 
              THEN 'Y'
              ELSE 'N'
          END                                                  AS SENIOR_IMPT_PSN_FLG   --高管及重要联系人标志
        ,'Y'                                                   AS REL_STAT              --关联关系状态
        ,NULL                                                  AS PP1_NO                --护照1号码
        ,NULL                                                  AS PP1_ISU_DT            --护照1签发日期
        ,NULL                                                  AS PP1_EXP_DT            --护照1到期日期
        ,NULL                                                  AS PP2_NO                --护照2号码
        ,NULL                                                  AS PP2_ISU_DT            --护照2签发日期
        ,NULL                                                  AS PP2_EXP_DT            --护照2到期日期
        ,NULL                                                  AS PP3_NO                --护照3号码
        ,NULL                                                  AS PP3_ISU_DT            --护照3签发日期
        ,NULL                                                  AS PP3_EXP_DT            --护照3到期日期
        ,NULL                                                  AS OTH_CRDL_TYP1         --其他证件类型1
        ,NULL                                                  AS OTH_CRDL_NO1          --其他证件号码1
        ,NULL                                                  AS OTH_CRDL_TYP2         --其他证件类型2
        ,NULL                                                  AS OTH_CRDL_NO2          --其他证件号码2
        ,'800926'                                              AS DEPT_LINE             --部门条线 /*公司银行总部*/
        ,SUBSTR(A.JOB_CD,0,4)                                  AS DATA_SRC              --数据来源 
        ,A.RELA_TYPE_CD                                        AS REL_PSN_TYP_ORIG      --原始关联人类型代码
        ,C.HOLD_TYPE_CD                                        AS HOLD_TYPE_CD          --控股类型代码
        ,C.DEPOSITR_CATE_CD                                    AS DEPOSITR_CATE_CD      --存款类型代码
        ,A.RELA_PS_CERT_TYPE_CD                                AS RELA_PS_CERT_TYPE_CD  --数仓关联人证件类型 ADD BY 20221129 XUCX
        ,C.CUST_ID                                             AS ECIF_CUST_ID          --ECIF客户号  ADD BY HULJ 20230116
        ,ROW_NUMBER() OVER(PARTITION BY A.CUST_ID,B.TAR_VALUE_CODE,TRIM(A.RELA_PS_CERT_NO) ORDER BY A.JOB_CD) AS NUM  --MODIFY BY YJY IN 20240419 
    FROM RRP_MDL.O_ICL_CMM_CORP_CUST_RELA_PS_INFO A --对公关联人
    LEFT JOIN RRP_MDL.CODE_MAP B
      ON B.SRC_VALUE_CODE = A.RELA_TYPE_CD
     AND B.SRC_CLASS_CODE = 'CD1280' --当事人关系类型代码
     AND B.TAR_CLASS_CODE IN ('C0017','C0058') --对公关系类型
     AND B.MOD_FLG = 'MDM' --监管集市明细层
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO C  --对公客户信息表
      ON A.RELA_PS_CERT_NO = CASE WHEN C.SOCI_CRDT_CD IS NOT NULL THEN C.SOCI_CRDT_CD
                                  WHEN C.ORGNZ_CD IS NOT NULL THEN C.ORGNZ_CD
                                  WHEN C.BUS_LICS_NUM IS NOT NULL THEN C.BUS_LICS_NUM
                                  WHEN C.RGSTION_CD IS NOT NULL THEN C.RGSTION_CD
                                  WHEN C.NATION_TAX_RGST_CERT_NUM IS NOT NULL THEN C.NATION_TAX_RGST_CERT_NUM
                                  WHEN C.LOCAL_TAX_RGST_CERT_NUM IS  NOT NULL THEN C.LOCAL_TAX_RGST_CERT_NUM
                                  WHEN C.FIN_LICS_NUM IS NOT NULL THEN C.FIN_LICS_NUM
                                  WHEN C.PBC_PAY_BANK_NO IS  NOT NULL THEN C.PBC_PAY_BANK_NO
                              END
     AND TRIM(A.RELA_PS_CERT_NO) IS NOT NULL --MOD BY LIP 20260409
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   /*WHERE TRIM(A.CUST_ID) IS NOT NULL
     AND TRIM(A.RELA_PS_CERT_NO) IS NOT NULL
     AND TRIM(A.RELA_PS_NAME) IS NOT NULL*/
   WHERE TRIM(A.CUST_ID) IS NOT NULL
     AND ((TRIM(A.RELA_PS_CERT_NO) IS NOT NULL AND TRIM(A.RELA_PS_NAME) IS NOT NULL)
          OR A.RELA_TYPE_CD IN ('30105')) --MOD BY LIP 20260409 客户录入了财务负责人名称，但是没有录入证件信息
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT T.DATA_DT               --数据日期
        ,T.LGL_REP_ID            --法人编号
        ,T.CUST_ID               --客户编号
        ,T.REL_TYP               --关系类型
        ,T.REL_PSN_TYP           --关联人类型
        ,T.REL_PSN_CUST_NM       --关联人客户名称
        ,T.REL_PSN_CUST_ID       --关联人客户编号
        ,T.REL_PSN_CTRY_CD       --关联人国家代码
        ,T.REL_PSN_CRDL_TYP      --关联人证件类型
        ,T.REL_PSN_CRDL_NO       --关联人证件号码
        ,T.PBC_NO                --人行支付行号
        ,T.FIN_PERMIT_NO         --金融许可证号
        ,T.ACT_CNTLR_FLG         --实际控制人标志
        ,T.ACT_CNTLR_TYP         --实际控制人类型
        ,T.REGD_CD_RSK           --登记注册代码（客户风险）
        ,T.UPD_INFO_DT           --更新信息日期
        ,T.SENIOR_IMPT_PSN_FLG   --高管及重要联系人标志
        ,T.REL_STAT              --关联关系状态
        ,T.PP1_NO                --护照1号码
        ,T.PP1_ISU_DT            --护照1签发日期
        ,T.PP1_EXP_DT            --护照1到期日期
        ,T.PP2_NO                --护照2号码
        ,T.PP2_ISU_DT            --护照2签发日期
        ,T.PP2_EXP_DT            --护照2到期日期
        ,T.PP3_NO                --护照3号码
        ,T.PP3_ISU_DT            --护照3签发日期
        ,T.PP3_EXP_DT            --护照3到期日期
        ,T.OTH_CRDL_TYP1         --其他证件类型1
        ,T.OTH_CRDL_NO1          --其他证件号码1
        ,T.OTH_CRDL_TYP2         --其他证件类型2
        ,T.OTH_CRDL_NO2          --其他证件号码2
        ,T.DEPT_LINE             --部门条线
        ,T.DATA_SRC              --数据来源
        ,T.REL_PSN_TYP_ORIG      --原始关联人类型代码
        ,T.HOLD_TYPE_CD          --持股类型代码
        ,T.DEPOSITR_CATE_CD      --存款人类型代码
        ,T.RELA_PS_CERT_TYPE_CD  --数仓关联人证件类型 ADD BY 20221129 XUCX
        ,T.ECIF_CUST_ID          --ECIF客户号
    FROM TMP1 T
   WHERE T.NUM = 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
    
  --程序业务逻辑处理主体部分
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入对公客户关联人子表:逻辑2-信贷系统-担保关系数据信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CUST_CORP_REL_SUB
    (DATA_DT               --数据日期
    ,LGL_REP_ID            --法人编号
    ,CUST_ID               --客户编号
    ,REL_TYP               --关系类型
    ,REL_PSN_TYP           --关联人类型
    ,REL_PSN_CUST_NM       --关联人客户名称
    ,REL_PSN_CUST_ID       --关联人客户编号
    ,REL_PSN_CTRY_CD       --关联人国家代码
    ,REL_PSN_CRDL_TYP      --关联人证件类型
    ,REL_PSN_CRDL_NO       --关联人证件号码
    ,PBC_NO                --人行支付行号
    ,FIN_PERMIT_NO         --金融许可证号
    ,ACT_CNTLR_FLG         --实际控制人标志
    ,ACT_CNTLR_TYP         --实际控制人类型
    ,REGD_CD_RSK           --登记注册代码（客户风险）
    ,UPD_INFO_DT           --更新信息日期
    ,SENIOR_IMPT_PSN_FLG   --高管及重要联系人标志
    ,REL_STAT              --关联关系状态
    ,PP1_NO                --护照1号码
    ,PP1_ISU_DT            --护照1签发日期
    ,PP1_EXP_DT            --护照1到期日期
    ,PP2_NO                --护照2号码
    ,PP2_ISU_DT            --护照2签发日期
    ,PP2_EXP_DT            --护照2到期日期
    ,PP3_NO                --护照3号码
    ,PP3_ISU_DT            --护照3签发日期
    ,PP3_EXP_DT            --护照3到期日期
    ,OTH_CRDL_TYP1         --其他证件类型1
    ,OTH_CRDL_NO1          --其他证件号码1
    ,OTH_CRDL_TYP2         --其他证件类型2
    ,OTH_CRDL_NO2          --其他证件号码2
    ,DEPT_LINE             --部门条线
    ,DATA_SRC              --数据来源
    ,REL_PSN_TYP_ORIG      --原始关联人类型
    ,HOLD_TYPE_CD          --持股类型代码
    ,DEPOSITR_CATE_CD      --存款人类型代码
    )
    WITH TMP1 AS (
  SELECT V_P_DATE                       AS DATA_DT               --数据日期
        ,A.LP_ID                        AS LGL_REP_ID            --法人编号
        ,C.CUST_ID                      AS CUST_ID               --客户编号
        ,'10'                           AS REL_TYP               --关系类型
        ,CASE WHEN D.CUST_TYPE_CD = '37' THEN '06'
              WHEN D.HOLD_TYPE_CD LIKE 'A01%' THEN '07'
              WHEN D.HOLD_TYPE_CD LIKE 'B01%' THEN '08'
              WHEN D.NATNAL_ECON_DEPT_TYPE_CD LIKE 'A%' THEN '09'
              WHEN D.DEPOSITR_CATE_CD IN ('04','05') THEN '10'
              WHEN D.DEPOSITR_CATE_CD IN ('08') THEN '11'
              WHEN D.NATNAL_ECON_DEPT_TYPE_CD LIKE 'E%' THEN '12'
              ELSE '99'
          END                           AS REL_PSN_TYP           --关联人类型
        ,A.GUARTOR_NAME                 AS REL_PSN_CUST_NM       --关联人客户名称
        ,A.GUARTOR_ID                   AS REL_PSN_CUST_ID       --关联人客户编号
        ,NULL                           AS REL_PSN_CTRY_CD       --关联人国家代码
        ,A.GUARTOR_CERT_TYPE_CD         AS REL_PSN_CRDL_TYP      --关联人证件类型 --不转码，取数仓原值
        ,A.GUARTOR_CERT_NO              AS REL_PSN_CRDL_NO       --关联人证件号码
        ,F.PBC_PAY_BANK_NO              AS PBC_NO                --人行支付行号
        ,F.FIN_LICS_NUM                 AS FIN_PERMIT_NO         --金融许可证号
        ,NULL                           AS ACT_CNTLR_FLG         --实际控制人标志
        ,NULL                           AS ACT_CNTLR_TYP         --实际控制人类型
        ,D.RGSTION_CD                   AS REGD_CD_RSK           --登记注册代码（客户风险）
        ,NULL                           AS UPD_INFO_DT           --更新信息日期
        ,NULL                           AS SENIOR_IMPT_PSN_FLG   --高管及重要联系人标志
        ,'Y'                            AS REL_STAT              --关联关系状态
        ,NULL                           AS PP1_NO                --护照1号码
        ,NULL                           AS PP1_ISU_DT            --护照1签发日期
        ,NULL                           AS PP1_EXP_DT            --护照1到期日期
        ,NULL                           AS PP2_NO                --护照2号码
        ,NULL                           AS PP2_ISU_DT            --护照2签发日期
        ,NULL                           AS PP2_EXP_DT            --护照2到期日期
        ,NULL                           AS PP3_NO                --护照3号码
        ,NULL                           AS PP3_ISU_DT            --护照3签发日期
        ,NULL                           AS PP3_EXP_DT            --护照3到期日期
        ,NULL                           AS OTH_CRDL_TYP1         --其他证件类型1
        ,NULL                           AS OTH_CRDL_NO1          --其他证件号码1
        ,NULL                           AS OTH_CRDL_TYP2         --其他证件类型2
        ,NULL                           AS OTH_CRDL_NO2          --其他证件号码2
        ,'04'                           AS DEPT_LINE             --部门条线
        ,SUBSTR(A.JOB_CD,0,4)           AS DATA_SRC              --数据来源
        ,D.DEPOSITR_CATE_CD             AS REL_PSN_TYP_ORIG      --原始关联人类型代码
        ,D.HOLD_TYPE_CD                 AS HOLD_TYPE_CD          --持股类型代码
        ,D.DEPOSITR_CATE_CD             AS DEPOSITR_CATE_CD      --存款人类型代码
        ,ROW_NUMBER() OVER(PARTITION BY V_P_DATE,C.CUST_ID,'10',A.GUARTOR_CERT_NO,
                                        CASE WHEN D.CUST_TYPE_CD = '37' THEN '06'
                                             WHEN D.HOLD_TYPE_CD LIKE 'A01%' THEN '07'
                                             WHEN D.HOLD_TYPE_CD LIKE 'B01%' THEN '08'
                                             WHEN D.NATNAL_ECON_DEPT_TYPE_CD LIKE 'A%' THEN '09'
                                             WHEN D.DEPOSITR_CATE_CD IN ('04','05') THEN '10'
                                             WHEN D.DEPOSITR_CATE_CD IN ('08') THEN '11'
                                             WHEN D.NATNAL_ECON_DEPT_TYPE_CD LIKE 'E%' THEN '12'
                                             ELSE '99'
                                         END ORDER BY LENGTH(A.GUARTOR_ID)) AS RN
    FROM RRP_MDL.O_ICL_CMM_GUAR_CONT A  --担保合同
    LEFT JOIN RRP_MDL.O_ICL_CMM_LOAN_GUAR_CONT_RELA B --贷款合同与担保合同关系
      ON B.GUAR_CONT_ID = A.GUAR_CONT_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')/*A.ETL_DT*/
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO C --对公贷款合同信息
      ON C.CONT_ID = B.LOAN_CONT_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO D --对公客户基础信息
      ON D.CUST_ID = A.GUARTOR_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO E --对公客户基础信息
      ON E.CUST_ID = C.CUST_ID
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO F --内部机构信息表
      ON F.ORG_ID = E.BELONG_ORG_ID
     AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE TRIM(C.CUST_ID) IS NOT NULL
     AND TRIM(A.GUARTOR_CERT_NO) IS NOT NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT  DATA_DT               --数据日期
         ,LGL_REP_ID            --法人编号
         ,CUST_ID               --客户编号
         ,REL_TYP               --关系类型
         ,REL_PSN_TYP           --关联人类型
         ,REL_PSN_CUST_NM       --关联人客户名称
         ,REL_PSN_CUST_ID       --关联人客户编号
         ,REL_PSN_CTRY_CD       --关联人国家代码
         ,REL_PSN_CRDL_TYP      --关联人证件类型
         ,REL_PSN_CRDL_NO       --关联人证件号码
         ,PBC_NO                --人行支付行号
         ,FIN_PERMIT_NO         --金融许可证号
         ,ACT_CNTLR_FLG         --实际控制人标志
         ,ACT_CNTLR_TYP         --实际控制人类型
         ,REGD_CD_RSK           --登记注册代码（客户风险）
         ,UPD_INFO_DT           --更新信息日期
         ,SENIOR_IMPT_PSN_FLG   --高管及重要联系人标志
         ,REL_STAT              --关联关系状态
         ,PP1_NO                --护照1号码
         ,PP1_ISU_DT            --护照1签发日期
         ,PP1_EXP_DT            --护照1到期日期
         ,PP2_NO                --护照2号码
         ,PP2_ISU_DT            --护照2签发日期
         ,PP2_EXP_DT            --护照2到期日期
         ,PP3_NO                --护照3号码
         ,PP3_ISU_DT            --护照3签发日期
         ,PP3_EXP_DT            --护照3到期日期
         ,OTH_CRDL_TYP1         --其他证件类型1
         ,OTH_CRDL_NO1          --其他证件号码1
         ,OTH_CRDL_TYP2         --其他证件类型2
         ,OTH_CRDL_NO2          --其他证件号码2
         ,DEPT_LINE             --部门条线
         ,DATA_SRC              --数据来源
         ,REL_PSN_TYP_ORIG      --原始关联人类型
         ,HOLD_TYPE_CD          --持股类型代码
         ,DEPOSITR_CATE_CD      --存款人类型代码
    FROM TMP1
   WHERE RN = 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  IF V_P_DATE = TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD') THEN
    --ADD BY 20240229 插入当月内被删除的数据
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '插入当月内被删除的数据';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_MDL.M_CUST_CORP_REL_SUB
      (DATA_DT                     --数据日期
      ,LGL_REP_ID                  --法人编号
      ,CUST_ID                     --客户编号
      ,REL_TYP                     --关系类型
      ,REL_PSN_TYP                 --关联人类型
      ,REL_PSN_CUST_NM             --关联人客户名称
      ,REL_PSN_CUST_ID             --关联人客户编号
      ,REL_PSN_CTRY_CD             --关联人国家代码
      ,REL_PSN_CRDL_TYP            --关联人证件类型
      ,REL_PSN_CRDL_NO             --关联人证件号码
      ,PBC_NO                      --人行支付行号
      ,FIN_PERMIT_NO               --金融许可证号
      ,ACT_CNTLR_FLG               --实际控制人标志
      ,ACT_CNTLR_TYP               --实际控制人类型
      ,REGD_CD_RSK                 --登记注册代码（客户风险）
      ,UPD_INFO_DT                 --更新信息日期
      ,SENIOR_IMPT_PSN_FLG         --高管及重要联系人标志
      ,REL_STAT                    --关联关系状态
      ,PP1_NO                      --护照1号码
      ,PP1_ISU_DT                  --护照1签发日期
      ,PP1_EXP_DT                  --护照1到期日期
      ,PP2_NO                      --护照2号码
      ,PP2_ISU_DT                  --护照2签发日期
      ,PP2_EXP_DT                  --护照2到期日期
      ,PP3_NO                      --护照3号码
      ,PP3_ISU_DT                  --护照3签发日期
      ,PP3_EXP_DT                  --护照3到期日期
      ,OTH_CRDL_TYP1               --其他证件类型1
      ,OTH_CRDL_NO1                --其他证件号码1
      ,OTH_CRDL_TYP2               --其他证件类型2
      ,OTH_CRDL_NO2                --其他证件号码2
      ,DEPT_LINE                   --部门条线
      ,DATA_SRC                    --数据来源
      ,REL_PSN_TYP_ORIG            --原始关联人类型代码
      ,HOLD_TYPE_CD                --持股类型代码
      ,DEPOSITR_CATE_CD            --存款人类型代码
      ,RELA_PS_CERT_TYPE_CD        --数仓关联人证件类型
      ,ECIF_CUST_ID                --ECIF客户号
      )
      WITH TMP1 AS (
    SELECT T.*
           ,ROW_NUMBER() OVER(PARTITION BY T.CUST_ID,T.REL_PSN_TYP,T.REL_PSN_CRDL_NO,T.REL_TYP ORDER BY T.DATA_DT DESC) RN
      FROM RRP_MDL.M_CUST_CORP_REL_SUB T
      LEFT JOIN RRP_MDL.M_CUST_CORP_REL_SUB TB
        ON TB.CUST_ID = TRIM(T.CUST_ID)
       AND TB.REL_PSN_TYP = T.REL_PSN_TYP
       AND TB.REL_PSN_CRDL_NO = T.REL_PSN_CRDL_NO
       AND TB.REL_TYP = T.REL_TYP
       AND TB.DATA_DT = V_P_DATE
     WHERE TRIM(TB.CUST_ID) IS NULL
       AND T.REL_TYP = '10'
       AND T.DATA_DT >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD')
       AND T.DATA_DT <= V_P_DATE)
    SELECT V_P_DATE                AS DATA_DT                     --数据日期
          ,TA.LGL_REP_ID           AS LGL_REP_ID                  --法人编号
          ,TA.CUST_ID              AS CUST_ID                     --客户编号
          ,TA.REL_TYP              AS REL_TYP                     --关系类型
          ,TA.REL_PSN_TYP          AS REL_PSN_TYP                 --关联人类型
          ,TA.REL_PSN_CUST_NM      AS REL_PSN_CUST_NM             --关联人客户名称
          ,TA.REL_PSN_CUST_ID      AS REL_PSN_CUST_ID             --关联人客户编号
          ,TA.REL_PSN_CTRY_CD      AS REL_PSN_CTRY_CD             --关联人国家代码
          ,TA.REL_PSN_CRDL_TYP     AS REL_PSN_CRDL_TYP            --关联人证件类型
          ,TA.REL_PSN_CRDL_NO      AS REL_PSN_CRDL_NO             --关联人证件号码
          ,TA.PBC_NO               AS PBC_NO                      --人行支付行号
          ,TA.FIN_PERMIT_NO        AS FIN_PERMIT_NO               --金融许可证号
          ,TA.ACT_CNTLR_FLG        AS ACT_CNTLR_FLG               --实际控制人标志
          ,TA.ACT_CNTLR_TYP        AS ACT_CNTLR_TYP               --实际控制人类型
          ,TA.REGD_CD_RSK          AS REGD_CD_RSK                 --登记注册代码（客户风险）
          ,TA.UPD_INFO_DT          AS UPD_INFO_DT                 --更新信息日期
          ,TA.SENIOR_IMPT_PSN_FLG  AS SENIOR_IMPT_PSN_FLG         --高管及重要联系人标志
          ,TA.REL_STAT             AS REL_STAT                    --关联关系状态
          ,TA.PP1_NO               AS PP1_NO                      --护照1号码
          ,TA.PP1_ISU_DT           AS PP1_ISU_DT                  --护照1签发日期
          ,TA.PP1_EXP_DT           AS PP1_EXP_DT                  --护照1到期日期
          ,TA.PP2_NO               AS PP2_NO                      --护照2号码
          ,TA.PP2_ISU_DT           AS PP2_ISU_DT                  --护照2签发日期
          ,TA.PP2_EXP_DT           AS PP2_EXP_DT                  --护照2到期日期
          ,TA.PP3_NO               AS PP3_NO                      --护照3号码
          ,TA.PP3_ISU_DT           AS PP3_ISU_DT                  --护照3签发日期
          ,TA.PP3_EXP_DT           AS PP3_EXP_DT                  --护照3到期日期
          ,TA.OTH_CRDL_TYP1        AS OTH_CRDL_TYP1               --其他证件类型1
          ,TA.OTH_CRDL_NO1         AS OTH_CRDL_NO1                --其他证件号码1
          ,TA.OTH_CRDL_TYP2        AS OTH_CRDL_TYP2               --其他证件类型2
          ,TA.OTH_CRDL_NO2         AS OTH_CRDL_NO2                --其他证件号码2
          ,TA.DEPT_LINE            AS DEPT_LINE                   --部门条线
          ,TA.DATA_SRC             AS DATA_SRC                    --数据来源
          ,TA.REL_PSN_TYP_ORIG     AS REL_PSN_TYP_ORIG            --原始关联人类型代码
          ,TA.HOLD_TYPE_CD         AS HOLD_TYPE_CD                --持股类型代码
          ,TA.DEPOSITR_CATE_CD     AS DEPOSITR_CATE_CD            --存款人类型代码
          ,TA.RELA_PS_CERT_TYPE_CD AS RELA_PS_CERT_TYPE_CD        --数仓关联人证件类型
          ,TA.ECIF_CUST_ID         AS ECIF_CUST_ID                --ECIF客户号
      FROM TMP1 TA
     WHERE TA.RN = 1;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
  END IF;

  --去掉表的主键，通过语句判断数据是否重复
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';
  V_STARTTIME := SYSDATE;
    WITH TMP1 AS (
  SELECT DATA_DT,CUST_ID,REL_PSN_TYP,REL_PSN_CRDL_NO,REL_TYP,COUNT(1)
    FROM RRP_MDL.M_CUST_CORP_REL_SUB T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,CUST_ID,REL_PSN_TYP,REL_PSN_CRDL_NO,REL_TYP
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES(V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

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

END ETL_M_CUST_CORP_REL_SUB;
/

