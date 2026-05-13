CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_103_GYB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/***********************************************************************
  **  存储过程详细说明：柜员表
  **  存储过程名称:  ETL_EAST5_103_GYB
  **  存储过程创建日期:2022-03-07
  **  存储过程创建人:蔡正伟
  **  输入参数:   I_P_DATE
  **  输出参数:   O_ERRCODE
  **  返回值:     O_ERRCODE
  **  修改日期  修改人     修改原因
  **  20220609  蔡正伟     剔除非营运柜员数据
  **  20220628  LIP        修改日志记录格式，修改字段超长、字段换行问题
  **  20241202  LIP        增加99900130柜员
  ************************************************************************/
IS
  V_P_DATE           VARCHAR2(8);      --数据日期
  V_MONTH_END_DATEID VARCHAR2(8);      --本月月底日期
  V_PARTITION_NAME   VARCHAR2(100);    --分区名称
  V_FREQ_FLAG        VARCHAR2(10);     --跑批频度
  V_STEP             INTEGER := 1;     --任务号
  V_COUNT            INTEGER := 0;     --数据记录条数
  V_STARTTIME        DATE := SYSDATE;  --处理开始时间
  V_ENDTIME          DATE := SYSDATE;  --处理结束时间
  V_SQLCOUNT         INTEGER := 0;     --更新或删除影响的记录数
  V_SQLMSG           VARCHAR2(300);    --SQL执行描述信息
  V_STEP_DESC        VARCHAR2(100);    --处理步骤描述
  V_TABLE_NAME       VARCHAR2(100) := 'EAST5_103_GYB'; --表名称
  V_PROC_NAME        VARCHAR2(100) := 'ETL_EAST5_103_GYB'; --存储过程名称
BEGIN
  V_P_DATE  := TO_CHAR(I_P_DATE);
  O_ERRCODE := '0';
  V_MONTH_END_DATEID := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD');
  V_PARTITION_NAME   := 'PARTITION_' || V_P_DATE;
  V_FREQ_FLAG        := RRP_EAST.FUN_FREQ(I_P_DATE,V_PROC_NAME);

  --判断跑批频度
  IF V_FREQ_FLAG = '1' THEN

    /*增加分区*/
    V_STEP := 1;
    V_STEP_DESC := '删除当日分区数据';
    V_STARTTIME := SYSDATE;
    --删除当日分区数据
    RRP_EAST.ETL_PARTITION_ADD(V_P_DATE, V_TABLE_NAME, 1, O_ERRCODE);
    RRP_EAST.ETL_PARTITION_TRUNCATE(V_P_DATE, V_TABLE_NAME, O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --程序业务逻辑处理主体部分
    V_STEP := 2;
    V_STEP_DESC := '插入柜员表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_103_GYB(
      RID,         --数据主键
      JRXKZH,      --金融许可证号
      NBJGH,       --内部机构号
      YHJGMC,      --银行机构名称
      GYH,         --柜员号
      GH,          --工号
      GYLX,        --柜员类型
      SFSTGY,      --是否实体柜员
      GWBH,        --岗位编号
      GYQXJB,      --柜员权限级别
      SGRQ,        --上岗日期
      GYZT,        --柜员状态
      BBZ,         --备注
      CJRQ,        --采集日期
      DEPT_NO,     --部门编号
      SRC_SYS_ID,  --来源系统ID
      ISSUED_NO,   --填报机构
      ORG_NO,      --报送机构
      ADDRESS,     --归属地
      GSFZJG       --归属分支机构
      )
    --MOD BY LIP 20230614 因智能网点柜员离职之后会直接删除该柜员，所以这里改成采集当月所有柜员，取最大采集日期那条
      WITH PUM_EMP_TLR AS (
    SELECT /*+MATERIALIZE*/T.*,ROW_NUMBER() OVER(PARTITION BY T.TLR_NO ORDER BY T.DATA_DT DESC) RN
      FROM RRP_MDL.M_PUM_EMP_TLR T
     WHERE T.DATA_DT >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD')
       AND T.DATA_DT <= V_P_DATE)
    SELECT SYS_GUID()                                      AS RID,         --数据主键
           B.FIN_PERMIT_NO                                 AS JRXKZH,      --金融许可证号
           B.ORG_ID                                        AS NBJGH,       --内部机构号 --MOD BY LIP 20221111
           B.ORG_NM                                        AS YHJGMC,      --银行机构名称
           TRIM(A.TLR_NO)                                  AS GYH,         --柜员号
           /*TRIM(A.EMP_ID)                                  AS GH,        --工号*/
           /*20220817 SIT3测试BUG修改 因来源表RRP_MDL.M_PUM_EMP_TLR中员工编号为空时默认为2, 新旧对比中旧数据虚拟柜员工号允许为空，改为与旧数据一致*/
           CASE WHEN TRIM(A.EMP_ID) = '2' THEN NULL ELSE TRIM(A.EMP_ID) END AS GH,          --工号
           --A.TLR_TYP                                       AS GYLX,      --柜员类型
           --TRIM(SUBSTRB(A.TLR_TYP,1,20))                   AS GYLX,      --柜员类型
           --MOD BY LIP 20230601 根据宇信提供的口径，给虚拟柜员默认值
           CASE WHEN A.TLR_NO = 'SYMBOLS' THEN '新核心批处理柜员'
                WHEN A.TLR_NO = 'S####' THEN '旧核心批处理柜员'
                WHEN A.TLR_NO = 'M0001' THEN '联机处理系统柜员'
                WHEN A.TLR_NO = 'M0002' THEN '联机处理系统柜员'
                --ELSE TRIM(SUBSTRB(A.TLR_TYP,1,20))
                ELSE TRIM(SUBSTRB(A.TLR_TYP,1,30)) --MOD BY LIP UTF-8调整
            END                                            AS GYLX,        --柜员类型
           NVL(CODE1.TAR_VALUE_NAME,'否')                  AS SFSTGY,      --是否实体柜员
           CASE WHEN TRIM(A.POST_ID) IS NULL AND A.ENT_TLR_FLG = 'Y' THEN '0000' --MODIFY BY TANGAN AT 20230111 由于柜员在核心系统未申请岗位而在其他系统有岗位权限，故存在实体柜员在核心系统无岗位的情况，为符合EAST5.0报送强校验规则，请将该表中实体柜员为“是”且岗位编号为空的数据，赋予岗位编号“0000”值。
                ELSE TRIM(A.POST_ID)
           END                                             AS GWBH,        --岗位编号
           CASE WHEN A.TLR_TYP = '柜台柜员' THEN '高柜'
                WHEN A.TLR_TYP = '客户经理' THEN '低柜'
                --ELSE TRIM(SUBSTRB('其他-' || REPLACE(A.TLR_TYP,'其他-',''),1,20))
                ELSE TRIM(SUBSTRB('其他-' || REPLACE(A.TLR_TYP,'其他-',''),1,30)) --MOD BY LIP UTF-8调整
            END                                            AS GYQXJB,      --柜员权限级别
           CASE WHEN A.ON_DUTY_DT <> '00010101' THEN A.ON_DUTY_DT
                ELSE '99991231'
            END                                            AS SGRQ,        --上岗日期
           CASE WHEN A.TLR_STAT IN ('02','04') THEN '在岗'
                WHEN A.TLR_STAT IN ('09') THEN '离岗'
                --ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE2.TAR_VALUE_NAME, '其他-',''),1,20))
                ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE2.TAR_VALUE_NAME,'其他-',''),1,30)) --MOD BY LIP UTF-8调整
            END                                            AS GYZT,        --柜员状态
           ''                                              AS BBZ,         --备注
           V_MONTH_END_DATEID                              AS CJRQ,        --采集日期
           '000'                                           AS DEPT_NO,     --部门编号
           '01'                                            AS SRC_SYS_ID,  --来源系统ID
           '000000'                                        AS ISSUED_NO,   --填报机构
           ORG.ORG_ID_LEL_0                                AS ORG_NO,      --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                            AS ADDRESS,     --归属地
           '9999'                                          AS GSFZJG       --归属分支机构
      --FROM RRP_MDL.M_PUM_EMP_TLR A --柜员表
      FROM PUM_EMP_TLR A --柜员表
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(M.ORG_ID1,'800')
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = A.ENT_TLR_FLG
       AND CODE1.SRC_CLASS_CODE = 'Z0001' --是否实体柜员
       AND CODE1.TAR_CLASS_CODE = 'Z0001' --是否实体柜员
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE2 --码值配置表
        ON CODE2.SRC_VALUE_CODE = A.TLR_STAT
       AND CODE2.SRC_CLASS_CODE = 'C0049' --柜员状态
       AND CODE2.TAR_CLASS_CODE = 'C0049' --柜员状态
       AND CODE2.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = B.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE (TRIM(A.TLR_NO) NOT LIKE '99%' --99开头外包员工可能不参与业务，先剔除这些柜员
            OR TRIM(A.TLR_NO) IN ('99900024','99900034','99900027','99900025','99900011','99900001','99900041','99900037','99900028',
               '99900031','99900017','99900022','99900042','99900061','99900062','99900130')) --MOD BY LIP 20230810 志豪跟业务后，确认该部分柜员继续报送
       --MOD BY LIP 20230818 剔除这部分柜员
       --AND TRIM(A.TLR_NO) NOT IN ('00100837','00141090','02020322','00100838','02020353','00100846','00101049','02020325','02130271','03000172')
       --AND TRIM(A.TLR_NO) NOT IN ('02100365') --MOD BY LIP 20240423 20240819 该员工7月转正
       AND TRIM(A.TLR_NO) NOT IN ('00100837','00141090','00100838','00100846','00101049','02130271','03000172','09130164') --MOD BY LIP 20250604 增加已转正员工 02020353 02020325 02020322
       AND A.RN = 1;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --MOD BY LIP 20240320 当没从系统中获取到TGLS0001柜员时，新增一条TGLS0001柜员数据
    V_STEP := 3;
    V_STEP_DESC := '插入核算中台的虚拟柜员';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_103_GYB(RID,JRXKZH,NBJGH,YHJGMC,GYH,GH,GYLX,SFSTGY,GWBH,GYQXJB,SGRQ,GYZT,BBZ,CJRQ,DEPT_NO,SRC_SYS_ID,ISSUED_NO,ORG_NO,ADDRESS,GSFZJG)
    SELECT SYS_GUID()       AS RID,
           B.FIN_PERMIT_NO  AS JRXKZH, --金融许可证号
           B.ORG_ID         AS NBJGH,  --内部机构号
           B.ORG_NM         AS YHJGMC, --银行机构名称
           'TGLS0001','TGLS0001','核算中台批处理柜员','否','8888','其他-核算中台批处理','99991231','在岗','',
           V_MONTH_END_DATEID CJRQ,'000','01','000000','000000','B1194B244030001','9999'
      FROM DUAL A
      LEFT JOIN RRP_MDL.ORG_CONFIG M  --机构映射表
        ON M.ORG_ID = '800001'
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(M.ORG_ID1,'800')
       AND B.DATA_DT = V_P_DATE
     WHERE NOT EXISTS (SELECT 1 FROM RRP_EAST.EAST5_103_GYB WHERE GYH = 'TGLS0001' AND CJRQ = V_MONTH_END_DATEID);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --MOD BY LIP 20260410 删除员工不在员工表的实体柜员数据
    V_STEP := 4;
    V_STEP_DESC := '删除员工不在员工表的实体柜员数据';
    V_STARTTIME := SYSDATE;
    DELETE FROM RRP_EAST.EAST5_103_GYB T1
     WHERE NOT EXISTS (SELECT 1 FROM RRP_EAST.EAST5_102_YGB T2 WHERE T2.GH = T1.GH AND T2.CJRQ = V_MONTH_END_DATEID)
       AND T1.SFSTGY = '是'
       AND T1.CJRQ = V_MONTH_END_DATEID;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '查询数据是否重复';
    V_STARTTIME := SYSDATE;
      WITH TMP1 AS (
    SELECT CJRQ,GYH,COUNT(1)
      FROM RRP_EAST.EAST5_103_GYB T
     WHERE CJRQ = V_P_DATE
     GROUP BY CJRQ,GYH
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_SQLMSG  := 'EAST5_103_GYB(CJRQ,GYH)数据重复';
       ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_COUNT,O_ERRCODE,V_SQLMSG);
       RETURN;
    END IF;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_COUNT,O_ERRCODE,'');

    --表分析
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '表分析开始';
    V_STARTTIME := SYSDATE;
    RRP_EAST.ETL_DBMS_STATS(V_P_DATE, V_TABLE_NAME, V_PARTITION_NAME, O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
  END IF;

  V_STEP    := V_STEP + 1;
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
    O_ERRCODE := '1';
    V_SQLMSG  := '跑批错误：['||SQLCODE||'],描述信息：'||SQLERRM;
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_EAST5_103_GYB;
/

