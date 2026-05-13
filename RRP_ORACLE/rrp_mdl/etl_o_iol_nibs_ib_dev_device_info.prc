CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_NIBS_IB_DEV_DEVICE_INFO(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_NIBS_IB_DEV_DEVICE_INFO
  *  功能描述：设备信息表
  *  创建日期：20251126
  *  开发人员：于敬艺
  *  来源表： IOL.V_NIBS_IB_DEV_DEVICE_INFO
  *  目标表： O_IOL_NIBS_IB_DEV_DEVICE_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20251126  YJY     首次创建
  *************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_NIBS_IB_DEV_DEVICE_INFO'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_NIBS_IB_DEV_DEVICE_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-设备信息表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_NIBS_IB_DEV_DEVICE_INFO NOLOGGING
    (       DEVICENUM               --设备编号
           ,DEVICEID                --设备标识id
           ,DEVMODELID              --设备型号-关联
           ,DEVICETYPENUM           --设备类型编号
           ,DEVICESATUS             --设备状态标识 0-待启用，1-正常
           ,DEVICEBOXMSG            --管理员1手机号
           ,DEVICEMODULEMSG         --管理员2手机号
           ,EXISTFALG               --在离行标识 1-在行，2-离行
           ,INSTALLTYPE             --安装方式 1-穿墙式，2-大堂式，3-壁挂式
           ,MANUFACTURERNAME        --设备厂商--型号关联
           ,ASCRBRANCH              --所属机构
           ,VIRTUALUSERNUM          --虚拟柜员号
           ,EQUIPSCRNRESOLUT        --设备分辨率
           ,ADMINUSERONE            --管理员1
           ,ADMINUSERTWO            --管理员2
           ,INSUSTARTDATE           --维保开始日期-yyyy-MM-dd
           ,INSUENDDATE             --维保结束日期-yyyy-MM-dd
           ,DEVICEBUYDATE           --设备购买日期-yyyy-MM-dd
           ,DEVICESTARTDATE         --设备启用日期-yyyy-MM-dd
           ,DEVICESTOPDATE          --设备停止日期-yyyy-MM-dd
           ,DEVICESERVICESTARTTIME  --设备服务开始时间-HH:mm:ss
           ,DEVICESERVICEENDTIME    --设备服务结束时间-HH:mm:ss
           ,SHUTDOWNTIME            --定时关机时间-HH:mm:ss
           ,DEVICEIP                --设备ip
           ,SELFBANK                --自助银行 1是 0否
           ,COMMSTATUS              --通讯状态-0:未知、1:正常 2:异常
           ,OPERSTATUS              --运行状态-0-正常，1-停止服务，2-部分服务，3-未知，4-P通讯故障，5-维护，6-关机，7-停用
           ,BANKTELLER              --ATM清机申请绑定柜员号
           ,MANAGEMENTMODE          --管理模式|1非外包 2-外包
           ,INSTALLADDRESS          --安装地址
           ,ENCRYPTIONMODE          --加密方式 0-国密
           ,QJCOM_ID                --清机公司编号
           ,SEQ                     --序号三位
           ,VIRTUALTAILBOXID        --虚拟尾箱号，与虚拟柜员是绑定关系
           ,AUTHCODE                --中台装机码
           ,QJCOMNAME               --清机公司名称
           ,ASYCNFALG               --中台同步标识 0-未同步 1-已经同步
           ,INSTALLCONTEL           --装机联系电话
           ,VIRTUALUSERTAILBOXID    --虚拟柜员尾箱号
           ,SERVICEPROVNUM          --服务商编号
           ,VCHBOXFLG               --凭证钱箱 0:否 1:是
           ,CSHBOXFLG               --现金钱箱 0:否 1:是
           ,VIRTUALTELLER           --实体柜员号
           ,DEVSTATE                --设备状态1-正常
           ,DEVICESTATE             --设备使用状态 : 0.领用、1：启用、2：停用、3：删除、9登记
           ,MODIFYUSER              --最后修改用户
           ,MODIFYUSERBRNO          --最后维护人所属机构
           ,CREATORBRNO             --创建人所属机构
           ,MODIFDATE               --最后修改日期
           ,MODIFTIME               --最后修改日期
           ,CREAUSER                --创建用户
           ,DEVACTIVATIONCODE       --设备激活码
           ,DEVCREATETIME           --创建时间
           ,CREADATE                --创建日期 : YYYYMMDD
           ,DEVUNIQUEID             --设备唯一标识，C端生成
           ,DEVICEMAC               --设备的mac地址
           ,IMEICODE                --IEME编号
           ,BACKCODE                --背夹序号
           ,KEYNAME                 --秘钥名称
           ,CHECKVALUE              --校检值
           ,KEYVALUE                --秘钥
           ,START_DT                --开始时间
           ,END_DT                  --结束时间
           ,ID_MARK                 --增删标志
           ,ETL_TIMESTAMP           --ETL处理时间戳

     )
  SELECT /*+PARALLEL*/
           DEVICENUM               --设备编号
           ,DEVICEID                --设备标识id
           ,DEVMODELID              --设备型号-关联
           ,DEVICETYPENUM           --设备类型编号
           ,DEVICESATUS             --设备状态标识 0-待启用，1-正常
           ,DEVICEBOXMSG            --管理员1手机号
           ,DEVICEMODULEMSG         --管理员2手机号
           ,EXISTFALG               --在离行标识 1-在行，2-离行
           ,INSTALLTYPE             --安装方式 1-穿墙式，2-大堂式，3-壁挂式
           ,MANUFACTURERNAME        --设备厂商--型号关联
           ,ASCRBRANCH              --所属机构
           ,VIRTUALUSERNUM          --虚拟柜员号
           ,EQUIPSCRNRESOLUT        --设备分辨率
           ,ADMINUSERONE            --管理员1
           ,ADMINUSERTWO            --管理员2
           ,INSUSTARTDATE           --维保开始日期-yyyy-MM-dd
           ,INSUENDDATE             --维保结束日期-yyyy-MM-dd
           ,DEVICEBUYDATE           --设备购买日期-yyyy-MM-dd
           ,DEVICESTARTDATE         --设备启用日期-yyyy-MM-dd
           ,DEVICESTOPDATE          --设备停止日期-yyyy-MM-dd
           ,DEVICESERVICESTARTTIME  --设备服务开始时间-HH:mm:ss
           ,DEVICESERVICEENDTIME    --设备服务结束时间-HH:mm:ss
           ,SHUTDOWNTIME            --定时关机时间-HH:mm:ss
           ,DEVICEIP                --设备ip
           ,SELFBANK                --自助银行 1是 0否
           ,COMMSTATUS              --通讯状态-0:未知、1:正常 2:异常
           ,OPERSTATUS              --运行状态-0-正常，1-停止服务，2-部分服务，3-未知，4-P通讯故障，5-维护，6-关机，7-停用
           ,BANKTELLER              --ATM清机申请绑定柜员号
           ,MANAGEMENTMODE          --管理模式|1非外包 2-外包
           ,INSTALLADDRESS          --安装地址
           ,ENCRYPTIONMODE          --加密方式 0-国密
           ,QJCOM_ID                --清机公司编号
           ,SEQ                     --序号三位
           ,VIRTUALTAILBOXID        --虚拟尾箱号，与虚拟柜员是绑定关系
           ,AUTHCODE                --中台装机码
           ,QJCOMNAME               --清机公司名称
           ,ASYCNFALG               --中台同步标识 0-未同步 1-已经同步
           ,INSTALLCONTEL           --装机联系电话
           ,VIRTUALUSERTAILBOXID    --虚拟柜员尾箱号
           ,SERVICEPROVNUM          --服务商编号
           ,VCHBOXFLG               --凭证钱箱 0:否 1:是
           ,CSHBOXFLG               --现金钱箱 0:否 1:是
           ,VIRTUALTELLER           --实体柜员号
           ,DEVSTATE                --设备状态1-正常
           ,DEVICESTATE             --设备使用状态 : 0.领用、1：启用、2：停用、3：删除、9登记
           ,MODIFYUSER              --最后修改用户
           ,MODIFYUSERBRNO          --最后维护人所属机构
           ,CREATORBRNO             --创建人所属机构
           ,MODIFDATE               --最后修改日期
           ,MODIFTIME               --最后修改日期
           ,CREAUSER                --创建用户
           ,DEVACTIVATIONCODE       --设备激活码
           ,DEVCREATETIME           --创建时间
           ,CREADATE                --创建日期 : YYYYMMDD
           ,DEVUNIQUEID             --设备唯一标识，C端生成
           ,DEVICEMAC               --设备的mac地址
           ,IMEICODE                --IEME编号
           ,BACKCODE                --背夹序号
           ,KEYNAME                 --秘钥名称
           ,CHECKVALUE              --校检值
           ,KEYVALUE                --秘钥
           ,START_DT                --开始时间
           ,END_DT                  --结束时间
           ,ID_MARK                 --增删标志
           ,ETL_TIMESTAMP           --ETL处理时间戳
    FROM IOL.V_NIBS_IB_DEV_DEVICE_INFO   --设备信息表
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';  

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, ‘, O_ERRCODE);

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

  END ETL_O_IOL_NIBS_IB_DEV_DEVICE_INFO;
/

