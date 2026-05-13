CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_CHAN_TML_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_CHAN_TML_INFO
  *  功能描述：监管集市记录商业银行终端设备情况，包括ATM自助设备和POS设备的设备信息及安装信息。
  *  创建日期：20220530
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_INTNAL_ORG_INFO --内部机构信息
  *            ICL.CMM_SELF_EQUIP_INFO   --自助设备信息表
  *  目标表：  M_CHAN_TML_INFO  --终端设备信息
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221114  hulj     增加数据重复校验。
  *             2    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             3    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             4    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             5    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             6    20240929  LIP      增加商户编号的取数
  *             7    20250319  LINAL    一表通，增加自助设备设备型号、设备安装地址字段取值逻辑。
  *             8    20250818  YJY      一表通，新增设备状态代码
  **************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;                 --处理步骤
  V_STEP_DESC VARCHAR2(100);                --处理步骤描述
  V_P_DATE    VARCHAR2(8);                  --跑批数据日期
  V_STARTTIME DATE;                         --处理开始时间
  V_ENDTIME   DATE;                         --处理结束时间
  V_SQLCOUNT  INTEGER := 0;                 --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);                --SQL执行描述信息
  V_PART_NAME VARCHAR2(100);                --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_CHAN_TML_INFO'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_CHAN_TML_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送';   --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR( I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.M_CHAN_TML_INFO T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'B_GENERALIZE_INDEX'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 2;
  V_STEP_DESC := '终端设备信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CHAN_TML_INFO
   ( DATA_DT             --数据日期
    ,LGL_REP_ID          --法人编号
    ,ORG_ID              --机构编号
    ,TML_ID              --终端编号
    ,TML_TYP             --终端类型
    ,TML_STAT            --终端状态
    ,ACPT_DT             --受理日期
    ,CNL_DT              --撤销日期
    ,VIL_RGN_FLG         --农村区域标志
    ,TML_EQMT_ID         --终端设备编号
    ,MER_ID              --商户编号
    ,SELF_SERV_MACH_FLG  --自助机具标志
    ,DEPT_LINE           --部门条线
    ,DATA_SRC            --数据来源
    ,SELF_EQUIP_TYPE_CD  --自助设备类型代码
    ,SELF_EQUIP_MODEL    --自助设备设备型号  --ADD 20250319 LINAILIAN
    ,EQUIP_INSTALL_ADDR  --设备安装地址      --ADD 20250319 LINAILIAN
    ,EQUIP_STATUS_CD     --设备状态代码      ADD BY YJY 20250818
    )
  SELECT  V_P_DATE                        AS DATA_DT             --数据日期
         ,A.LP_ID                         AS LGL_REP_ID          --法人编号
         ,A.BELONG_ORG_ID                 AS ORG_ID              --机构编号
         ,A.EQUIP_ID                      AS TML_ID              --终端编号
         ,CASE WHEN A.EQUIP_KIND_NAME = 'ATM终端' 
               THEN 'A'
               WHEN A.EQUIP_KIND_NAME IN ('POS终端')
               THEN 'B'
               ELSE 'F99'
          END                             AS TML_TYP             --终端类型
         ,CASE WHEN A.EQUIP_STATUS_CD IN ('1','4') 
               THEN 'Y'
               ELSE 'N'
          END                             AS TML_STAT            --终端状态
         ,NULL                            AS ACPT_DT             --受理日期
         ,NULL                            AS CNL_DT              --撤销日期
         ,NULL                            AS VIL_RGN_FLG         --农村区域标志
         ,A.EQUIP_ID                      AS TML_EQMT_ID         --终端设备编号
         --NULL                            MER_ID,               --商户编号
         ,A.EQUIP_MATNCE_ID               AS MER_ID              --商户编号 --MOD BY LIP 20240929
         ,NULL                            AS SELF_SERV_MACH_FLG  --自助机具标志
         ,'POS和ATM终端'                  AS DEPT_LINE           --部门条线
         ,SUBSTR(A.JOB_CD,0,4)            AS DATA_SRC            --数据来源
         ,A.SELF_EQUIP_TYPE_CD            AS SELF_EQUIP_TYPE_CD  --自助设备类型代码
         ,A.SELF_EQUIP_MODEL              AS SELF_EQUIP_MODEL    --自助设备设备型号 --ADD 20250319 LINAILIAN
         ,A.EQUIP_INSTALL_ADDR            AS EQUIP_INSTALL_ADDR  --设备安装地址     --ADD 20250319 LINAILIAN
         ,A.EQUIP_STATUS_CD               AS EQUIP_STATUS_CD     --设备状态代码      ADD BY YJY 20250818
    FROM RRP_MDL.O_ICL_CMM_SELF_EQUIP_INFO A  --自助设备信息表
   WHERE A.EQUIP_KIND_NAME IN ('POS终端','ATM终端')
     AND A.EQUIP_ID <> ' '
     --AND A.SELF_EQUIP_TYPE_CD IN ('10001','10003','10004'/*,'10007','10008'*/) --取消范围框定
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   --增加自助商户POS机口径
   UNION ALL
  SELECT  TO_CHAR(A.ETL_DT,'YYYYMMDD')      AS DATA_DT             --数据日期
         ,A.LP_ID                           AS LGL_REP_ID          --法人编号
         ,A.BELONG_ORG_ID                   AS ORG_ID              --机构编号
         ,A.EQUIP_ID                        AS TML_ID              --终端编号
         ,'B'                               AS TML_TYP             --终端类型
         ,CASE WHEN A.EQUIP_STATUS_CD IN ('1','4') 
               THEN 'Y'
               ELSE 'N'
          END                               AS TML_STAT            --终端状态
         ,NULL                              AS ACPT_DT             --受理日期
         ,NULL                              AS CNL_DT              --撤销日期
         ,NULL                              AS VIL_RGN_FLG         --农村区域标志
         ,A.EQUIP_ID                        AS TML_EQMT_ID         --终端设备编号
         --NULL                             MER_ID,                --商户编号
         ,A.EQUIP_MATNCE_ID                 AS MER_ID              --商户编号 --MOD BY LIP 20240929
         ,NULL                              AS SELF_SERV_MACH_FLG  --自助机具标志
         ,'直联终端'                        AS DEPT_LINE           --部门条线
         ,SUBSTR(A.JOB_CD,0,4)              AS DATA_SRC            --数据来源
         ,A.SELF_EQUIP_TYPE_CD              AS SELF_EQUIP_TYPE_CD  --自助设备类型代码
         ,A.SELF_EQUIP_MODEL                AS SELF_EQUIP_MODEL    --自助设备设备型号 --ADD 20250319 LINAILIAN
         ,A.EQUIP_INSTALL_ADDR              AS EQUIP_INSTALL_ADDR  --设备安装地址     --ADD 20250319 LINAILIAN
         ,A.EQUIP_STATUS_CD                 AS EQUIP_STATUS_CD     --设备状态代码      ADD BY YJY 20250818
    FROM RRP_MDL.O_ICL_CMM_SELF_EQUIP_INFO A  --自助设备信息表
   WHERE A.EQUIP_KIND_NAME = '直联终端'
     AND A.EQUIP_MATNCE_ID IN (SELECT MERCHT_ID 
                                 FROM RRP_MDL.O_ICL_CMM_POS_MERCHT_INFO
                                WHERE DIC_CONC_MERCHT_FLG = '1'
                                  AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
     AND A.EQUIP_ID <> ' '
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, TML_ID,TML_TYP,COUNT(1)
      FROM RRP_MDL.M_CHAN_TML_INFO T
     WHERE DATA_DT = V_P_DATE
     GROUP BY DATA_DT, TML_ID,TML_TYP
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

END ETL_M_CHAN_TML_INFO;
/

