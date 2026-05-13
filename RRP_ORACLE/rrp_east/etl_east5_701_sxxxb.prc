CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_701_SXXXB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_EAST5_701_SXXXB
  *  功能描述：授信信息表
  *  创建日期：20220712
  *  开发人员：王锐
  *  来源表： M_CRDT_LMT_SUB  授信额度子表
              M_CUST_CORP_INFO  对公客户信息
              M_CUST_IND_INFO  个人客户信息
              M_PUM_ORG_INFO_EAST  机构表
              CODE_MAP   码值配置表
              CONFIG_ORG_REL  机构级次关系表
              CONFIG_TABLE_LIST   分行报送报表配置表
  *  目标表： EAST5_701_SXXXB 授信信息表
  *
  *  配置表：
  *  修改日期  修改人     修改原因
  *  20251203  LIP        调整取数逻辑，根据授信表中的月报标志和有效标志判断
  *  20260211  LIP        剔除买断式转贴现部分授信的客户号和借据的客户号不一致时取得业务合同
  ***************************************************************************/
AS
  V_P_DATE           VARCHAR2(8);      --数据日期
  V_MONTH_END_DATEID VARCHAR2(8);      --本月月底日期
  V_PARTITION_NAME   VARCHAR2(100);    --分区名称
  V_FREQ_FLAG        VARCHAR2(10);     --跑批频度
  V_STEP             INTEGER := 0;     --任务号
  V_COUNT            INTEGER := 0;     --数据记录条数
  V_SQLCOUNT         INTEGER := 0;     --更新或删除影响的记录数
  V_STARTTIME        DATE := SYSDATE;  --处理开始时间
  V_ENDTIME          DATE := SYSDATE;  --处理结束时间
  V_SQLMSG           VARCHAR2(300);    --SQL执行描述信息
  V_STEP_DESC        VARCHAR2(100);    --处理步骤描述
  V_TABLE_NAME       VARCHAR2(100) := 'EAST5_701_SXXXB'; --表名称
  V_PROC_NAME        VARCHAR2(100) := 'ETL_EAST5_701_SXXXB'; --存储过程名称
BEGIN
  V_P_DATE  := TO_CHAR(I_P_DATE);
  O_ERRCODE := '0';
  V_MONTH_END_DATEID := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD');
  V_PARTITION_NAME   := 'PARTITION_' || V_P_DATE;
  V_FREQ_FLAG        := RRP_EAST.FUN_FREQ(I_P_DATE,V_PROC_NAME);

  --判断跑批频度
  IF V_FREQ_FLAG = '1' THEN
    --支持重跑
    V_STEP := 1;
    V_STEP_DESC := '程序跑批开始';
    V_STARTTIME := SYSDATE;
    RRP_EAST.ETL_PARTITION_ADD(I_P_DATE,V_TABLE_NAME,1,O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --清空表分区数据
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '清空表分区数据';
    V_STARTTIME := SYSDATE;
    RRP_EAST.ETL_PARTITION_TRUNCATE(I_P_DATE,V_TABLE_NAME,O_ERRCODE); --清空当日分区以便重跑

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '插入个人客户数据';
    V_STARTTIME := SYSDATE;
    EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_EAST.EAST5_701_SXXXB_TMP'; --分区表的重跑处理
    INSERT INTO RRP_EAST.EAST5_701_SXXXB_TMP
      (RID, --数据主键
       YHJGDM, --银行机构代码
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       KHTYBH, --客户统一编号
       KHMC, --客户名称
       KHZJLB, --客户证件类别
       KHZJHM, --客户证件号码
       SXXYH, --授信协议号
       SXXYMC, --授信协议名称
       EDSQRQ, --额度申请日期
       SXZTZL, --授信主体种类
       SXZL, --授信种类
       SXED, --授信额度
       YYED, --已用额度
       BZ, --币种
       SXKSRQ, --授信开始日期
       SXDQRQ, --授信到期日期
       SXJCYJ, --授信审批意见
       SPRGH, --审批人工号
       JBRGH, --经办人工号
       SXZT, --授信状态
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       KHMC_ORIG,--客户名称（脱敏前）
       KHZJHM_ORIG,--客户证件号码（脱敏前）
       KHMC_OTH,--客户名称（是否个人客户）
       DKCPMC, --贷款产品名称 --只用来区分行内外产品 ADD BY LIP 20220427 业务用来区分行内外贷款
       GSFZJG, --归属分支机构.
       KHLX, --客户类型
       STATUS_CD --状态代码 --ADD BY LIP 20241031
       )
    SELECT /*+USE_HASH(A,C,D,CODE,CODE1,CODE2,CODE3,ORG,LIST)*/
           SYS_GUID()                          AS RID, ---数据主键
           D.PBC_NO                            AS YHJGDM, --银行机构代码
           D.FIN_PERMIT_NO                     AS JRXKZH, --金融许可证号
           D.ORG_ID                            AS NBJGH, --内部机构号
           A.CUST_ID                           AS KHTYBH, --客户统一编号
           C.CUST_NM_DESEN                     AS KHMC, --客户名称 --MODIFY BY LAIHAIQIANG AT 20230403
           --CODE.TAR_VALUE_NAME                 AS KHZJLB, --客户证件类别
           --TRIM(SUBSTRB(CODE.TAR_VALUE_NAME,1,40)) AS KHZJLB, --客户证件类别 --MODIFY BY LIP
           TRIM(SUBSTRB(CODE.TAR_VALUE_NAME,1,60)) AS KHZJLB, --客户证件类别 --MODIFY BY LIP 20240409 改为UTF-8的长度
           C.CRDL_NO_DESEN                      AS KHZJHM, --客户证件号码
           A.CRDT_CONT_ID                       AS SXXYH, --授信协议号
           A.CRDT_CONT_NM                       AS SXXYMC, --授信协议名称
           NVL(A.CRDT_APP_DT,'99991231')        AS EDSQRQ, --额度申请日期
           CODE1.TAR_VALUE_NAME                 AS SXZTZL, --授信主体种类
           CODE2.TAR_VALUE_NAME                 AS SXZL, --授信种类
           A.CRDT_LMT                           AS SXED, --授信额度
           A.ALDY_USE_LMT                       AS YYED, --已用额度
           A.CUR                                AS BZ, --币种
           NVL(A.CRDT_START_DT,'99991231')      AS SXKSRQ, --授信开始日期
           --NVL(A.CRDT_EXP_DT,'99991231')       AS SXDQRQ, --授信到期日期
           CASE WHEN A.CRDT_EXP_DT IN ('00010101','29991231') THEN '99991231'
                ELSE NVL(A.CRDT_EXP_DT,'99991231')
            END                                  AS SXDQRQ, --授信到期日期
           REPLACE(REPLACE(TRIM(A.DSN_SHT_OPN),CHR(10),''),CHR(13),'') AS SXJCYJ, --授信审批意见
           /*A.APRV_PSN_NO                        AS SPRGH, --审批人工号
           A.CRDT_EMP_NO                        AS JBRGH, --经办人工号*/
           REPLACE(REPLACE(TRIM(A.APRV_PSN_NO),CHR(10),''),CHR(13),'') AS SPRGH, --审批人工号
           REPLACE(REPLACE(TRIM(A.CRDT_EMP_NO),CHR(10),''),CHR(13),'') AS JBRGH, --经办人工号
           CODE3.TAR_VALUE_NAME                 AS SXZT, --授信状态
           ''                                   AS BBZ, --备注
           V_MONTH_END_DATEID                   AS CJRQ, --采集日期
           '000'                                AS DEPT_NO, --部门编号
           '01'                                 AS SRC_SYS_ID, --来源系统ID
           '000000'                             AS ISSUED_NO, --填报机构
           ORG.ORG_ID_LEL_0                     AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                 AS ADDRESS, --归属地
           C.CUST_NM                            AS KHMC_ORIG,--客户名称（脱敏前）
           C.CRDL_NO                            AS KHZJHM_ORIG,--客户证件号码（脱敏前）
           '是'                                 AS KHMC_OTH,--客户名称（是否个人客户）
           /*CASE WHEN A.CRDT_BIZ_TYP = '202010100003' THEN '花呗'
                WHEN A.CRDT_BIZ_TYP IN ('202010100006','202010100008','202020100003') THEN '微粒贷'
                WHEN A.CRDT_BIZ_TYP IN ('202010100001','202010100002') THEN '借呗'
                WHEN A.CRDT_BIZ_TYP IN ('202010100004','202010100005') THEN '京东'
                WHEN A.CRDT_BIZ_TYP IN ('202020100001','202020200004') THEN '网商贷'
                WHEN A.CRDT_BIZ_TYP IN ('202020200001') THEN '字节小微贷' --MOD BY LIP 20250115
                WHEN A.CRDT_BIZ_TYP IN ('201020100057') THEN '华兴快贷经营' --MOD BY LIP 20250115 房抵贷
                WHEN A.CRDT_BIZ_TYP IN ('203050100001') THEN '字节微业贷' --MOD BY LIP 20250310 微业贷
                WHEN A.DATA_SRC LIKE '%联合网贷%' THEN TA.PROD_NAME --MOD BY LIP 20250808
                ELSE '行内自营贷款'
            END                                AS DKCPMC, --贷款产品名称 --MODIFY BY TANGAN AT 20230109*/
           TA.PROD_NAME                        AS DKCPMC, --贷款产品名称 --MOD BY LIP 20251216 直接展示所有产品名称
           CASE WHEN LIST.FLAG = 1 THEN D.GSFZJG
                ELSE '9999'
            END                                AS GSFZJG, --归属分支机构 --MODIFY BY LIP
           '个人客户'                          AS KHLX, --客户类型  --modify by tangan at 20230201
           NVL(TRIM(A.STATUS_CD),'2')          AS STATUS_CD --状态代码 --ADD BY LIP 20241031
      FROM RRP_MDL.M_CRDT_LMT_SUB A --授信额度子表
     INNER JOIN RRP_EAST.M_CUST_IND_INFO_EAST C --个人客户信息
        ON C.CUST_ID = A.CUST_ID
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST D --机构表
        ON D.ORG_ID = NVL(M.ORG_ID1,'800')
       AND D.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = C.CRDL_TYP
       AND CODE.SRC_CLASS_CODE = 'C0001' --客户证件类别
       AND CODE.TAR_CLASS_CODE = 'C0001' --客户证件类别
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = A.CRDT_SUBJ_TYP
       AND CODE1.SRC_CLASS_CODE = 'C0032' --授信主体种类
       AND CODE1.TAR_CLASS_CODE = 'C0032' --授信主体种类
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE2 --码值配置表
        ON CODE2.SRC_VALUE_CODE = A.CRDT_SUBJ_CL
       AND CODE2.SRC_CLASS_CODE = 'T0029' --授信种类
       AND CODE2.TAR_CLASS_CODE = 'T0029' --授信种类
       AND CODE2.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE3 --码值配置表
        ON CODE3.SRC_VALUE_CODE = A.CRDT_STAT
       AND CODE3.SRC_CLASS_CODE = 'Z0002' --授信状态
       AND CODE3.TAR_CLASS_CODE = 'Z0002' --授信状态
       AND CODE3.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO TA --标准产品信息表 --ADD BY LIP 20250808
        ON TA.PROD_ID = A.STD_PROD_ID
       AND TA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON D.ORG_ID = ORG.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON 1 = 1
       AND UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     /*WHERE ((CASE WHEN A.CRDT_BIZ_TYP IN ('202010100001','202010100002', --蚂蚁借呗联合贷款 借呗三期
                                          '202010100003', --蚂蚁花呗联合贷款
                                          '202010100004', --京东金融联合贷款
                                          '202010100006','202010100008','202020100003', --微粒贷 微粒贷(消费) 微粒贷(经营) --MOD BY LIP 20230523 新增的微粒贷产品
                                          '202020100001','202020200004', --网商贷 网商贷（引流业务）
                                          '202020200001') --字节小微贷 --ADD BY LIP 20250115
                  THEN 'Y'  --联合网贷全取
                  WHEN A.DATA_SRC LIKE '%联合网贷%' THEN 'Y'  --联合网贷全取
                  ELSE A.CRDT_STAT END) = 'Y'
        OR (A.CRDT_STAT = 'N' AND A.CRDT_EXP_DT >= V_MONTH_START_DATEID AND A.CRDT_EXP_DT <= V_P_DATE)
        OR (A.CRDT_STAT = 'N' AND A.ALDY_USE_LMT > 0)) --MODIFY BY TANGAN AT 20230110 剔除本期之前无效的数据
       AND NVL(TRIM(A.STATUS_CD),'2') NOT IN ('1','9') --ADD BY LIP 20241031 CD2586 剔除 1未生效9其他状态
       AND NVL(A.CUST_ID_ZT_FLG,'Z') IN ('N','Z') --MOD BY LIP 20250310 过滤系统内转帖直贴人的数据
       AND A.DATA_DT = V_P_DATE;*/
     WHERE (A.EAST_MON_FLG = 'Y' OR A.CRDT_STAT = 'Y') --MOD BY LIP 20251203 根据授信子表中的有效标识判断
       AND NVL(A.CUST_ID_ZT_FLG,'Z') IN ('N','Z') --MOD BY LIP 20250310 过滤系统内转帖直贴人的数据
       AND A.DATA_DT = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '插入对公客户数据';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_701_SXXXB_TMP
      (RID, --数据主键
       YHJGDM, --银行机构代码
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       KHTYBH, --客户统一编号
       KHMC, --客户名称
       KHZJLB, --客户证件类别
       KHZJHM, --客户证件号码
       SXXYH, --授信协议号
       SXXYMC, --授信协议名称
       EDSQRQ, --额度申请日期
       SXZTZL, --授信主体种类
       SXZL, --授信种类
       SXED, --授信额度
       YYED, --已用额度
       BZ, --币种
       SXKSRQ, --授信开始日期
       SXDQRQ, --授信到期日期
       SXJCYJ, --授信审批意见
       SPRGH, --审批人工号
       JBRGH, --经办人工号
       SXZT, --授信状态
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       KHMC_ORIG,--客户名称（脱敏前）
       KHZJHM_ORIG,--客户证件号码（脱敏前）
       KHMC_OTH,--客户名称（是否个人客户）
       DKCPMC, --贷款产品名称 只用来区分行内外产品 ADD BY LIP 20220427 业务用来区分行内外贷款
       GSFZJG, --归属分支机构
       KHLX,  --客户类型
       STATUS_CD --状态代码 --ADD BY LIP 20241031
       )
    SELECT /*+USE_HASH(A,C,D,CODE,CODE1,CODE2,CODE3,ORG,LIST)*/
           SYS_GUID()                            AS RID, ---数据主键
           D.PBC_NO                              AS YHJGDM, --银行机构代码
           D.FIN_PERMIT_NO                       AS JRXKZH, --金融许可证号
           D.ORG_ID                              AS NBJGH, --内部机构号
           A.CUST_ID                             AS KHTYBH, --客户统一编号
           --C.CUST_NM                             AS KHMC, --客户名称
           --MOD BY LIP 20230505 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(C.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(C.CUST_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(C.CUST_NM)
            END                                  AS KHMC, --客户名称
           CASE WHEN TRIM(C.PBC_NO) IS NOT NULL AND C.NATL_ECON_DEPT_CL NOT LIKE 'E%' THEN '银行机构代码'
                WHEN TRIM(C.PBC_NO) IS NOT NULL AND C.NATL_ECON_DEPT_CL LIKE 'E%' THEN 'SWIFT编码'
                WHEN TRIM(C.PBC_NO) IS NULL AND TRIM(C.FIN_PERMIT_NO) IS NOT NULL THEN '金融许可证号'
                --ELSE TRIM(SUBSTRB(CODE.TAR_VALUE_NAME,1,40)) --MODIFY BY LIP
                ELSE TRIM(SUBSTRB(CODE.TAR_VALUE_NAME,1,60)) --MODIFY BY LIP 20240409 改为UTF-8的长度
            END                                  AS KHZJLB, --客户证件类别
           CASE WHEN TRIM(C.PBC_NO) IS NOT NULL THEN TRIM(C.PBC_NO)
                WHEN TRIM(C.PBC_NO) IS NULL AND TRIM(C.FIN_PERMIT_NO) IS NOT NULL THEN TRIM(C.FIN_PERMIT_NO)
                ELSE TRIM(C.CRDL_NO)
            END                                  AS KHZJHM, --客户证件号码
           A.CRDT_CONT_ID                        AS SXXYH, --授信协议号
           /*A.PRIM_CRDT_CONT_ID                        AS SXXYH,  --modiby by xieyugeng 202221017*/
           A.CRDT_CONT_NM                        AS SXXYMC, --授信协议名称
           NVL(A.CRDT_APP_DT,'99991231')         AS EDSQRQ, --额度申请日期
           CODE1.TAR_VALUE_NAME                  AS SXZTZL, --授信主体种类
           CODE2.TAR_VALUE_NAME                  AS SXZL, --授信种类
           A.CRDT_LMT                            AS SXED, --授信额度
           A.ALDY_USE_LMT                        AS YYED, --已用额度
           A.CUR                                 AS BZ, --币种
           NVL(A.CRDT_START_DT,'99991231')       AS SXKSRQ, --授信开始日期
           CASE WHEN A.CRDT_EXP_DT IN ('00010101','29991231') THEN '99991231'
                ELSE NVL(A.CRDT_EXP_DT,'99991231')
            END                                  AS SXDQRQ, --授信到期日期
           REPLACE(REPLACE(TRIM(A.DSN_SHT_OPN),CHR(10),''),CHR(13),'') AS SXJCYJ, --授信审批意见
           TRIM(A.APRV_PSN_NO)                   AS SPRGH, --审批人工号
           TRIM(A.CRDT_EMP_NO)                   AS JBRGH, --经办人工号
           CODE3.TAR_VALUE_NAME                  AS SXZT, --授信状态
           ''                                    AS BBZ, --备注
           V_MONTH_END_DATEID                    AS CJRQ, --采集日期
           '000'                                 AS DEPT_NO, --部门编号
           '01'                                  AS SRC_SYS_ID, --来源系统ID
           '000000'                              AS ISSUED_NO, --填报机构
           ORG.ORG_ID_LEL_0                      AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
           END                                   AS ADDRESS, --归属地
           --C.CUST_NM                             AS KHMC_ORIG,--客户名称（脱敏前）
           --MOD BY LIP 20230505 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(C.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(C.CUST_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(C.CUST_NM)
            END                                  AS KHMC_ORIG,--客户名称（脱敏前）
           C.CRDL_NO                             AS KHZJHM_ORIG,--客户证件号码（脱敏前）
           '否'                                  AS KHMC_OTH,--客户名称（是否个人客户）
           /*CASE WHEN A.CRDT_BIZ_TYP IN ('203050100001') THEN '字节微业贷' --MOD BY LIP 20250310 微业贷
                ELSE '对公贷款'
            END                                  AS DKCPMC, --贷款产品名称 只用来区分行内外产品 ADD BY LIP 20220427 业务用来区分行内外贷款*/
           TA.PROD_NAME                          AS DKCPMC, --贷款产品名称 --MOD BY LIP 20251216 直接展示所有产品名称
           CASE WHEN LIST.FLAG = 1 THEN D.GSFZJG
                ELSE '9999'
            END                                  AS GSFZJG,--归属分支机构 --MODIFY BY LIP
           CASE WHEN C.TYBZ = 'Y' THEN '同业客户'
                 ELSE '对公客户'
            END                                  AS KHLX, --客户类型  --modify by tangan at 20230201
           NVL(TRIM(A.STATUS_CD),'2')            AS STATUS_CD --状态代码 --ADD BY LIP 20241031
      FROM RRP_MDL.M_CRDT_LMT_SUB A --授信额度子表
     INNER JOIN RRP_MDL.M_CUST_CORP_INFO C --对公客户信息
        ON C.CUST_ID = A.CUST_ID
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.ORG_CONFIG M
        ON M.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST D --机构表
        ON D.ORG_ID = NVL(M.ORG_ID1,'800')
       AND D.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = C.CRDL_TYP
       AND CODE.SRC_CLASS_CODE = 'C0001' --客户证件类别
       AND CODE.TAR_CLASS_CODE = 'C0001' --客户证件类别
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = A.CRDT_SUBJ_TYP
       AND CODE1.SRC_CLASS_CODE = 'C0032' --授信主体种类
       AND CODE1.TAR_CLASS_CODE = 'C0032' --授信主体种类
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE2 --码值配置表
        ON CODE2.SRC_VALUE_CODE = A.CRDT_SUBJ_CL
       AND CODE2.SRC_CLASS_CODE = 'T0029' --授信种类
       AND CODE2.TAR_CLASS_CODE = 'T0029' --授信种类
       AND CODE2.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE3 --码值配置表
        ON CODE3.SRC_VALUE_CODE = A.CRDT_STAT
       AND CODE3.SRC_CLASS_CODE = 'Z0002' --授信状态
       AND CODE3.TAR_CLASS_CODE = 'Z0002' --授信状态
       AND CODE3.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = D.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON 1 = 1
       AND UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
      LEFT JOIN RRP_MDL.O_ICL_CMM_LOAN_PROD_INFO TA --贷款产品信息 --ADD BY LIP 20251216
        ON TA.PROD_ID = A.STD_PROD_ID
       AND TA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     /*WHERE CODE1.TAR_VALUE_NAME NOT IN ('集团客户授信') --MOD BY LIP 20230522 剔除集团客户授信
       \*AND (A.CRDT_STAT = 'Y' OR (A.CRDT_STAT = 'N' AND A.CRDT_EXP_DT >= V_MONTH_START_DATEID)) --MODIFY BY TANGAN AT 20230110 剔除本期之前无效的数据
       --AND NVL(TRIM(A.STATUS_CD),'2') NOT IN ('1','9') --ADD BY LIP 20241031 CD2586 剔除 1未生效9其他状态
       AND (A.CRDT_STAT = 'Y' OR NVL(TRIM(A.STATUS_CD),'2') NOT IN ('1','9')) --ADD BY LIP 20241216 授信状态正常的调整为取数*\
       AND (DECODE(A.CRDT_BIZ_TYP,'203050100001','Y',A.CRDT_STAT) = 'Y' OR (A.CRDT_STAT = 'N' AND A.CRDT_EXP_DT >= V_MONTH_START_DATEID))
       AND (DECODE(A.CRDT_BIZ_TYP,'203050100001','Y',A.CRDT_STAT) = 'Y' OR NVL(TRIM(A.STATUS_CD),'2') NOT IN ('1','9')) --MOD BY LIP 20250310 微业贷的默认为有效
       AND NVL(A.CUST_ID_ZT_FLG,'Z') IN ('N','Z') --MOD BY LIP 20250310 过滤系统内转帖直贴人的数据
       AND A.DATA_DT = V_P_DATE;*/
     WHERE CODE1.TAR_VALUE_NAME NOT IN ('集团客户授信') --MOD BY LIP 20230522 剔除集团客户授信
       AND (A.EAST_MON_FLG = 'Y' OR A.CRDT_STAT = 'Y') --MOD BY LIP 20251203 根据授信子表中的有效标识判断
       --AND NVL(A.CUST_ID_ZT_FLG,'Z') IN ('N','Z') --MOD BY LIP 20250310 过滤系统内转帖直贴人的数据
       AND NVL(A.CUST_ID_ZT_FLG,'Z') IN ('Z') --MOD BY LIP 20260211 剔除买断式转贴现部分授信的客户号和借据的客户号不一致时取得业务合同
       AND A.DATA_DT = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '插入目标表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_701_SXXXB
      (RID, --数据主键
       YHJGDM, --银行机构代码
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       KHTYBH, --客户统一编号
       KHMC, --客户名称
       KHZJLB, --客户证件类别
       KHZJHM, --客户证件号码
       SXXYH, --授信协议号
       SXXYMC, --授信协议名称
       EDSQRQ, --额度申请日期
       SXZTZL, --授信主体种类
       SXZL, --授信种类
       SXED, --授信额度
       YYED, --已用额度
       BZ, --币种
       SXKSRQ, --授信开始日期
       SXDQRQ, --授信到期日期
       SXJCYJ, --授信审批意见
       SPRGH, --审批人工号
       JBRGH, --经办人工号
       SXZT, --授信状态
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       KHMC_ORIG, --客户名称（脱敏前）
       KHZJHM_ORIG,--客户证件号码（脱敏前）
       KHMC_OTH,--客户名称（是否个人客户）
       DKCPMC, --贷款产品名称 只用来区分行内外产品 ADD BY LIP 20220427 业务用来区分行内外贷款
       GSFZJG --归属分支机构
       ,KHLX  --客户类型
       )
    SELECT A.RID                                                    AS RID, --数据主键
           A.YHJGDM                                                 AS YHJGDM, --银行机构代码
           A.JRXKZH                                                 AS JRXKZH, --金融许可证号
           A.NBJGH                                                  AS NBJGH, --内部机构号
           A.KHTYBH                                                 AS KHTYBH, --客户统一编号
           A.KHMC                                                   AS KHMC, --客户名称
           A.KHZJLB                                                 AS KHZJLB, --客户证件类别
           A.KHZJHM                                                 AS KHZJHM, --客户证件号码
           REPLACE(REPLACE(A.SXXYH,CHR(10),''),CHR(13),'')          AS SXXYH, --授信协议号
           REPLACE(REPLACE(A.SXXYMC,CHR(10),''),CHR(13),'')         AS SXXYMC, --授信协议名称
           A.EDSQRQ                                                 AS EDSQRQ, --额度申请日期
           A.SXZTZL                                                 AS SXZTZL, --授信主体种类
           A.SXZL                                                   AS SXZL, --授信种类
           A.SXED                                                   AS SXED, --授信额度
           A.YYED                                                   AS YYED, --已用额度
           A.BZ                                                     AS BZ, --币种
           A.SXKSRQ                                                 AS SXKSRQ, --授信开始日期
           A.SXDQRQ                                                 AS SXDQRQ, --授信到期日期
           REPLACE(REPLACE(A.SXJCYJ,CHR(10),''),CHR(13),'')         AS SXJCYJ, --授信审批意见
           REPLACE(REPLACE(A.SPRGH,CHR(10),''),CHR(13),'')          AS SPRGH, --审批人工号
           REPLACE(REPLACE(A.JBRGH,CHR(10),''),CHR(13),'')          AS JBRGH, --经办人工号
           REPLACE(REPLACE(A.SXZT,CHR(10),''),CHR(13),'')           AS SXZT, --授信状态
           A.BBZ                                                    AS BBZ, --备注
           A.CJRQ                                                   AS CJRQ, --采集日期
           A.DEPT_NO                                                AS DEPT_NO, --部门编号
           A.SRC_SYS_ID                                             AS SRC_SYS_ID, --来源系统ID
           A.ISSUED_NO                                              AS ISSUED_NO, --填报机构
           A.ORG_NO                                                 AS ORG_NO, --报送机构
           A.ADDRESS                                                AS ADDRESS, --归属地
           A.KHMC_ORIG                                              AS KHMC_ORIG, --客户名称（脱敏前）
           A.KHZJHM_ORIG                                            AS KHZJHM_ORIG,--客户证件号码（脱敏前）
           A.KHMC_OTH                                               AS KHMC_OTH,--客户名称（是否个人客户）
           A.DKCPMC                                                 AS DKCPMC, --贷款产品名称 只用来区分行内外产品 ADD BY LIP 20220427 业务用来区分行内外贷款
           A.GSFZJG                                                 AS GSFZJG, --归属分支机构
           A.KHLX                                                   AS KHLX  --客户类型  --modify by tangan at 20230201
      FROM RRP_EAST.EAST5_701_SXXXB_TMP A
      LEFT JOIN RRP_MDL.M_CRDT_LMT_SUB B --授信额度子表 --MOD BY LIP 20241031 剔除上月是未生效和状态，但本月是终结的数据
        ON B.CRDT_CONT_ID = A.SXXYH
       AND A.STATUS_CD IN ('4') --终结
       AND B.STATUS_CD IN ('1','9') --CD2586 1未生效9其他状态
       AND B.DATA_DT = TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1,'YYYYMMDD')
     WHERE B.CRDT_CONT_ID IS NULL;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --ADD BY LIP 20240702 上期授信状态为有效，本期因余额结清、系统状态失效未采集的，本期授信状态调整为失效，作为终态报送
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '将上期授信状态为有效本期未采集到的插入目标表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_701_SXXXB
      (RID, --数据主键
       YHJGDM, --银行机构代码
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       KHTYBH, --客户统一编号
       KHMC, --客户名称
       KHZJLB, --客户证件类别
       KHZJHM, --客户证件号码
       SXXYH, --授信协议号
       SXXYMC, --授信协议名称
       EDSQRQ, --额度申请日期
       SXZTZL, --授信主体种类
       SXZL, --授信种类
       SXED, --授信额度
       YYED, --已用额度
       BZ, --币种
       SXKSRQ, --授信开始日期
       SXDQRQ, --授信到期日期
       SXJCYJ, --授信审批意见
       SPRGH, --审批人工号
       JBRGH, --经办人工号
       SXZT, --授信状态
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       KHMC_ORIG, --客户名称（脱敏前）
       KHZJHM_ORIG,--客户证件号码（脱敏前）
       KHMC_OTH,--客户名称（是否个人客户）
       DKCPMC, --贷款产品名称 只用来区分行内外产品
       GSFZJG --归属分支机构
       ,KHLX  --客户类型
       )
    SELECT SYS_GUID()                    AS RID, --数据主键
           C.PBC_NO                      AS YHJGDM, --银行机构代码
           C.FIN_PERMIT_NO               AS JRXKZH, --金融许可证号
           A.NBJGH                       AS NBJGH, --内部机构号
           A.KHTYBH                      AS KHTYBH, --客户统一编号
           CASE WHEN D.CUST_ID IS NOT NULL THEN D.CUST_NM_DESEN
                WHEN REGEXP_REPLACE(TRIM(E.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(E.CUST_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(E.CUST_NM)
            END                          AS KHMC, --客户名称
           CASE WHEN TRIM(E.PBC_NO) IS NOT NULL AND E.NATL_ECON_DEPT_CL NOT LIKE 'E%' THEN '银行机构代码'
                WHEN TRIM(E.PBC_NO) IS NOT NULL AND E.NATL_ECON_DEPT_CL LIKE 'E%' THEN 'SWIFT编码'
                WHEN TRIM(E.PBC_NO) IS NULL AND TRIM(E.FIN_PERMIT_NO) IS NOT NULL THEN '金融许可证号'
                ELSE TRIM(SUBSTRB(CODE.TAR_VALUE_NAME,1,60))
            END                          AS KHZJLB, --客户证件类别
           CASE WHEN D.CUST_ID IS NOT NULL THEN D.CRDL_NO_DESEN
                WHEN TRIM(E.PBC_NO) IS NOT NULL THEN TRIM(E.PBC_NO)
                WHEN TRIM(E.PBC_NO) IS NULL AND TRIM(E.FIN_PERMIT_NO) IS NOT NULL THEN TRIM(E.FIN_PERMIT_NO)
                ELSE TRIM(E.CRDL_NO)
            END                          AS KHZJHM, --客户证件号码
           A.SXXYH                       AS SXXYH, --授信协议号
           A.SXXYMC                      AS SXXYMC, --授信协议名称
           A.EDSQRQ                      AS EDSQRQ, --额度申请日期
           A.SXZTZL                      AS SXZTZL, --授信主体种类
           A.SXZL                        AS SXZL, --授信种类
           A.SXED                        AS SXED, --授信额度
           A.YYED                        AS YYED, --已用额度
           A.BZ                          AS BZ, --币种
           A.SXKSRQ                      AS SXKSRQ, --授信开始日期
           A.SXDQRQ                      AS SXDQRQ, --授信到期日期
           A.SXJCYJ                      AS SXJCYJ, --授信审批意见
           A.SPRGH                       AS SPRGH, --审批人工号
           A.JBRGH                       AS JBRGH, --经办人工号
           '无效'                        AS SXZT, --授信状态
           A.BBZ                         AS BBZ, --备注
           V_MONTH_END_DATEID            AS CJRQ, --采集日期
           A.DEPT_NO                     AS DEPT_NO, --部门编号
           A.SRC_SYS_ID                  AS SRC_SYS_ID, --来源系统ID
           A.ISSUED_NO                   AS ISSUED_NO, --填报机构
           A.ORG_NO                      AS ORG_NO, --报送机构
           A.ADDRESS                     AS ADDRESS, --归属地
           CASE WHEN D.CUST_ID IS NOT NULL THEN D.CUST_NM
                WHEN REGEXP_REPLACE(TRIM(E.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(E.CUST_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(E.CUST_NM)
            END                          AS KHMC_ORIG, --客户名称（脱敏前）
           CASE WHEN D.CUST_ID IS NOT NULL THEN D.CRDL_NO
                WHEN TRIM(E.PBC_NO) IS NOT NULL THEN TRIM(E.PBC_NO)
                WHEN TRIM(E.PBC_NO) IS NULL AND TRIM(E.FIN_PERMIT_NO) IS NOT NULL THEN TRIM(E.FIN_PERMIT_NO)
                ELSE TRIM(E.CRDL_NO)
            END                          AS KHZJHM_ORIG,--客户证件号码（脱敏前）
           A.KHMC_OTH                    AS KHMC_OTH,--客户名称（是否个人客户）
           A.DKCPMC                      AS DKCPMC, --贷款产品名称 只用来区分行内外产品
           A.GSFZJG                      AS GSFZJG, --归属分支机构
           A.KHLX                        AS KHLX  --客户类型
      FROM RRP_EAST.EAST5_701_SXXXB A
      LEFT JOIN RRP_EAST.EAST5_701_SXXXB B
        ON B.SXXYH = A.SXXYH
       AND B.CJRQ = V_MONTH_END_DATEID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST C --机构表
        ON C.ORG_ID = A.NBJGH
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_EAST.M_CUST_IND_INFO_EAST D --个人客户信息
        ON D.CUST_ID = A.KHTYBH
       AND D.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_CUST_CORP_INFO E --对公客户信息
        ON E.CUST_ID = A.KHTYBH
       AND E.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表 --客户证件类别
        ON CODE.SRC_VALUE_CODE = NVL(D.CRDL_TYP,E.CRDL_TYP)
       AND CODE.SRC_CLASS_CODE = 'C0001'
       AND CODE.TAR_CLASS_CODE = 'C0001'
       AND CODE.MOD_FLG = 'EAST'
     WHERE B.SXXYH IS NULL
       AND A.SXZT = '有效'
       AND A.CJRQ = TO_CHAR(TRUNC(TO_DATE(V_MONTH_END_DATEID,'YYYYMMDD'),'MM') - 1,'YYYYMMDD');

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
    SELECT CJRQ,SXXYH,COUNT(1)
      FROM RRP_EAST.EAST5_701_SXXXB T
     WHERE CJRQ = V_P_DATE
     GROUP BY CJRQ,SXXYH
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_SQLMSG  := 'EAST5_701_SXXXB(CJRQ,SXXYH)数据重复';
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

END ETL_EAST5_701_SXXXB;
/

