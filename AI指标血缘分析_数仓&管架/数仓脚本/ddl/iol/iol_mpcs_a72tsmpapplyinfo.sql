/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a72tsmpapplyinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a72tsmpapplyinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a72tsmpapplyinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a72tsmpapplyinfo(
    transdate varchar2(12) -- 申请日期
    ,transtime varchar2(9) -- 申请时间
    ,applystate varchar2(3) -- 应用申请状态:99已接收申请，待行方审核处理 00申请通过 01申请失败：使用rspmsg定义失败原因
    ,persnlstate varchar2(3) -- 应用个人化状态:99等待轮询处理 00个人化成功 01个人化失败 02个人化准备就绪 03已向人行返回个人化指令(因无sessionid，可能导致由状态5变为状态3) 04找不到个人化指令文件 05开卡申请未通过 06应用删除
    ,rspcd varchar2(12) -- 核心返回码
    ,rspmsg varchar2(384) -- 核心返回信息
    ,msgid varchar2(24) -- 报文标识号
    ,pamid varchar2(48) -- pamid
    ,instpaid varchar2(48) -- 实例paid
    ,acctno varchar2(53) -- 电子现金主账户
    ,periddata varchar2(24) -- 联机pin数据
    ,custno varchar2(30) -- 客户号
    ,certidtype varchar2(3) -- 证据类型
    ,certid varchar2(60) -- 证件号码
    ,pername varchar2(60) -- 姓名
    ,phoneid varchar2(23) -- 手机号码
    ,cardnm varchar2(36) -- 卡号
    ,stepnum varchar2(6) -- 步骤总数
    ,stepindex varchar2(6) -- 步骤序号
    ,dgifilename varchar2(75) -- dgi文件名
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
grant select on ${iol_schema}.mpcs_a72tsmpapplyinfo to ${iml_schema};
grant select on ${iol_schema}.mpcs_a72tsmpapplyinfo to ${icl_schema};
grant select on ${iol_schema}.mpcs_a72tsmpapplyinfo to ${idl_schema};
grant select on ${iol_schema}.mpcs_a72tsmpapplyinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a72tsmpapplyinfo is 'TSMP应用申请及个人化表';
comment on column ${iol_schema}.mpcs_a72tsmpapplyinfo.transdate is '申请日期';
comment on column ${iol_schema}.mpcs_a72tsmpapplyinfo.transtime is '申请时间';
comment on column ${iol_schema}.mpcs_a72tsmpapplyinfo.applystate is '应用申请状态:99已接收申请，待行方审核处理 00申请通过 01申请失败：使用rspmsg定义失败原因';
comment on column ${iol_schema}.mpcs_a72tsmpapplyinfo.persnlstate is '应用个人化状态:99等待轮询处理 00个人化成功 01个人化失败 02个人化准备就绪 03已向人行返回个人化指令(因无sessionid，可能导致由状态5变为状态3) 04找不到个人化指令文件 05开卡申请未通过 06应用删除';
comment on column ${iol_schema}.mpcs_a72tsmpapplyinfo.rspcd is '核心返回码';
comment on column ${iol_schema}.mpcs_a72tsmpapplyinfo.rspmsg is '核心返回信息';
comment on column ${iol_schema}.mpcs_a72tsmpapplyinfo.msgid is '报文标识号';
comment on column ${iol_schema}.mpcs_a72tsmpapplyinfo.pamid is 'pamid';
comment on column ${iol_schema}.mpcs_a72tsmpapplyinfo.instpaid is '实例paid';
comment on column ${iol_schema}.mpcs_a72tsmpapplyinfo.acctno is '电子现金主账户';
comment on column ${iol_schema}.mpcs_a72tsmpapplyinfo.periddata is '联机pin数据';
comment on column ${iol_schema}.mpcs_a72tsmpapplyinfo.custno is '客户号';
comment on column ${iol_schema}.mpcs_a72tsmpapplyinfo.certidtype is '证据类型';
comment on column ${iol_schema}.mpcs_a72tsmpapplyinfo.certid is '证件号码';
comment on column ${iol_schema}.mpcs_a72tsmpapplyinfo.pername is '姓名';
comment on column ${iol_schema}.mpcs_a72tsmpapplyinfo.phoneid is '手机号码';
comment on column ${iol_schema}.mpcs_a72tsmpapplyinfo.cardnm is '卡号';
comment on column ${iol_schema}.mpcs_a72tsmpapplyinfo.stepnum is '步骤总数';
comment on column ${iol_schema}.mpcs_a72tsmpapplyinfo.stepindex is '步骤序号';
comment on column ${iol_schema}.mpcs_a72tsmpapplyinfo.dgifilename is 'dgi文件名';
comment on column ${iol_schema}.mpcs_a72tsmpapplyinfo.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a72tsmpapplyinfo.etl_timestamp is 'ETL处理时间戳';
