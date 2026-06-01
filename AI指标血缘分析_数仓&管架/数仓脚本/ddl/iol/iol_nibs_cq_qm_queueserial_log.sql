/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nibs_cq_qm_queueserial_log
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nibs_cq_qm_queueserial_log
whenever sqlerror continue none;
drop table ${iol_schema}.nibs_cq_qm_queueserial_log purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_cq_qm_queueserial_log(
    workdate varchar2(8) -- 工作日
    ,brno varchar2(12) -- 机构编号
    ,deviceno varchar2(64) -- 设备编号
    ,queuegetserno varchar2(64) -- 队列号取号流水
    ,queuegetchannel varchar2(6) -- 队列号取号渠道编号
    ,queuegettime timestamp -- 取号时间
    ,queuetppreletter varchar2(5) -- 队列号前缀字母
    ,queuetpprenum varchar2(4) -- 队列号数字
    ,queueno varchar2(36) -- 队列号
    ,queuetpchkcode varchar2(10) -- 队列号校验码
    ,queuetpstatus varchar2(1) -- 队列号状态 0- 取号,1- 业务办理中,2-业务办理结束,3-弃号,4-转移,5-休眠
    ,bsid varchar2(20) -- 业务ID A-个人现金, B-个人非现金, C-对公现金, D-对公非现金, E-小面额, T-特殊取号
    ,queuetpid varchar2(35) -- 队列ID
    ,custgrd varchar2(3) -- 客户综合评级 0-公司用户, 1-普通用户, 2-VIP用户, 3-私人银行用户, 99-特殊取号
    ,idtype varchar2(4) -- 证件类型
    ,idcode varchar2(60) -- 证件号码
    ,custname varchar2(200) -- 客户名称
    ,custno varchar2(16) -- 客户编号
    ,telno varchar2(30) -- 手机号或电话号码
    ,cardno varchar2(50) -- 卡号
    ,reserveflag varchar2(1) -- 预约标志 0-无 1-有
    ,reserveid varchar2(40) -- 预约ID
    ,isbill varchar2(1) -- 是否预填单 0否 1是
    ,waittime number -- 客户等待时间（分钟）
    ,transfertime timestamp -- 转移时间
    ,billno varchar2(20) -- 填单批次号
    ,sleeptime timestamp -- 休眠更新时间
    ,assdqueueno varchar2(36) -- 关联队列号
    ,queuecallseq varchar2(48) -- 叫号流水
    ,queuecalltime timestamp -- 叫号时间
    ,winno varchar2(12) -- 处理窗口号
    ,queuecalltp varchar2(1) -- 队列号叫号类型1-普通,2-转移,3-指定叫号
    ,transfernum number -- 转移次数
    ,startservtime timestamp -- 开始办理业务时间
    ,finishservtime timestamp -- 结束办理业务时间
    ,servetime number -- 服务时间（秒）
    ,queuecalltlrno varchar2(8) -- 服务实体柜员编号
    ,custphoto varchar2(500) -- 客户照片路径
    ,tlrno varchar2(8) -- 客户经理
    ,wddeviceno varchar2(30) -- 穿戴设备编号
    ,queueadjtime varchar2(6) -- 
    ,usernum varchar2(8) -- 柜员号
    ,holidayfalg varchar2(2) -- 节假日标识0-否 1-是
    ,custserialnum varchar2(32) -- 客户服务流水
    ,minwaitnum varchar2(10) -- 最小等待人数
    ,handlewinno varchar2(100) -- 可办理窗口
    ,note1 varchar2(500) -- 备用1
    ,note2 varchar2(500) -- 备用2
    ,noticeflag varchar2(10) -- 是否通知
    ,bsname varchar2(100) -- 业务名称
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.nibs_cq_qm_queueserial_log to ${iml_schema};
grant select on ${iol_schema}.nibs_cq_qm_queueserial_log to ${icl_schema};
grant select on ${iol_schema}.nibs_cq_qm_queueserial_log to ${idl_schema};
grant select on ${iol_schema}.nibs_cq_qm_queueserial_log to ${iel_schema};

-- comment
comment on table ${iol_schema}.nibs_cq_qm_queueserial_log is '排队流水表';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.workdate is '工作日';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.brno is '机构编号';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.deviceno is '设备编号';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.queuegetserno is '队列号取号流水';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.queuegetchannel is '队列号取号渠道编号';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.queuegettime is '取号时间';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.queuetppreletter is '队列号前缀字母';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.queuetpprenum is '队列号数字';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.queueno is '队列号';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.queuetpchkcode is '队列号校验码';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.queuetpstatus is '队列号状态 0- 取号,1- 业务办理中,2-业务办理结束,3-弃号,4-转移,5-休眠';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.bsid is '业务ID A-个人现金, B-个人非现金, C-对公现金, D-对公非现金, E-小面额, T-特殊取号';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.queuetpid is '队列ID';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.custgrd is '客户综合评级 0-公司用户, 1-普通用户, 2-VIP用户, 3-私人银行用户, 99-特殊取号';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.idtype is '证件类型';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.idcode is '证件号码';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.custname is '客户名称';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.custno is '客户编号';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.telno is '手机号或电话号码';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.cardno is '卡号';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.reserveflag is '预约标志 0-无 1-有';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.reserveid is '预约ID';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.isbill is '是否预填单 0否 1是';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.waittime is '客户等待时间（分钟）';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.transfertime is '转移时间';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.billno is '填单批次号';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.sleeptime is '休眠更新时间';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.assdqueueno is '关联队列号';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.queuecallseq is '叫号流水';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.queuecalltime is '叫号时间';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.winno is '处理窗口号';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.queuecalltp is '队列号叫号类型1-普通,2-转移,3-指定叫号';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.transfernum is '转移次数';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.startservtime is '开始办理业务时间';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.finishservtime is '结束办理业务时间';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.servetime is '服务时间（秒）';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.queuecalltlrno is '服务实体柜员编号';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.custphoto is '客户照片路径';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.tlrno is '客户经理';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.wddeviceno is '穿戴设备编号';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.queueadjtime is '';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.usernum is '柜员号';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.holidayfalg is '节假日标识0-否 1-是';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.custserialnum is '客户服务流水';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.minwaitnum is '最小等待人数';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.handlewinno is '可办理窗口';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.note1 is '备用1';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.note2 is '备用2';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.noticeflag is '是否通知';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.bsname is '业务名称';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.nibs_cq_qm_queueserial_log.etl_timestamp is 'ETL处理时间戳';
