CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_106_GDJGLFXXB(I_P_DATE IN INTEGER, --跑批日期
                                                    O_ERRCODE OUT VARCHAR2 --错误代码
                                                    )
/***********************************************************************
  **  存储过程详细说明：股东及关联方信息表
  **  存储过程名称:  ETL_EAST5_106_GDJGLFXXB
  **  存储过程创建日期:2022-03-07
  **  存储过程创建人:蔡正伟
  **  输入参数:   I_P_DATE
  **  输出参数:   O_ERRCODE
  **  返回值:     O_ERRCODE
  **  修改日期          修改项目        修改原因           修改人
  **
 ***********************************************************************/
IS
  V_P_DATE           VARCHAR2(8);         --数据日期
  V_MONTH_END_DATEID VARCHAR2(8);         --本月月底日期
  V_PARTITION_NAME   VARCHAR2(100);       --分区名称
  V_FREQ_FLAG        VARCHAR2(10);        --跑批频度
  V_STEP             INTEGER := 0;        --任务号
  V_STARTTIME        DATE := SYSDATE;     --处理开始时间
  V_ENDTIME          DATE;                --处理结束时间
  V_SQLCOUNT         INTEGER := 0;        --更新或删除影响的记录数
  V_SQLMSG           VARCHAR2(300);       --SQL执行描述信息
  V_STEP_DESC        VARCHAR2(100);       --处理步骤描述
  V_TABLE_NAME       VARCHAR2(100) := 'EAST5_106_GDJGLFXXB'; --表名称
  V_PROC_NAME        VARCHAR2(100) := 'ETL_EAST5_106_GDJGLFXXB'; --存储过程名称
BEGIN
  --将参数转化为日期格式，判读输入参数是否符合日期要求
  O_ERRCODE := '0';
  V_P_DATE  := TO_CHAR(I_P_DATE);
  V_MONTH_END_DATEID := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD');
  V_PARTITION_NAME   := 'PARTITION_' || V_P_DATE;
  V_FREQ_FLAG        := RRP_EAST.FUN_FREQ(I_P_DATE,V_PROC_NAME);

  --判断跑批频度
  IF V_FREQ_FLAG = '1' THEN

    /*增加分区*/
    V_STEP      := V_STEP + 1;
    V_STEP_DESC := '删除当日分区数据';
    V_STARTTIME := SYSDATE;
    --删除当日分区数据
    RRP_EAST.ETL_PARTITION_ADD(V_P_DATE,V_TABLE_NAME,1,O_ERRCODE);
    RRP_EAST.ETL_PARTITION_TRUNCATE(V_P_DATE,V_TABLE_NAME,O_ERRCODE);
    EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_EAST.EAST5_106_GDJGLFXXB_TMP';

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --程序业务逻辑处理主体部分
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '插入股东及关联方信息表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_106_GDJGLFXXB_TMP(
      RID,              --数据主键
      JRXKZH,           --金融许可证号
      NBJGH,            --内部机构号
      YHJGMC,           --银行机构名称
      KHTYBH,           --客户统一编号
      GDHGLFMC,         --股东或关联方名称
      GDHGLFLX,         --股东或关联方类型
      GDHGLFZJLB,       --股东或关联方证件类别
      GDHGLFZJHM,       --股东或关联方证件号码
      SSHY,             --股东或关联方所属行业
      ZCD,              --股东或关联方注册地
      GXLX,             --关系类型
      SJKZR,            --实际控制人
      CGSYYHSL,         --参股商业银行的数量
      KGSL,             --控股商业银行的数量
      BLXX,             --不良信息
      SFXQ,             --是否限权
      RGZJLY,           --入股资金来源
      RGZJZH,           --入股资金账号
      CGSL,             --持股数量
      CGBL,             --持股比例
      RGRQ,             --入股日期
      ZYBL,             --质押比例
      SFZPDJS,          --是否驻派董监事
      GDHGLFZT,         --股东或关联方状态
      ZJYCBDRQ,         --最近一次变动日期
      BBZ,              --备注
      CJRQ,             --采集日期
      DEPT_NO,          --部门编号
      ADDRESS,          --归属地
      SRC_SYS_ID,       --来源系统ID
      ISSUED_NO,        --填报机构
      ORG_NO,           --报送机构
      GDHGLFMC_ORIG,    --股东或关联方名称（脱敏前）
      GDHGLFZJHM_ORIG,  --股东或关联方证件号码（脱敏前）
      GSFZJG,           --归属分支机构
      RNM               --序号
      )
    SELECT SYS_GUID()                                       AS RID,              --数据主键
           B.FIN_PERMIT_NO                                  AS JRXKZH,           --金融许可证号
           --A.ORG_ID                                         AS NBJGH,            --内部机构号
           B.ORG_ID                                         AS NBJGH,            --内部机构号
           B.ORG_NM                                         AS YHJGMC,           --银行机构名称
           A.CUST_ID                                        AS KHTYBH,           --客户统一编号
           CASE WHEN A.SHRH_AF_PARTY_TYP NOT IN ('0','1') THEN TRIM(A.SHRH_AF_PARTY_NM) --ADD BY LIP 20240625
                WHEN A.SHRH_AF_PARTY_CRDL_TYP LIKE '1%' OR A.SHRH_AF_PARTY_TYP IN ('0','1') THEN
                /*SUBSTRB(A.SHRH_AF_PARTY_NM,LENGTHB(A.SHRH_AF_PARTY_NM) - 2,3)*/
                TRIM(RRP_EAST.FUN_DESENSITIZATION(REGEXP_REPLACE(A.SHRH_AF_PARTY_NM,'[[:punct:]]',''),0))--考虑不同字符集，截取方式不同
                ELSE TRIM(A.SHRH_AF_PARTY_NM)
            END                                             AS GDHGLFMC,        --股东或关联方名称
           CODE.TAR_VALUE_NAME                              AS GDHGLFLX,        --股东或关联方类型
           --TRIM(SUBSTRB(CODE1.TAR_VALUE_NAME,1,40))         AS GDHGLFZJLB,      --股东或关联方证件类别  --MOD BY LIP 20221229
           TRIM(SUBSTRB(CODE1.TAR_VALUE_NAME,1,60))         AS GDHGLFZJLB,      --股东或关联方证件类别 --MODIFY BY LIP 20240409 改为UTF-8的长度
           CASE /*WHEN TRIM(C.PBC_NO) IS NOT NULL THEN TRIM(C.PBC_NO)
                WHEN TRIM(C.PBC_NO) IS NULL AND C.FIN_PERMIT_NO IS NOT NULL THEN C.FIN_PERMIT_NO*/
                WHEN A.SHRH_AF_PARTY_TYP NOT IN ('0','1') THEN A.SHRH_AF_PARTY_CRDL_NO --ADD BY LIP 20240625
                WHEN A.SHRH_AF_PARTY_CRDL_TYP LIKE '1%' THEN
                 --MOD BY LIP 20240909 调整取身份证件号码UTF-8编码的前6个字节的取数口径
                 CASE WHEN LENGTHB(TRIM(SUBSTRB(A.SHRH_AF_PARTY_CRDL_NO,1,6))) = 6 THEN TRIM(SUBSTRB(A.SHRH_AF_PARTY_CRDL_NO,1,6))
                      WHEN LENGTHB(TRIM(SUBSTRB(A.SHRH_AF_PARTY_CRDL_NO,1,6))) = 5 THEN '0'||TRIM(SUBSTRB(A.SHRH_AF_PARTY_CRDL_NO,1,6))
                      WHEN LENGTHB(TRIM(SUBSTRB(A.SHRH_AF_PARTY_CRDL_NO,1,6))) = 4 THEN '00'||TRIM(SUBSTRB(A.SHRH_AF_PARTY_CRDL_NO,1,6))
                      WHEN LENGTHB(TRIM(SUBSTRB(A.SHRH_AF_PARTY_CRDL_NO,1,6))) = 3 THEN '000'||TRIM(SUBSTRB(A.SHRH_AF_PARTY_CRDL_NO,1,6))
                      WHEN LENGTHB(TRIM(SUBSTRB(A.SHRH_AF_PARTY_CRDL_NO,1,6))) = 2 THEN '0000'||TRIM(SUBSTRB(A.SHRH_AF_PARTY_CRDL_NO,1,6))
                      WHEN LENGTHB(TRIM(SUBSTRB(A.SHRH_AF_PARTY_CRDL_NO,1,6))) = 1 THEN '00000'||TRIM(SUBSTRB(A.SHRH_AF_PARTY_CRDL_NO,1,6))
                      WHEN LENGTHB(TRIM(SUBSTRB(A.SHRH_AF_PARTY_CRDL_NO,1,6))) = 0 THEN '000000'||TRIM(SUBSTRB(A.SHRH_AF_PARTY_CRDL_NO,1,6))
                  END||RRP_EAST.SM3_ENCRYPT(RRP_EAST.FUN_DESENSITIZATION(REGEXP_REPLACE(A.SHRH_AF_PARTY_NM,'[[:punct:]]',''),1)||
                 UPPER(A.SHRH_AF_PARTY_CRDL_NO))
                ELSE A.SHRH_AF_PARTY_CRDL_NO
            END                                             AS GDHGLFZJHM,      --股东或关联方证件号码
           TRIM(A.SHRH_AF_PARTY_BLNG_IDY)                   AS SSHY,            --股东或关联方所属行业
           --TRIM(A.SHRH_AF_PARTY_REGD_LAND)                  AS ZCD,             --股东或关联方注册地
           --MOD BY LIP 20250623 数仓扩长后，对字段进行截取
           TRIM(SUBSTRB(A.SHRH_AF_PARTY_REGD_LAND,1,600))   AS ZCD,             --股东或关联方注册地
           --CODE5.TAR_VALUE_NAME                             AS GXLX,            --关系类型
           A.REL_TYP                                        AS GXLX,            --关系类型 --TANQ 20230214
           A.ACT_CNTLR                                      AS SJKZR,           --实际控制人
           A.BANK_ATND_SHR_NUM                              AS CGSYYHSL,        --参股商业银行的数量
           A.BANK_HLDG_SHR_NUM                              AS KGSL,            --控股商业银行的数量
           A.BAD_INFO                                       AS BLXX,            --不良信息
           CODE2.TAR_VALUE_NAME                             AS SFXQ,            --是否限权
           --A.SHR_IN_CPTL_SRC                                AS RGZJLY,          --入股资金来源
           CASE WHEN A.SHR_IN_CPTL_SRC = '0' THEN '自有资金'
                WHEN A.SHR_IN_CPTL_SRC = '1' THEN '委托资金'
                WHEN A.SHR_IN_CPTL_SRC = '2' THEN '债务资金'
                WHEN A.SHR_IN_CPTL_SRC = '3' THEN '其他-债转股'
            END                                             AS RGZJLY,          --入股资金来源
           --A.SHR_IN_CPTL_ACC                                AS RGZJZH,          --入股资金账号
           --MOD BY LIP 20240402 该列如为空，请转为“无”
           CASE WHEN TRIM(A.SHR_IN_CPTL_ACC) IS NOT NULL THEN TRIM(A.SHR_IN_CPTL_ACC)
                WHEN A.REL_TYP = '1' THEN '无'
            END                                             AS RGZJZH,          --入股资金账号
           /*A.HOLD_SHR_NUM                                   AS CGSL,            --持股数量
           A.HOLD_SHR_PCT                                   AS CGBL,            --持股比例*/
           --MOD BY LIP 20250811 业务说如果失效了，那持股数量跟比例都为0了
           CASE WHEN A.REL_TYP = '1' AND A.DATA_DT < V_P_DATE THEN 0
                ELSE A.HOLD_SHR_NUM
            END                                             AS CGSL,            --持股数量
           CASE WHEN A.REL_TYP = '1' AND A.DATA_DT < V_P_DATE THEN 0
                ELSE A.HOLD_SHR_PCT
            END                                             AS CGBL,            --持股比例
           /*NVL(A.SHR_IN_DT,'20110831')                      AS RGRQ,            --入股日期 --MODIFY 20230223 LHQ 根据业务林伟安要求为空的入股日期默认为20110831
           NVL(A.ALDY_PLG_HOLD_SHR_PCT,'0.000000')          AS ZYBL,            --质押比例*/
           CASE WHEN TRIM(A.SHR_IN_DT) IS NOT NULL THEN TRIM(A.SHR_IN_DT)
                WHEN A.REL_TYP = '1' THEN '20110831'
            END                                             AS RGRQ,            --入股日期
           NVL(A.ALDY_PLG_HOLD_SHR_PCT,'0.000000')          AS ZYBL,            --质押比例
           --CODE3.TAR_VALUE_NAME                             AS SFZPDJS,         --是否驻派董监事
           CASE WHEN A.STN_DIR_FLG = '1' THEN '是'
                WHEN A.STN_DIR_FLG = '2' THEN '否'
            END                                             AS SFZPDJS,         --是否驻派董监事
           --CODE4.TAR_VALUE_NAME                             AS GDHGLFZT,        --股东或关联方状态
           --MOD BY LIP 20250715 当取到的是之前的数据时，状态改成无效
           CASE WHEN A.DATA_DT < V_P_DATE THEN '无效'
                ELSE CODE4.TAR_VALUE_NAME
            END                                             AS GDHGLFZT,        --股东或关联方状态
           --NVL(A.LAST_CHG_DT,'99991231')                    AS ZJYCBDRQ,        --最近一次变动日期
           --MOD BY LIP 20250812 当取到的数据是失效数据时，将失效数据的下一天当成变动日期
           CASE WHEN A.DATA_DT < V_P_DATE THEN TO_CHAR(TO_DATE(A.DATA_DT,'YYYYMMDD')+1,'YYYYMMDD')
                ELSE NVL(A.LAST_CHG_DT,'99991231')
            END                                             AS ZJYCBDRQ,        --最近一次变动日期
           --''                                               AS BBZ,             --备注
           --ADD BY LIP 增加股东部分的备注数据
           --TRIM(SUBSTRB(A.EAST_REMARK,1,400))               AS BBZ,             --备注
           TRIM(SUBSTRB(A.EAST_REMARK,1,600))               AS BBZ,             --备注 --MODIFY BY LIP 20240409 改为UTF-8的长度
           V_MONTH_END_DATEID                               AS CJRQ,            --采集日期
           '000'                                            AS DEPT_NO,         --部门编号
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                             AS ADDRESS,         --归属地
           '01'                                             AS SRC_SYS_ID,      --来源系统ID
           --A.DEPT_LINE                                      AS ISSUED_NO,       --填报机构
           '000000'                                         AS ISSUED_NO,       --填报机构
           ORG.ORG_ID_LEL_0                                 AS ORG_NO,          --报送机构
           A.SHRH_AF_PARTY_NM                               AS GDHGLFMC_ORIG,   --股东或关联方名称（脱敏前）
           A.SHRH_AF_PARTY_CRDL_NO                          AS GDHGLFZJHM_ORIG, --股东或关联方证件号码（脱敏前） --MOD BY LIP 20240725
           '9999'                                           AS GSFZJG,          --归属分支机构 --ADD BY LIP 20220628
           /*ROW_NUMBER() OVER(PARTITION BY A.REL_TYP,A.SHRH_AF_PARTY_NM,A.SHRH_AF_PARTY_CRDL_NO,TRIM(SUBSTRB(CODE1.TAR_VALUE_NAME,1,60))
                             ORDER BY A.DATA_DT DESC)       AS RNM              --序号 --ADD BY LIP 20250715*/
           ROW_NUMBER() OVER(PARTITION BY A.SHRH_AF_PARTY_ID ORDER BY A.DATA_DT DESC) AS RNM --序号 --ADD BY LIP 20250903
      FROM RRP_MDL.M_OTH_SHRH_INFO A --股东及关联方信息表
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(M.ORG_ID1,'800')
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = A.SHRH_AF_PARTY_TYP
       AND CODE.SRC_CLASS_CODE = 'C0054' --股东或关联方类型
       AND CODE.TAR_CLASS_CODE = 'C0054' --股东或关联方类型
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = A.SHRH_CRDL_TYP /*A.SHRH_AF_PARTY_CRDL_TYP*/
       AND CODE1.SRC_CLASS_CODE = 'C0001' --证件类型
       AND CODE1.TAR_CLASS_CODE = 'C0001'
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE2 --码值配置表
        ON CODE2.SRC_VALUE_CODE = A.LIMIT_WGHT_FLG
       AND CODE2.SRC_CLASS_CODE = 'Z0001'
       AND CODE2.TAR_CLASS_CODE = 'Z0001'
       AND CODE2.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE4 --码值配置表
        ON CODE4.SRC_VALUE_CODE = A.SHRH_AF_PARTY_STAT
       AND CODE4.SRC_CLASS_CODE = 'Z0002'
       AND CODE4.TAR_CLASS_CODE = 'Z0002'
       AND CODE4.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = B.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON 1 = 1
       AND UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE (A.SHRH_AF_PARTY_STAT IN ('1','Y') OR (A.CHG_DT >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')-1,'YYYYMMDD')))
       AND (A.DATA_SRC IN ('关联方') OR A.HOLD_SHR_NUM <> '0')--业务要求 持股数为0不采集 --暂时不取OA系统数据
       --AND A.DATA_DT = V_P_DATE;
       --MOD BY LIP 20250715 因数仓关联方只有当天有效的数据，所以取整月数据
       --AND A.DATA_DT >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD')
       AND A.DATA_DT >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')-1,'YYYYMMDD') --MOD BY LIP 20260416
       AND A.DATA_DT <= V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP    := V_STEP + 1;
    V_STEP_DESC := '股东及关联方信息表--插入目标表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_106_GDJGLFXXB(
      RID,              --数据主键
      JRXKZH,           --金融许可证号
      NBJGH,            --内部机构号
      YHJGMC,           --银行机构名称
      KHTYBH,           --客户统一编号
      GDHGLFMC,         --股东或关联方名称
      GDHGLFLX,         --股东或关联方类型
      GDHGLFZJLB,       --股东或关联方证件类别
      GDHGLFZJHM,       --股东或关联方证件号码
      SSHY,             --股东或关联方所属行业
      ZCD,              --股东或关联方注册地
      GXLX,             --关系类型
      SJKZR,            --实际控制人
      CGSYYHSL,         --参股商业银行的数量
      KGSL,             --控股商业银行的数量
      BLXX,             --不良信息
      SFXQ,             --是否限权
      RGZJLY,           --入股资金来源
      RGZJZH,           --入股资金账号
      CGSL,             --持股数量
      CGBL,             --持股比例
      RGRQ,             --入股日期
      ZYBL,             --质押比例
      SFZPDJS,          --是否驻派董监事
      GDHGLFZT,         --股东或关联方状态
      ZJYCBDRQ,         --最近一次变动日期
      BBZ,              --备注
      CJRQ,             --采集日期
      DEPT_NO,          --部门编号
      ADDRESS,          --归属地
      SRC_SYS_ID,       --来源系统ID
      ISSUED_NO,        --填报机构
      ORG_NO,           --报送机构
      GDHGLFMC_ORIG,    --股东或关联方名称（脱敏前）
      GDHGLFZJHM_ORIG,  --股东或关联方证件号码（脱敏前）
      GSFZJG            --归属分支机构
      )
    SELECT A.RID                                AS RID,              --数据主键
           A.JRXKZH                             AS JRXKZH,           --金融许可证号
           A.NBJGH                              AS NBJGH,            --内部机构号
           A.YHJGMC                             AS YHJGMC,           --银行机构名称
           A.KHTYBH                             AS KHTYBH,           --客户统一编号
           A.GDHGLFMC                           AS GDHGLFMC,         --股东或关联方名称
           A.GDHGLFLX                           AS GDHGLFLX,         --股东或关联方类型
           A.GDHGLFZJLB                         AS GDHGLFZJLB,       --股东或关联方证件类别
           A.GDHGLFZJHM                         AS GDHGLFZJHM,       --股东或关联方证件号码
           TRIM(A.SSHY)                         AS SSHY,             --股东或关联方所属行业
           TRIM(A.ZCD)                          AS ZCD,              --股东或关联方注册地
           A.GXLX                               AS GXLX,             --关系类型
           A.SJKZR                              AS SJKZR,            --实际控制人
           A.CGSYYHSL                           AS CGSYYHSL,         --参股商业银行的数量
           A.KGSL                               AS KGSL,             --控股商业银行的数量
           A.BLXX                               AS BLXX,             --不良信息
           A.SFXQ                               AS SFXQ,             --是否限权
           A.RGZJLY                             AS RGZJLY,           --入股资金来源
           A.RGZJZH                             AS RGZJZH,           --入股资金账号
           A.CGSL                               AS CGSL,             --持股数量
           A.CGBL                               AS CGBL,             --持股比例
           A.RGRQ                               AS RGRQ,             --入股日期
           A.ZYBL                               AS ZYBL,             --质押比例
           A.SFZPDJS                            AS SFZPDJS,          --是否驻派董监事
           A.GDHGLFZT                           AS GDHGLFZT,         --股东或关联方状态
           A.ZJYCBDRQ                           AS ZJYCBDRQ,         --最近一次变动日期
           A.BBZ                                AS BBZ,              --备注
           A.CJRQ                               AS CJRQ,             --采集日期
           A.DEPT_NO                            AS DEPT_NO,          --部门编号
           A.ADDRESS                            AS ADDRESS,          --归属地
           A.SRC_SYS_ID                         AS SRC_SYS_ID,       --来源系统ID
           --A.ISSUED_NO                          AS ISSUED_NO,        --填报机构
           '000000'                             AS ISSUED_NO,        --填报机构
           A.ORG_NO                             AS ORG_NO,           --报送机构
           A.GDHGLFMC_ORIG                      AS GDHGLFMC_ORIG,    --股东或关联方名称（脱敏前）
           A.GDHGLFZJHM_ORIG                    AS GDHGLFZJHM_ORIG,  --股东或关联方证件号码（脱敏前）
           '9999'                               AS GSFZJG            --归属分支机构
      FROM RRP_EAST.EAST5_106_GDJGLFXXB_TMP A --股东及关联方信息表
     WHERE A.RNM = 1 --ADD BY LIP 20250715
       AND A.CJRQ = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --表分析
    V_STEP := '4';
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

  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '跑批结束';
  V_STARTTIME := SYSDATE;
  --在过程跑批完成记录表中插入记录，调度查询该表判断过程是是否跑批完成
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
    O_ERRCODE := '1'; --将SQL错误编号赋植给O_ERRCODE
    V_SQLMSG  := '跑批错误：['||SQLCODE||'],描述信息：'||SQLERRM;
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_EAST5_106_GDJGLFXXB;
/

