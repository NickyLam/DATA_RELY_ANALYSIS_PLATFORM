/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a51ubqingsd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a51ubqingsd
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a51ubqingsd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a51ubqingsd(
    transdate varchar2(12) -- 交易日期
    ,acceptfx varchar2(2) -- 交易方类型1 : 发送方2 : 接收方
    ,transtype varchar2(2) -- 交易类型1 : 取现 2 : 预授权完成(联机) 3 : 预授权完成撤销 4 : 消费 5 : 消费撤销 6 : 结算通知 7 : 联机退货 8 : 代付撤销 9 : 存款 a : 转帐 b : 转出 c : 转入 d : 存款撤销 e : 贷记调整
    ,ttlamt number(15,2) -- 总金额
    ,conscnt varchar2(15) -- 总笔数
    ,revamt number(15,2) -- 冲正金额
    ,revcnt varchar2(15) -- 冲正笔数
    ,feeamt number(15,2) -- 手续费金额
    ,netamt number(15,2) -- 净金额
    ,transname varchar2(240) -- 交易名称
    ,brchbr varchar2(21) -- 
    ,covamt number(15,2) -- 转接清算费
    ,remark1 varchar2(30) -- 保留
    ,remark2 varchar2(30) -- 保留
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
grant select on ${iol_schema}.mpcs_a51ubqingsd to ${iml_schema};
grant select on ${iol_schema}.mpcs_a51ubqingsd to ${icl_schema};
grant select on ${iol_schema}.mpcs_a51ubqingsd to ${idl_schema};
grant select on ${iol_schema}.mpcs_a51ubqingsd to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a51ubqingsd is '接收银联清算文件SUMCN表';
comment on column ${iol_schema}.mpcs_a51ubqingsd.transdate is '交易日期';
comment on column ${iol_schema}.mpcs_a51ubqingsd.acceptfx is '交易方类型1 : 发送方2 : 接收方';
comment on column ${iol_schema}.mpcs_a51ubqingsd.transtype is '交易类型1 : 取现 2 : 预授权完成(联机) 3 : 预授权完成撤销 4 : 消费 5 : 消费撤销 6 : 结算通知 7 : 联机退货 8 : 代付撤销 9 : 存款 a : 转帐 b : 转出 c : 转入 d : 存款撤销 e : 贷记调整';
comment on column ${iol_schema}.mpcs_a51ubqingsd.ttlamt is '总金额';
comment on column ${iol_schema}.mpcs_a51ubqingsd.conscnt is '总笔数';
comment on column ${iol_schema}.mpcs_a51ubqingsd.revamt is '冲正金额';
comment on column ${iol_schema}.mpcs_a51ubqingsd.revcnt is '冲正笔数';
comment on column ${iol_schema}.mpcs_a51ubqingsd.feeamt is '手续费金额';
comment on column ${iol_schema}.mpcs_a51ubqingsd.netamt is '净金额';
comment on column ${iol_schema}.mpcs_a51ubqingsd.transname is '交易名称';
comment on column ${iol_schema}.mpcs_a51ubqingsd.brchbr is '';
comment on column ${iol_schema}.mpcs_a51ubqingsd.covamt is '转接清算费';
comment on column ${iol_schema}.mpcs_a51ubqingsd.remark1 is '保留';
comment on column ${iol_schema}.mpcs_a51ubqingsd.remark2 is '保留';
comment on column ${iol_schema}.mpcs_a51ubqingsd.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a51ubqingsd.etl_timestamp is 'ETL处理时间戳';
