CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_MPCS_A08TBANKINFO(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_MPCS_A08TBANKINFO
  *  功能描述：中台机构信息表
  *  创建日期：20230728
  *  开发人员：LTJ
  *  来源表： IOL.V_MPCS_A08TBANKINFO
  *  目标表： O_IOL_MPCS_A08TBANKINFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *            1        20230728  LTJ       首次创建
  ***************************************************************************/
AS
  -- 定义变量 --
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_STEP      INTEGER := 0;               --处理步骤
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_MPCS_A08TBANKINFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM O_IML_EVT_ENTRY T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE O_IOL_MPCS_A08TBANKINFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-中台机构信息表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_MPCS_A08TBANKINFO
    (BKCD           --参与机构行号
		,BKSTATUS       --参与机构状态 1 有效 2已撤销
		,BANKTYPE       --参与机构类别
		,BKCTGYCD       --行别代码
		,DRCTBKCD       --所属直参行号
		,BKNAME         --参与机构全称
		,BKSNAME        --参与机构简称
		,LGLPRSN        --所属法人
		,HGHPTCPT       --本行上级参与机构 多个上级参与者之间以“；”分隔，上级参与者列表排列顺序是从左至右，按照参与者级别由高到低依次填写
		,BRBKCD         --承接行行号
		,CHRGBKCD       --管辖人行行号
		,NDCD           --所属CCPC
		,CITYCD         --所在城市代码
		,SGN            --加入业务系统标识 排列顺序按从左到右位为大额、小额、网银，其它位数保留。位数字含义：0：未加入 1：加入
		,TEL            --电话/电挂
		,CHNGNB         --变更期数
		,FCTVDT         --生效日期
		,IFCTVDT        --失效日期
		,ACCTBKCDINF    --入账行行号信息
		,START_DT       --开始时间
		,END_DT         --结束时间
		,ID_MARK        --增删标志
		,ETL_TIMESTAMP  --ETL处理时间戳
    )
  SELECT BKCD           --参与机构行号
        ,BKSTATUS       --参与机构状态 1 有效 2已撤销
        ,BANKTYPE       --参与机构类别
        ,BKCTGYCD       --行别代码
        ,DRCTBKCD       --所属直参行号
        ,BKNAME         --参与机构全称
        ,BKSNAME        --参与机构简称
        ,LGLPRSN        --所属法人
        ,HGHPTCPT       --本行上级参与机构 多个上级参与者之间以“；”分隔，上级参与者列表排列顺序是从左至右，按照参与者级别由高到低依次填写
        ,BRBKCD         --承接行行号
        ,CHRGBKCD       --管辖人行行号
        ,NDCD           --所属CCPC
        ,CITYCD         --所在城市代码
        ,SGN            --加入业务系统标识 排列顺序按从左到右位为大额、小额、网银，其它位数保留。位数字含义：0：未加入 1：加入
        ,TEL            --电话/电挂
        ,CHNGNB         --变更期数
        ,FCTVDT         --生效日期
        ,IFCTVDT        --失效日期
        ,ACCTBKCDINF    --入账行行号信息
        ,START_DT       --开始时间
        ,END_DT         --结束时间
        ,ID_MARK        --增删标志
        ,ETL_TIMESTAMP  --ETL处理时间戳
    FROM IOL.V_MPCS_A08TBANKINFO  --视图-MPCS_A08TBANKINFO
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT >  TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';
  
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_MPCS_A08TBANKINFO', '', O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  O_ERRCODE := 0 ;
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

END ETL_O_IOL_MPCS_A08TBANKINFO;
/

