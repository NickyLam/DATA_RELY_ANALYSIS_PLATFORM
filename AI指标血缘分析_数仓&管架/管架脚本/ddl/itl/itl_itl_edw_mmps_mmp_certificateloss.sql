/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_mmps_mmp_certificateloss
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_mmps_mmp_certificateloss
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_mmps_mmp_certificateloss purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_mmps_mmp_certificateloss(
    etl_dt date -- 数据日期
    ,scanseqno varchar2(30) -- 扫描流水号
    ,acctno varchar2(32) -- 账号
    ,idtftp varchar2(1) -- 证件类型
    ,idtfno varchar2(20) -- 证件号码
    ,custna varchar2(40) -- 证件姓名
    ,idtaddress varchar2(100) -- 证件地址
    ,idtdt varchar2(8) -- 证件有效期
    ,stpytg varchar2(1) -- 挂失类型
    ,rplsfs varchar2(1) -- 挂失形式
    ,vouchertype varchar2(10) -- 凭证类型
    ,voucherno varchar2(20) -- 凭证号码
    ,payway varchar2(1) -- 支取方式
    ,rpcdtg varchar2(1) -- 是否申请永久卡
    ,undays varchar2(1) -- 挂失天数
    ,isproxy varchar2(1) -- 是否代理挂失
    ,proxytype varchar2(1) -- 代理人证件类型
    ,proxycode varchar2(32) -- 代理人证件号码
    ,proxyname varchar2(100) -- 代理人证件名称
    ,nodeid varchar2(32) -- 节点号
    ,pswd varchar2(20) -- 交易密码
    ,mobile varchar2(20) -- 手机号码
    ,bizcode varchar2(6) -- 业务编码
    ,idcheckresult varchar2(2) -- 联网核查结果
    ,transresult varchar2(1000) -- 交易结果
    ,uptime timestamp(6) -- 更新时间
    ,etl_timestamp timestamp -- ETL处理时间戳
   -- ,job_cd varchar2(10) -- 任务编码
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_mmps_mmp_certificateloss to ${iel_schema};

-- comment
comment on table ${itl_schema}.itl_edw_mmps_mmp_certificateloss is '凭证挂失交易信息表';
comment on column ${itl_schema}.itl_edw_mmps_mmp_certificateloss.etl_dt is '数据日期';
comment on column ${itl_schema}.itl_edw_mmps_mmp_certificateloss.scanseqno is '扫描流水号';
comment on column ${itl_schema}.itl_edw_mmps_mmp_certificateloss.acctno is '账号';
comment on column ${itl_schema}.itl_edw_mmps_mmp_certificateloss.idtftp is '证件类型';
comment on column ${itl_schema}.itl_edw_mmps_mmp_certificateloss.idtfno is '证件号码';
comment on column ${itl_schema}.itl_edw_mmps_mmp_certificateloss.custna is '证件姓名';
comment on column ${itl_schema}.itl_edw_mmps_mmp_certificateloss.idtaddress is '证件地址';
comment on column ${itl_schema}.itl_edw_mmps_mmp_certificateloss.idtdt is '证件有效期';
comment on column ${itl_schema}.itl_edw_mmps_mmp_certificateloss.stpytg is '挂失类型';
comment on column ${itl_schema}.itl_edw_mmps_mmp_certificateloss.rplsfs is '挂失形式';
comment on column ${itl_schema}.itl_edw_mmps_mmp_certificateloss.vouchertype is '凭证类型';
comment on column ${itl_schema}.itl_edw_mmps_mmp_certificateloss.voucherno is '凭证号码';
comment on column ${itl_schema}.itl_edw_mmps_mmp_certificateloss.payway is '支取方式';
comment on column ${itl_schema}.itl_edw_mmps_mmp_certificateloss.rpcdtg is '是否申请永久卡';
comment on column ${itl_schema}.itl_edw_mmps_mmp_certificateloss.undays is '挂失天数';
comment on column ${itl_schema}.itl_edw_mmps_mmp_certificateloss.isproxy is '是否代理挂失';
comment on column ${itl_schema}.itl_edw_mmps_mmp_certificateloss.proxytype is '代理人证件类型';
comment on column ${itl_schema}.itl_edw_mmps_mmp_certificateloss.proxycode is '代理人证件号码';
comment on column ${itl_schema}.itl_edw_mmps_mmp_certificateloss.proxyname is '代理人证件名称';
comment on column ${itl_schema}.itl_edw_mmps_mmp_certificateloss.nodeid is '节点号';
comment on column ${itl_schema}.itl_edw_mmps_mmp_certificateloss.pswd is '交易密码';
comment on column ${itl_schema}.itl_edw_mmps_mmp_certificateloss.mobile is '手机号码';
comment on column ${itl_schema}.itl_edw_mmps_mmp_certificateloss.bizcode is '业务编码';
comment on column ${itl_schema}.itl_edw_mmps_mmp_certificateloss.idcheckresult is '联网核查结果';
comment on column ${itl_schema}.itl_edw_mmps_mmp_certificateloss.transresult is '交易结果';
comment on column ${itl_schema}.itl_edw_mmps_mmp_certificateloss.uptime is '更新时间';
comment on column ${itl_schema}.itl_edw_mmps_mmp_certificateloss.etl_timestamp is 'ETL处理时间戳';