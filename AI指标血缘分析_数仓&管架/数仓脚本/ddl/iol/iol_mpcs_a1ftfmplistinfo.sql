/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a1ftfmplistinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a1ftfmplistinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a1ftfmplistinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1ftfmplistinfo(
    mainseq varchar2(30) -- 中台流水号
    ,transdt varchar2(12) -- 中台交易日期
    ,transtm varchar2(9) -- 中台交易时间
    ,syscd varchar2(15) -- 系统编号
    ,bustype varchar2(15) -- 业务类型
    ,interfacename varchar2(45) -- 接口方法名
    ,transseq varchar2(48) -- 交易流水号
    ,openbrn varchar2(12) -- 开户机构
    ,status varchar2(3) -- 交易状态：z_初始，s_成功，f_失败，w_处理中
    ,retcode varchar2(15) -- 返回码
    ,retmsg varchar2(300) -- 返回结果
    ,trnum varchar2(3) -- 交易次数
    ,brcno varchar2(9) -- 处理机构
    ,tlrno varchar2(15) -- 经办柜员
    ,ckbkus varchar2(15) -- 授权柜员
    ,dealdate varchar2(45) -- 处理时间
    ,dealst varchar2(3) -- 处理结果：s_成功，f_失败
    ,iotype varchar2(2) -- 交易方向：0_发出，1_接收
    ,querystartdate varchar2(21) -- 查询开始日期
    ,queryenddate varchar2(21) -- 查询结束日期
    ,account varchar2(60) -- 监管账号
    ,msgid varchar2(75) -- 业务报文id
    ,areacode varchar2(75) -- 地区编码
    ,organcode varchar2(75) -- 机构编码
    ,globseqnum varchar2(60) -- 全局流水号
    ,uniqueseqnum varchar2(60) -- 业务流水号
    ,srvtrxseq varchar2(60) -- 上游系统内流水号
    ,ztstrnseqno varchar2(60) -- 系统内流水号
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
grant select on ${iol_schema}.mpcs_a1ftfmplistinfo to ${iml_schema};
grant select on ${iol_schema}.mpcs_a1ftfmplistinfo to ${icl_schema};
grant select on ${iol_schema}.mpcs_a1ftfmplistinfo to ${idl_schema};
grant select on ${iol_schema}.mpcs_a1ftfmplistinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a1ftfmplistinfo is '请求、推送总表';
comment on column ${iol_schema}.mpcs_a1ftfmplistinfo.mainseq is '中台流水号';
comment on column ${iol_schema}.mpcs_a1ftfmplistinfo.transdt is '中台交易日期';
comment on column ${iol_schema}.mpcs_a1ftfmplistinfo.transtm is '中台交易时间';
comment on column ${iol_schema}.mpcs_a1ftfmplistinfo.syscd is '系统编号';
comment on column ${iol_schema}.mpcs_a1ftfmplistinfo.bustype is '业务类型';
comment on column ${iol_schema}.mpcs_a1ftfmplistinfo.interfacename is '接口方法名';
comment on column ${iol_schema}.mpcs_a1ftfmplistinfo.transseq is '交易流水号';
comment on column ${iol_schema}.mpcs_a1ftfmplistinfo.openbrn is '开户机构';
comment on column ${iol_schema}.mpcs_a1ftfmplistinfo.status is '交易状态：z_初始，s_成功，f_失败，w_处理中';
comment on column ${iol_schema}.mpcs_a1ftfmplistinfo.retcode is '返回码';
comment on column ${iol_schema}.mpcs_a1ftfmplistinfo.retmsg is '返回结果';
comment on column ${iol_schema}.mpcs_a1ftfmplistinfo.trnum is '交易次数';
comment on column ${iol_schema}.mpcs_a1ftfmplistinfo.brcno is '处理机构';
comment on column ${iol_schema}.mpcs_a1ftfmplistinfo.tlrno is '经办柜员';
comment on column ${iol_schema}.mpcs_a1ftfmplistinfo.ckbkus is '授权柜员';
comment on column ${iol_schema}.mpcs_a1ftfmplistinfo.dealdate is '处理时间';
comment on column ${iol_schema}.mpcs_a1ftfmplistinfo.dealst is '处理结果：s_成功，f_失败';
comment on column ${iol_schema}.mpcs_a1ftfmplistinfo.iotype is '交易方向：0_发出，1_接收';
comment on column ${iol_schema}.mpcs_a1ftfmplistinfo.querystartdate is '查询开始日期';
comment on column ${iol_schema}.mpcs_a1ftfmplistinfo.queryenddate is '查询结束日期';
comment on column ${iol_schema}.mpcs_a1ftfmplistinfo.account is '监管账号';
comment on column ${iol_schema}.mpcs_a1ftfmplistinfo.msgid is '业务报文id';
comment on column ${iol_schema}.mpcs_a1ftfmplistinfo.areacode is '地区编码';
comment on column ${iol_schema}.mpcs_a1ftfmplistinfo.organcode is '机构编码';
comment on column ${iol_schema}.mpcs_a1ftfmplistinfo.globseqnum is '全局流水号';
comment on column ${iol_schema}.mpcs_a1ftfmplistinfo.uniqueseqnum is '业务流水号';
comment on column ${iol_schema}.mpcs_a1ftfmplistinfo.srvtrxseq is '上游系统内流水号';
comment on column ${iol_schema}.mpcs_a1ftfmplistinfo.ztstrnseqno is '系统内流水号';
comment on column ${iol_schema}.mpcs_a1ftfmplistinfo.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a1ftfmplistinfo.etl_timestamp is 'ETL处理时间戳';
