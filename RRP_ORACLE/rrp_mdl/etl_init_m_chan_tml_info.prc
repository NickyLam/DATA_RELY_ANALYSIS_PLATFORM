CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_CHAN_TML_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_INIT_M_CHAN_TML_INFO
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
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_CHAN_TML_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_CHAN_TML_INFO'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --V_YESTADAY := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD'); -- 上日
 -- V_LAST_DAT := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYY-MM-DD')),'YYYYMMDD'); --当月月底
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

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
  -- 程序业务逻辑处理主体部分 --
  V_STEP := 2; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '终端设备信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO M_CHAN_TML_INFO
  (
  DATA_DT,             --数据日期
  LGL_REP_ID,          --法人编号
  ORG_ID,              --机构编号
  TML_ID,              --终端编号
  TML_TYP,             --终端类型
  TML_STAT,            --终端状态
  ACPT_DT,             --受理日期
  CNL_DT,              --撤销日期
  VIL_RGN_FLG,         --农村区域标志
  TML_EQMT_ID,         --终端设备编号
  MER_ID,              --商户编号
  SELF_SERV_MACH_FLG,  --自助机具标志
  DEPT_LINE,           --部门条线
  DATA_SRC,             --数据来源
  SELF_EQUIP_TYPE_CD    --自助设备类型代码
    )
  SELECT V_P_DATE     --数据日期
       ,A.LP_ID                           --法人编号
       ,A.BELONG_ORG_ID                   --机构编号
       ,A.EQUIP_ID                        --终端编号
       ,CASE WHEN A.EQUIP_KIND_NAME = 'ATM终端'
             THEN 'A'
             WHEN A.EQUIP_KIND_NAME IN ('POS终端')
             THEN 'B'
             ELSE 'F99'
             END            --终端类型
       ,CASE WHEN A.EQUIP_STATUS_CD IN ('1','4') THEN 'Y'
             ELSE 'N'
             END                --终端状态
       ,NULL                              --受理日期
       ,NULL                              --撤销日期
       ,NULL                              --农村区域标志
       ,A.EQUIP_ID                        --终端设备编号
       ,NULL                              --商户编号
       ,NULL                              --自助机具标志
       ,'POS和ATM终端'                              --部门条线
       ,SUBSTR(A.JOB_CD,0,4)              --数据来源
       ,A.SELF_EQUIP_TYPE_CD                --自助设备类型代码
  FROM O_ICL_CMM_SELF_EQUIP_INFO A  --自助设备信息表
/*  LEFT JOIN O_ICL_CMM_INTNAL_ORG_INFO B  --内部机构表
    ON A.BELONG_ORG_ID = B.ORG_ID*/
  WHERE A.EQUIP_KIND_NAME IN ('POS终端','ATM终端')
  AND A.ETL_DT =TO_DATE(V_P_DATE,'YYYYMMDD')
  AND A.EQUIP_ID <> ' '
 -- AND A.SELF_EQUIP_TYPE_CD IN ('10001','10003','10004'/*,'10007','10008'*/) --取消范围框定
  -------------增加自助商户POS机口径
  UNION ALL
    SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')     --数据日期
       ,A.LP_ID                           --法人编号
       ,BELONG_ORG_ID                     --机构编号
       ,A.EQUIP_ID                        --终端编号
       ,'B'                               --终端类型
       ,CASE WHEN A.EQUIP_STATUS_CD IN ('1','4') THEN 'Y'
             ELSE 'N'
             END                --终端状态
       ,NULL                              --受理日期
       ,NULL                              --撤销日期
       ,NULL                              --农村区域标志
       ,A.EQUIP_ID                        --终端设备编号
       ,NULL                              --商户编号
       ,NULL                              --自助机具标志
       ,'直联终端'                              --部门条线
       ,SUBSTR(A.JOB_CD,0,4)              --数据来源
       ,A.SELF_EQUIP_TYPE_CD                --自助设备类型代码
  FROM O_ICL_CMM_SELF_EQUIP_INFO A  --自助设备信息表
 /* LEFT JOIN O_ICL_CMM_INTNAL_ORG_INFO B  --内部机构表
    ON A.BELONG_ORG_ID = B.ORG_ID*/
  WHERE EQUIP_KIND_NAME ='直联终端'
  AND A.ETL_DT =TO_DATE(V_P_DATE,'YYYYMMDD')
  AND A.EQUIP_MATNCE_ID IN
  (SELECT MERCHT_ID FROM O_ICL_CMM_POS_MERCHT_INFO
  WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  AND  DIC_CONC_MERCHT_FLG='1')
  AND A.EQUIP_ID <> ' ';

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


---------------MODIFY BY MW 根据业务及上游口径新增收单系统POS机数据
/*     V_STEP := 3; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '收单系统POS机数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO M_CHAN_TML_INFO
  (
  DATA_DT,             --数据日期
  LGL_REP_ID,          --法人编号
  ORG_ID,              --机构编号
  TML_ID,              --终端编号
  TML_TYP,             --终端类型
  TML_STAT,            --终端状态
  ACPT_DT,             --受理日期
  CNL_DT,              --撤销日期
  VIL_RGN_FLG,         --农村区域标志
  TML_EQMT_ID,         --终端设备编号
  MER_ID,              --商户编号
  SELF_SERV_MACH_FLG,  --自助机具标志
  DEPT_LINE,           --部门条线
  DATA_SRC,             --数据来源
  SELF_EQUIP_TYPE_CD    --自助设备类型代码
    )
  SELECT
  V_P_DATE             DATA_DT,             --数据日期
  A.LP_ID              LGL_REP_ID,          --法人编号
  A.BELONG_ORG_ID      ORG_ID,              --机构编号
  A.MERCHT_ORDER_ID    TML_ID,              --终端编号
  'B'                  TML_TYP,             --终端类型 --B-POS
  CASE WHEN MERCHT_STATUS_CD IN ('10','3','2')
       THEN 'Y'
       ELSE 'N'
       END             TML_STAT,            --终端状态
  TO_CHAR(A.MERCHT_START_USE_DT,'YYYYMMDD')
                       ACPT_DT,             --受理日期
  NULL                 CNL_DT,              --撤销日期
  NULL                 VIL_RGN_FLG,         --农村区域标志
  A.MERCHT_ID          TML_EQMT_ID,         --终端设备编号
  A.MERCHT_ID          MER_ID,              --商户编号
  'Y'                  SELF_SERV_MACH_FLG,  --自助机具标志
  '10'                 DEPT_LINE,           --部门条线
  '收单系统POS'         DATA_SRC,             --数据来源
  '10001'                      SELF_EQUIP_TYPE_CD    --自助设备类型代码
  FROM O_ICL_CMM_POS_MERCHT_INFO A  --POS商户信息
  WHERE A.MERCHT_STATUS_CD IN ('2','3','10') --取正常商户未注销关闭商户
  AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
*/

    -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, TML_ID,TML_TYP,COUNT(1)
      FROM M_CHAN_TML_INFO T
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

  END ETL_INIT_M_CHAN_TML_INFO;
/

