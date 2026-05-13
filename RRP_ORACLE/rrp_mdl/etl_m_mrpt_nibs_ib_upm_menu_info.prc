CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_MRPT_NIBS_IB_UPM_MENU_INFO (I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_M_MRPT_NIBS_IB_UPM_MENU_INFO
  *  功能描述：交易菜单表
  *  创建日期：20221213
  *  开发人员：阳娟
  *  来源表： O_IOL_NIBS_IB_UPM_MENU_INFO
  *  目标表： M_MRPT_NIBS_IB_UPM_MENU_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221213  阳娟     首次创建
  ***************************************************************************/
  -- 定义变量 --
  AS
  I_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_M_MRPT_NIBS_IB_UPM_MENU_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  D_STARTTIME DATE; -- 处理开始时间
  D_ENDTIME DATE;   -- 处理结束时间
  I_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_SQL       VARCHAR2(2000); -- 动态sql
  I_STEP_DESC VARCHAR2(200); --任务名称
  V_PART_NAME VARCHAR2(100);  --分区名称
  V_PART_COUNT  INTEGER;        --分区是否存在
  V_TAB_NAME  VARCHAR2(100);  --表名称
BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_PART_NAME := 'PARTITION_'||V_P_DATE; --分区名称
  V_TAB_NAME := 'M_MRPT_NIBS_IB_UPM_MENU_INFO'; --表名称

  -- 支持重跑 --
  I_STEP := 1;
  I_STEP_DESC := '-- 程序跑批开始 --';
  D_STARTTIME := SYSDATE;
  --DELETE FROM M_MRPT_NIBS_IB_UPM_MENU_INFO T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  /*SELECT COUNT(0)
    INTO V_PART_COUNT
    FROM USER_TAB_PARTITIONS T
   WHERE T.TABLE_NAME = V_TAB_NAME
     AND T.PARTITION_NAME = V_PART_NAME;

  IF V_PART_COUNT = 1 THEN
  V_SQL := 'ALTER TABLE '||V_TAB_NAME||' DROP PARTITION '||V_PART_NAME;--分区表的重跑处理
  EXECUTE IMMEDIATE V_SQL;
  --ETL_PARTITION_DROP(V_P_DATE,V_TAB_NAME,O_ERRCODE);--分区表的重跑处理
  END IF ;*/
  V_SQL :='TRUNCATE TABLE M_MRPT_NIBS_IB_UPM_MENU_INFO';
  EXECUTE IMMEDIATE V_SQL;
  
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME,1,O_ERRCODE);--新增分区

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  D_ENDTIME := SYSDATE;

  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  I_STEP := I_STEP + 1; -- 小于10步骤直接写数字，大于10步用I_STEP := I_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  I_STEP_DESC := '数据落地-客户账户注册手机号历史';
  D_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_MRPT_NIBS_IB_UPM_MENU_INFO
  (      DATA_DT --数据日期
				,APPNUM  --应用编号
				,MENUVIEWNUM  --菜单视图编号-一级菜单
				,MENUNUM  --菜单编号
				,MENUNAME  --菜单名称
				,MENUICON  --菜单图标
				,MENUPATH  --菜单路径
				,MENUTYPE  --菜单类型 : 01 目录节点 02 交易节点 03 功能节点
				,SORTNUM  --排序号
				,PARENTMENUNUM  --父菜单编号 : 根节点的父节点为0
				,ISVISIBLE  --是否可见 : 0 不可见 1可见
				,MAINBRANCH  --维护机构
				,MAINUSER  --维护用户
				,MAINDATE  --维护日期
				,MAINTIME  --维护时间
				,TADPATH  --交易路径
				,WEIGHT  --交易权重 用来统计交易数量
				,TRANFLAG  --菜单分类 0-非金融类|1-金融类|2-查询类
				,RLTFLAG  --权限限制配置 0-未配置 1-配置
				,ICONACTIVE  --选中时的图片
				,BANKFLAG  --是否离行标识：0 在行 1 离行
				,RECOMDEAL  --是否推荐交易：0 是 1 否
				,ENGLISHMENUNAME  --英文名称
				,NAVIGATIONMODE  --导航模式
				,ISCOMMON  --是否常用
				,START_DT  --开始时间
				,END_DT  --结束时间
				,ID_MARK  --增删标志
				,ETL_TIMESTAMP  --ETL处理时间戳
				,INOUTVIEWFLAG  --内部/客服-服务视图|1-内部 2-客服

    )
    SELECT
         V_P_DATE  --数据日期
				,APPNUM  --应用编号
				,MENUVIEWNUM  --菜单视图编号-一级菜单
				,MENUNUM  --菜单编号
				,MENUNAME  --菜单名称
				,MENUICON  --菜单图标
				,MENUPATH  --菜单路径
				,MENUTYPE  --菜单类型 : 01 目录节点 02 交易节点 03 功能节点
				,SORTNUM  --排序号
				,PARENTMENUNUM  --父菜单编号 : 根节点的父节点为0
				,ISVISIBLE  --是否可见 : 0 不可见 1可见
				,MAINBRANCH  --维护机构
				,MAINUSER  --维护用户
				,MAINDATE  --维护日期
				,MAINTIME  --维护时间
				,TADPATH  --交易路径
				,WEIGHT  --交易权重 用来统计交易数量
				,TRANFLAG  --菜单分类 0-非金融类|1-金融类|2-查询类
				,RLTFLAG  --权限限制配置 0-未配置 1-配置
				,ICONACTIVE  --选中时的图片
				,BANKFLAG  --是否离行标识：0 在行 1 离行
				,RECOMDEAL  --是否推荐交易：0 是 1 否
				,ENGLISHMENUNAME  --英文名称
				,NAVIGATIONMODE  --导航模式
				,ISCOMMON  --是否常用
				,START_DT  --开始时间
				,END_DT  --结束时间
				,ID_MARK  --增删标志
				,ETL_TIMESTAMP  --ETL处理时间戳
				,INOUTVIEWFLAG  --内部/客服-服务视图|1-内部 2-客服
    FROM  RRP_MDL.O_IOL_NIBS_IB_UPM_MENU_INFO
    WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
  AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')  --视图-交易菜单表
;
   I_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   D_ENDTIME := SYSDATE;
   COMMIT;
   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;

   -- 程序跑批结束记录 --
   I_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,'');

   -- 程序异常处理部分 --
   EXCEPTION
     WHEN OTHERS THEN
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  ROLLBACK;
     O_ERRCODE := '1';
     D_ENDTIME := SYSDATE;
 /* I_STEP := I_STEP + 1;
     I_STEP_DESC := '-- 程序跑批异常 --';*/
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_M_MRPT_NIBS_IB_UPM_MENU_INFO ;
/

