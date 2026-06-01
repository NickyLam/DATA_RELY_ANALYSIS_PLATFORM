/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a51ubsrvfee
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a51ubsrvfee
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a51ubsrvfee purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a51ubsrvfee(
    trantype varchar2(2) -- 文件类型
    ,transdate varchar2(12) -- 前置交易日期
    ,acqinstid varchar2(17) -- 受理方标识码
    ,fwdinstid varchar2(17) -- 发送方标识码
    ,systrace varchar2(96) -- 系统跟踪号
    ,transtime varchar2(17) -- 交易时间
    ,acptermnlid varchar2(12) -- 受理终端标识码
    ,poscode varchar2(12) -- pos终端号
    ,procecode varchar2(9) -- 处理码
    ,transamt number(15,2) -- 交易金额
    ,hostnbr varchar2(96) -- 主机流水
    ,hostdate varchar2(12) -- 主机日期
    ,status varchar2(2) -- 状态：0 : 失效状态 1 : 交易成功 2 : 已冲正
    ,brnnbr varchar2(12) -- 机构号
    ,errcode varchar2(30) -- 错误码
    ,errmsg varchar2(288) -- 错误信息
    ,merchantcode varchar2(30) -- 商户代码
    ,brchbr varchar2(21) -- 
    ,busi_seq varchar2(96) -- 业务流水号
    ,global_seq varchar2(50) -- 全局流水号
    ,old_busi_seq varchar2(96) -- 原交易流水号
    ,old_global_seq varchar2(96) -- 原全局流水号
    ,old_trn_seq varchar2(96) -- 原业务流水号
    ,trn_seq varchar2(96) -- 交易流水号
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
grant select on ${iol_schema}.mpcs_a51ubsrvfee to ${iml_schema};
grant select on ${iol_schema}.mpcs_a51ubsrvfee to ${icl_schema};
grant select on ${iol_schema}.mpcs_a51ubsrvfee to ${idl_schema};
grant select on ${iol_schema}.mpcs_a51ubsrvfee to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a51ubsrvfee is '银联品牌服务费表';
comment on column ${iol_schema}.mpcs_a51ubsrvfee.trantype is '文件类型';
comment on column ${iol_schema}.mpcs_a51ubsrvfee.transdate is '前置交易日期';
comment on column ${iol_schema}.mpcs_a51ubsrvfee.acqinstid is '受理方标识码';
comment on column ${iol_schema}.mpcs_a51ubsrvfee.fwdinstid is '发送方标识码';
comment on column ${iol_schema}.mpcs_a51ubsrvfee.systrace is '系统跟踪号';
comment on column ${iol_schema}.mpcs_a51ubsrvfee.transtime is '交易时间';
comment on column ${iol_schema}.mpcs_a51ubsrvfee.acptermnlid is '受理终端标识码';
comment on column ${iol_schema}.mpcs_a51ubsrvfee.poscode is 'pos终端号';
comment on column ${iol_schema}.mpcs_a51ubsrvfee.procecode is '处理码';
comment on column ${iol_schema}.mpcs_a51ubsrvfee.transamt is '交易金额';
comment on column ${iol_schema}.mpcs_a51ubsrvfee.hostnbr is '主机流水';
comment on column ${iol_schema}.mpcs_a51ubsrvfee.hostdate is '主机日期';
comment on column ${iol_schema}.mpcs_a51ubsrvfee.status is '状态：0 : 失效状态 1 : 交易成功 2 : 已冲正';
comment on column ${iol_schema}.mpcs_a51ubsrvfee.brnnbr is '机构号';
comment on column ${iol_schema}.mpcs_a51ubsrvfee.errcode is '错误码';
comment on column ${iol_schema}.mpcs_a51ubsrvfee.errmsg is '错误信息';
comment on column ${iol_schema}.mpcs_a51ubsrvfee.merchantcode is '商户代码';
comment on column ${iol_schema}.mpcs_a51ubsrvfee.brchbr is '';
comment on column ${iol_schema}.mpcs_a51ubsrvfee.busi_seq is '业务流水号';
comment on column ${iol_schema}.mpcs_a51ubsrvfee.global_seq is '全局流水号';
comment on column ${iol_schema}.mpcs_a51ubsrvfee.old_busi_seq is '原交易流水号';
comment on column ${iol_schema}.mpcs_a51ubsrvfee.old_global_seq is '原全局流水号';
comment on column ${iol_schema}.mpcs_a51ubsrvfee.old_trn_seq is '原业务流水号';
comment on column ${iol_schema}.mpcs_a51ubsrvfee.trn_seq is '交易流水号';
comment on column ${iol_schema}.mpcs_a51ubsrvfee.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a51ubsrvfee.etl_timestamp is 'ETL处理时间戳';
