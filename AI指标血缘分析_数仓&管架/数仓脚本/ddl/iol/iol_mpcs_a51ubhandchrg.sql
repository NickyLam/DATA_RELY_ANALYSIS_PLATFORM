/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a51ubhandchrg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a51ubhandchrg
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a51ubhandchrg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a51ubhandchrg(
    trandate varchar2(12) -- 交易日期
    ,trantype varchar2(2) -- 交易方类型:i : 发卡方a : 受理方
    ,tranflag varchar2(12) -- 交易类型1 : atm2 : 柜面通3 : pos
    ,brnnbr varchar2(15) -- 机构号
    ,tranamt number(15,2) -- 应付金额
    ,recvamt number(15,2) -- 应收金额
    ,uniodate varchar2(12) -- 前置日期
    ,unionbr varchar2(96) -- 前置流水
    ,hostnbr varchar2(96) -- 主机流水
    ,hostdate varchar2(12) -- 主机日期
    ,status varchar2(2) -- 状态0 : 失效状态1 : 交易成功2 : 已冲正
    ,errcode varchar2(30) -- 错误码
    ,errmsg varchar2(288) -- 错误信息
    ,tranexamt number(15,2) -- 应付交换费
    ,recvexamt number(15,2) -- 应收交换费
    ,covamt number(15,2) -- 转接清算费
    ,remark1 varchar2(30) -- 保留
    ,remark2 varchar2(30) -- 保留
    ,old_busi_seq varchar2(96) -- 原交易流水号
    ,old_global_seq varchar2(96) -- 原全局流水号
    ,old_trn_seq varchar2(96) -- 原业务流水号
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
grant select on ${iol_schema}.mpcs_a51ubhandchrg to ${iml_schema};
grant select on ${iol_schema}.mpcs_a51ubhandchrg to ${icl_schema};
grant select on ${iol_schema}.mpcs_a51ubhandchrg to ${idl_schema};
grant select on ${iol_schema}.mpcs_a51ubhandchrg to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a51ubhandchrg is '银联手续费表';
comment on column ${iol_schema}.mpcs_a51ubhandchrg.trandate is '交易日期';
comment on column ${iol_schema}.mpcs_a51ubhandchrg.trantype is '交易方类型:i : 发卡方a : 受理方';
comment on column ${iol_schema}.mpcs_a51ubhandchrg.tranflag is '交易类型1 : atm2 : 柜面通3 : pos';
comment on column ${iol_schema}.mpcs_a51ubhandchrg.brnnbr is '机构号';
comment on column ${iol_schema}.mpcs_a51ubhandchrg.tranamt is '应付金额';
comment on column ${iol_schema}.mpcs_a51ubhandchrg.recvamt is '应收金额';
comment on column ${iol_schema}.mpcs_a51ubhandchrg.uniodate is '前置日期';
comment on column ${iol_schema}.mpcs_a51ubhandchrg.unionbr is '前置流水';
comment on column ${iol_schema}.mpcs_a51ubhandchrg.hostnbr is '主机流水';
comment on column ${iol_schema}.mpcs_a51ubhandchrg.hostdate is '主机日期';
comment on column ${iol_schema}.mpcs_a51ubhandchrg.status is '状态0 : 失效状态1 : 交易成功2 : 已冲正';
comment on column ${iol_schema}.mpcs_a51ubhandchrg.errcode is '错误码';
comment on column ${iol_schema}.mpcs_a51ubhandchrg.errmsg is '错误信息';
comment on column ${iol_schema}.mpcs_a51ubhandchrg.tranexamt is '应付交换费';
comment on column ${iol_schema}.mpcs_a51ubhandchrg.recvexamt is '应收交换费';
comment on column ${iol_schema}.mpcs_a51ubhandchrg.covamt is '转接清算费';
comment on column ${iol_schema}.mpcs_a51ubhandchrg.remark1 is '保留';
comment on column ${iol_schema}.mpcs_a51ubhandchrg.remark2 is '保留';
comment on column ${iol_schema}.mpcs_a51ubhandchrg.old_busi_seq is '原交易流水号';
comment on column ${iol_schema}.mpcs_a51ubhandchrg.old_global_seq is '原全局流水号';
comment on column ${iol_schema}.mpcs_a51ubhandchrg.old_trn_seq is '原业务流水号';
comment on column ${iol_schema}.mpcs_a51ubhandchrg.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a51ubhandchrg.etl_timestamp is 'ETL处理时间戳';
