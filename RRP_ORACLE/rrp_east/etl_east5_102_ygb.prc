CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_102_YGB(I_P_DATE IN INTEGER, --跑批日期
                                              O_ERRCODE OUT VARCHAR2 --错误代码
                                              )
  /***********************************************************************
    **  存储过程详细说明：员工表
    **  存储过程名称:  ETL_EAST5_102_YGB
    **  存储过程创建日期:2022-03-07
    **  存储过程创建人:蔡正伟

    **  输入参数:   I_P_DATE
    **  输出参数:   O_ERRCODE
    **  返回值:     O_ERRCODE
    **  修改日期    修改项目         修改人      修改原因
    **  20220628   华兴银行监管      LIP        修改日志记录格式，修改字段超长、字段换行问题
    **  20220628   华兴银行监管      LIP        增加99900130员工
    *************************************************************************/
IS
  V_P_DATE           VARCHAR2(8);      --数据日期
  V_MONTH_END_DATEID VARCHAR2(8);      --本月月底日期
  V_PARTITION_NAME   VARCHAR2(100);    --分区名称
  V_FREQ_FLAG        VARCHAR2(10);     --跑批频度
  V_STEP             INTEGER := '1';   --任务号
  V_STARTTIME        DATE;             --处理开始时间
  V_ENDTIME          DATE;             --处理结束时间
  V_SQLCOUNT         INTEGER := 0;     --更新或删除影响的记录数
  V_SQLMSG           VARCHAR2(300);    --SQL执行描述信息
  V_STEP_DESC        VARCHAR2(100);    --处理步骤描述
  V_PROC_NAME        VARCHAR2(100) := 'ETL_EAST5_102_YGB'; --存储过程名称
  V_TABLE_NAME       VARCHAR2(100) := 'EAST5_102_YGB'; --表名称
BEGIN
  V_P_DATE  := TO_CHAR(I_P_DATE);
  O_ERRCODE := '0';
  V_MONTH_END_DATEID := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD');
  V_PARTITION_NAME   := 'PARTITION_' || V_P_DATE;
  V_FREQ_FLAG        := RRP_EAST.FUN_FREQ(I_P_DATE,V_PROC_NAME);

  --判断跑批频度
  IF V_FREQ_FLAG = '1' THEN

    V_STEP := 1;
    V_STEP_DESC := '清理分区数据';
    V_STARTTIME := SYSDATE;
    --删除当日分区数据
    RRP_EAST.ETL_PARTITION_ADD(V_P_DATE, V_TABLE_NAME, 1, O_ERRCODE);
    RRP_EAST.ETL_PARTITION_TRUNCATE(V_P_DATE, V_TABLE_NAME, O_ERRCODE);
    --DELETE FROM RRP_EAST.EAST5_102_YGB WHERE CJRQ = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := SQLCODE;
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --程序业务逻辑处理主体部分
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '插入员工表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_102_YGB(
      RID,         --数据主键
      JRXKZH,      --金融许可证号
      NBJGH,       --内部机构号
      YHJGMC,      --银行机构名称
      GH,          --工号
      XM,          --姓名
      GJHDQ,       --国家或地区
      ZJLB,        --证件类别
      ZJHM,        --证件号码
      LXDH,        --联系电话
      SSBM,        --所属部门
      GWBH,        --岗位编号
      GWMC,        --岗位名称
      SFGG,        --是否高管
      PFRQ,        --批复日期
      RZRQ,        --任职日期
      YGLX,        --员工类型
      YGZT,        --员工状态
      BBZ,         --备注
      CJRQ,        --采集日期
      ORG_NO,      --报送机构
      ISSUED_NO,   --填报机构
      DEPT_NO,     --部门编号
      SRC_SYS_ID,  --来源系统ID
      ADDRESS,     --归属地
      ZJHM_ORIG,   --证件号码（脱敏前）
      GSFZJG       --归属分支机构
      )
      --MODIFY BY LIP 20220823 当同一个证件对应多个员工时，优先取有效状态的员工
      WITH PUB_EMP_INFO AS (
    SELECT T.*,ROW_NUMBER() OVER(PARTITION BY CRDL_NO ORDER BY
              CASE WHEN T.EMP_STAT = '1' THEN 1 WHEN T.EMP_STAT = '2' THEN 2
                   ELSE 5
               --END ASC,ASSIGN_DT DESC
               END ASC,POST_DT DESC) RN --MOD BY LIP 20260316 按照员工的上岗日期排序
      FROM RRP_MDL.M_PUM_EMP_INFO T
     WHERE T.DATA_DT = V_P_DATE)
    SELECT SYS_GUID()                                         AS RID,         --数据主键
           TRIM(B.FIN_PERMIT_NO)                              AS JRXKZH,      --金融许可证号
           B.ORG_ID                                           AS NBJGH,       --内部机构号
           B.ORG_NM                                           AS YHJGMC,      --银行机构名称
           A.EMP_ID                                           AS GH,          --工号
           A.EMP_NM                                           AS XM,          --姓名
           CODE.TAR_VALUE_NAME                                AS GJHDQ,       --国家或地区
           --CODE1.TAR_VALUE_NAME                               AS ZJLB,        --证件类别
           --TRIM(SUBSTRB(CODE1.TAR_VALUE_NAME,1,40))           AS ZJLB,        --证件类别 --MODIFY BY LIP 20220628
           TRIM(SUBSTRB(CODE1.TAR_VALUE_NAME,1,60))           AS ZJLB,        --证件类别 --MODIFY BY LIP 20240409 改为UTF-8的长度
           /*LPAD(A.CRDL_NO,6,'0')||
           SM3_ENCRYPT(FUN_DESENSITIZATION(A.EMP_NM,1) || UPPER(A.CRDL_NO)) AS ZJHM, --证件号码*/
           /*CASE WHEN REGEXP_REPLACE(LPAD(A.CRDL_NO,6,'0'),'[0-9a-zA-Z]','') IS NULL
                THEN LPAD(A.CRDL_NO,6,'0')
                WHEN LENGTHB(TRIM(SUBSTRB(A.CRDL_NO,1,5))) = LENGTH(TRIM(SUBSTRB(A.CRDL_NO,1,5))) + 1
                THEN LPAD(TRIM(SUBSTRB(A.CRDL_NO,1,5)),5,'0')
                WHEN LENGTHB(TRIM(SUBSTRB(A.CRDL_NO,1,4))) = LENGTH(TRIM(SUBSTRB(A.CRDL_NO,1,4))) + 2
                THEN LPAD(TRIM(SUBSTRB(A.CRDL_NO,1,4)),4,'0')
            END||*/
           --MOD BY LIP 20240909 调整取身份证件号码UTF-8编码的前6个字节的取数口径
           CASE WHEN LENGTHB(TRIM(SUBSTRB(A.CRDL_NO,1,6))) = 6 THEN TRIM(SUBSTRB(A.CRDL_NO,1,6))
                WHEN LENGTHB(TRIM(SUBSTRB(A.CRDL_NO,1,6))) = 5 THEN '0'||TRIM(SUBSTRB(A.CRDL_NO,1,6))
                WHEN LENGTHB(TRIM(SUBSTRB(A.CRDL_NO,1,6))) = 4 THEN '00'||TRIM(SUBSTRB(A.CRDL_NO,1,6))
                WHEN LENGTHB(TRIM(SUBSTRB(A.CRDL_NO,1,6))) = 3 THEN '000'||TRIM(SUBSTRB(A.CRDL_NO,1,6))
                WHEN LENGTHB(TRIM(SUBSTRB(A.CRDL_NO,1,6))) = 2 THEN '0000'||TRIM(SUBSTRB(A.CRDL_NO,1,6))
                WHEN LENGTHB(TRIM(SUBSTRB(A.CRDL_NO,1,6))) = 1 THEN '00000'||TRIM(SUBSTRB(A.CRDL_NO,1,6))
                WHEN NVL(LENGTHB(TRIM(SUBSTRB(A.CRDL_NO,1,6))),0) = 0 THEN '000000'||TRIM(SUBSTRB(A.CRDL_NO,1,6))
            END||RRP_EAST.SM3_ENCRYPT(RRP_EAST.FUN_DESENSITIZATION(REGEXP_REPLACE(A.EMP_NM,'[[:punct:]]',''),1)||
              UPPER(A.CRDL_NO))                                 AS ZJHM,      --证件号码 --MODIFY BY LIP 20220628
           --TRIM(A.TEL)                                          AS LXDH,      --联系电话
           SUBSTRB(TRIM(A.TEL),1,70)                            AS LXDH,      --联系电话 --MOD BY LIP 20260106
           TRIM(A.BLNG_DEPT)                                    AS SSBM,      --所属部门
           --TRIM(A.POST_ID)                                      AS GWBH,      --岗位编号
           --TRIM(REPLACE(REPLACE(C.POST_NM,CHR(10),''),CHR(13),'')) AS GWMC, --岗位名称
           /*SUBSTRB(TRIM(REPLACE(REPLACE(A.POST_ID,CHR(10),''),CHR(13),'')),1,40) AS GWBH, --岗位编号
           SUBSTRB(TRIM(REPLACE(REPLACE(C.POST_NM,CHR(10),''),CHR(13),'')),1,100) AS GWMC, --岗位名称*/
           --SUBSTRB(TRIM(REPLACE(REPLACE(A.POST_ID,CHR(10),''),CHR(13),'')),1,60) AS GWBH, --岗位编号 --MODIFY BY LIP 20240409 根据业务要求，岗位改为取统一用户的职位
           SUBSTRB(TRIM(REPLACE(REPLACE(A.POST_ID_EAST,CHR(10),''),CHR(13),'')),1,60) AS GWBH, --岗位编号 --MODIFY BY LIP 20251016 改为UTF-8的长度
           SUBSTRB(TRIM(REPLACE(REPLACE(C.POST_NM,CHR(10),''),CHR(13),'')),1,150) AS GWMC, --岗位名称 --MODIFY BY LIP 20240409 改为UTF-8的长度
           NVL(CODE2.TAR_VALUE_NAME,'否')                       AS SFGG,       --是否高管
           NVL(A.APP_DT,'99991231')                             AS PFRQ,      --批复日期
           NVL(A.ASSIGN_DT,'99991231')                          AS RZRQ,      --任职日期
           CODE3.TAR_VALUE_NAME                                 AS YGLX,      --员工类型
           /*CASE WHEN A.EMP_STAT IN ('02','04') THEN '在岗'
                WHEN A.EMP_STAT IN ('01','03') THEN '离职'
                WHEN A.EMP_STAT IN ('09') THEN '离岗'
                ELSE '其他-' || REPLACE(CODE4.TAR_VALUE_NAME,'其他-','')
             END                                              AS YGZT,        --员工状态*/
            /*CASE WHEN A.EMP_STAT = '1' AND A.EMP_TYPE NOT IN ('3','5') THEN '在岗'
                 WHEN A.EMP_STAT = '1' AND A.EMP_TYPE IN ('3','5') THEN '在岗'
                 WHEN A.EMP_STAT = '2' AND A.EMP_TYPE NOT IN ('3','5') THEN '离职'
                 WHEN A.EMP_STAT = '2' AND A.EMP_TYPE IN ('3','5') THEN '离职'
             END                                              AS YGZT,        --员工状态*/
           /*CASE WHEN A.EMP_STAT = '1' THEN '在岗'
                WHEN A.EMP_STAT = '2' THEN '离职'
            END                                               AS YGZT,        --员工状态 modify by tangan at 20221228*/
           CASE WHEN A.EMP_STAT = '1' THEN '在岗'
                WHEN A.EMP_STAT = '2' THEN '离职'
                --ADD BY LIP 20240607
                --“1-离职审批中（在岗）”、“2-离职审批中（不在岗）”、“3-离职审批完成”
                WHEN A.DIMISSION_STATUS_CD = '1' THEN '在岗'
                WHEN A.DIMISSION_STATUS_CD = '2' THEN '离岗'
                ELSE '其他-' || REPLACE(CODE4.TAR_VALUE_NAME,'其他-','')
            END                                               AS YGZT,        --员工状态 modify by tangan at 20221228
           ''                                                 AS BBZ,         --备注
           V_MONTH_END_DATEID                                 AS CJRQ,        --采集日期
           ORG.ORG_ID_LEL_0                                   AS ORG_NO,      --报送机构
           '000000'                                           AS ISSUED_NO,   --填报机构
           '000'                                              AS DEPT_NO,     --部门编号
           '01'                                               AS SRC_SYS_ID,  --来源系统ID
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                               AS ADDRESS,     --归属地
           A.CRDL_NO                                          AS ZJHM_ORIG,   --证件号码（脱敏前）
           '9999'                                             AS GSFZJG       --归属分支机构
      /*FROM RRP_MDL.M_PUM_EMP_INFO A --员工表*/
      FROM PUB_EMP_INFO A --员工表
      LEFT JOIN RRP_MDL.ORG_CONFIG TB --机构映射表
        ON TB.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(TB.ORG_ID1,'800')
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_PUM_EMP_POST C --岗位表
        --ON C.POST_ID = A.POST_ID
        ON C.POST_ID = A.POST_ID_EAST --MOD BY LIP 20251016 根据业务要求，岗位改为取统一用户的职位
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = A.CTRY_CD
       AND CODE.SRC_CLASS_CODE = 'P0001'
       AND CODE.TAR_CLASS_CODE = 'P0001'
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = A.CRDL_TYP
       AND CODE1.SRC_CLASS_CODE = 'C0001'
       AND CODE1.TAR_CLASS_CODE = 'C0001'
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE2 --码值配置表
        ON CODE2.SRC_VALUE_CODE = A.SENIOR_FLG
       AND CODE2.SRC_CLASS_CODE = 'Z0001'
       AND CODE2.TAR_CLASS_CODE = 'Z0001'
       AND CODE2.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE3 --码值配置表
        ON CODE3.SRC_VALUE_CODE = A.EMP_TYP
       AND CODE3.SRC_CLASS_CODE = 'Z0021'
       AND CODE3.TAR_CLASS_CODE = 'Z0021'
       AND CODE3.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE4 --码值配置表
        ON CODE4.SRC_VALUE_CODE = A.EMP_STAT
       AND CODE4.SRC_CLASS_CODE = 'CD1596'
       AND CODE4.TAR_CLASS_CODE = 'C0049'
       AND CODE4.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = B.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE A.RN = 1
       AND (A.EMP_TYPE IN ('0','1','3') --MOD BY LIP 20230613 根据冯年欢口径，只报送正式和劳务派遣员工
            OR TRIM(A.EMP_ID) IN ('99900024','99900034','99900027','99900025','99900011','99900001','99900041','99900037','99900028',
               '99900031','99900017','99900022','99900042','99900061','99900062','99900130')) --MOD BY LIP 20230810 志豪跟业务后，确认该部分柜员继续报送
       AND A.DATA_DT = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := SQLCODE;
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --表分析
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '表分析';
    V_STARTTIME := SYSDATE;
    RRP_EAST.ETL_DBMS_STATS(V_P_DATE, V_TABLE_NAME, V_PARTITION_NAME, O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '跑批正确：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := SQLCODE;
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  END IF;

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '跑批结束';
  V_STARTTIME := SYSDATE;
  --在过程跑批完成记录表中插入记录，调度查询该表判断过程是是否跑批完成
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '跑批正确：['||SQLCODE||'],描述信息：'||SQLERRM;
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

END ETL_EAST5_102_YGB;
/

