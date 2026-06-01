/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a85cardctllist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a85cardctllist
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a85cardctllist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a85cardctllist(
    transtime varchar2(30) -- 操作时间
    ,systrace varchar2(30) -- 系统流水号
    ,channel varchar2(9) -- 受理渠道
    ,messageid varchar2(120) -- messgeid
    ,entitytype varchar2(30) -- 实体类型:token_pan云卡,original_pan主账号 chang_pan 主帐号更新
    ,value varchar2(60) -- 实体的值,根据entitytype确定
    ,custno varchar2(30) -- 客户号
    ,userid varchar2(30) -- 用户userid
    ,pan varchar2(60) -- 主账号
    ,tokenpan varchar2(75) -- 云卡标记
    ,operationreason varchar2(30) -- lock_unlock：锁定/解锁 lost_found：挂失/解挂
    ,reason varchar2(3) -- 操作原因:01 申请验证 02 申请激活码 03 激活 04 挂失 05 解挂 06 锁定 07解锁 08注销 09 主帐号更新
    ,state varchar2(2) -- 状态:0处理中,1成功,2失败
    ,orginalpan varchar2(60) -- 原始卡号
    ,newpan varchar2(60) -- 新卡号
    ,validdate varchar2(30) -- 新卡号的有效期(不换新卡时为原始卡号有效期)
    ,remark1 varchar2(300) -- 
    ,remark2 varchar2(300) -- 
    ,remark3 varchar2(300) -- 
    ,remark4 varchar2(300) -- 
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
grant select on ${iol_schema}.mpcs_a85cardctllist to ${iml_schema};
grant select on ${iol_schema}.mpcs_a85cardctllist to ${icl_schema};
grant select on ${iol_schema}.mpcs_a85cardctllist to ${idl_schema};
grant select on ${iol_schema}.mpcs_a85cardctllist to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a85cardctllist is '云卡或主账户操作流水表';
comment on column ${iol_schema}.mpcs_a85cardctllist.transtime is '操作时间';
comment on column ${iol_schema}.mpcs_a85cardctllist.systrace is '系统流水号';
comment on column ${iol_schema}.mpcs_a85cardctllist.channel is '受理渠道';
comment on column ${iol_schema}.mpcs_a85cardctllist.messageid is 'messgeid';
comment on column ${iol_schema}.mpcs_a85cardctllist.entitytype is '实体类型:token_pan云卡,original_pan主账号 chang_pan 主帐号更新';
comment on column ${iol_schema}.mpcs_a85cardctllist.value is '实体的值,根据entitytype确定';
comment on column ${iol_schema}.mpcs_a85cardctllist.custno is '客户号';
comment on column ${iol_schema}.mpcs_a85cardctllist.userid is '用户userid';
comment on column ${iol_schema}.mpcs_a85cardctllist.pan is '主账号';
comment on column ${iol_schema}.mpcs_a85cardctllist.tokenpan is '云卡标记';
comment on column ${iol_schema}.mpcs_a85cardctllist.operationreason is 'lock_unlock：锁定/解锁 lost_found：挂失/解挂';
comment on column ${iol_schema}.mpcs_a85cardctllist.reason is '操作原因:01 申请验证 02 申请激活码 03 激活 04 挂失 05 解挂 06 锁定 07解锁 08注销 09 主帐号更新';
comment on column ${iol_schema}.mpcs_a85cardctllist.state is '状态:0处理中,1成功,2失败';
comment on column ${iol_schema}.mpcs_a85cardctllist.orginalpan is '原始卡号';
comment on column ${iol_schema}.mpcs_a85cardctllist.newpan is '新卡号';
comment on column ${iol_schema}.mpcs_a85cardctllist.validdate is '新卡号的有效期(不换新卡时为原始卡号有效期)';
comment on column ${iol_schema}.mpcs_a85cardctllist.remark1 is '';
comment on column ${iol_schema}.mpcs_a85cardctllist.remark2 is '';
comment on column ${iol_schema}.mpcs_a85cardctllist.remark3 is '';
comment on column ${iol_schema}.mpcs_a85cardctllist.remark4 is '';
comment on column ${iol_schema}.mpcs_a85cardctllist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a85cardctllist.etl_timestamp is 'ETL处理时间戳';
