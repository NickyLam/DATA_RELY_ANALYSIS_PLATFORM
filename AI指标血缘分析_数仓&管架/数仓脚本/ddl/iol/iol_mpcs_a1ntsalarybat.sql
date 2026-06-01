/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a1ntsalarybat
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a1ntsalarybat
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a1ntsalarybat purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1ntsalarybat(
    specialaccount varchar2(68) -- 专用账户号
    ,wagecode varchar2(51) -- 工资表编号
    ,wagestate varchar2(3) -- 工资表发放状态 0-未审核 1-已审核待录入 2-已审核待发放 3-已发放
    ,month varchar2(9) -- 工资月份
    ,total varchar2(24) -- 应发总金额     以分单位
    ,creatime varchar2(21) -- 创建时间
    ,remarks varchar2(750) -- 备注
    ,batstatus varchar2(3) -- 批次上报状态 00-待上报 01-上报成功 02-上报失败
    ,updt varchar2(21) -- 更新时间
    ,clockstatus varchar2(3) -- 交易状态 00-工资表待锁定 01-工资表已锁定 02-工资表详情获取成功 03-批次创建成功 04-批次创建失败 05-发放处理中 06-发放完成
    ,projno varchar2(18) -- 签约号
    ,acctna varchar2(120) -- 委托单位名称
    ,payacc varchar2(38) -- 代发账号
    ,paynam varchar2(120) -- 代发账号名称
    ,projtp varchar2(3) -- 类型
    ,bachdt varchar2(12) -- 批次日期
    ,bachsq varchar2(30) -- 批次流水
    ,times varchar2(3) -- 上报次数 最大值5次
    ,dfinstid varchar2(12) -- 代发工资机构标识
    ,totalnum varchar2(15) -- 代发笔数
    ,totalamt varchar2(23) -- 代发总金额
    ,bankserialno varchar2(45) -- 银行流水号
    ,requestip varchar2(45) -- 请求方ip地址
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.mpcs_a1ntsalarybat to ${iml_schema};
grant select on ${iol_schema}.mpcs_a1ntsalarybat to ${icl_schema};
grant select on ${iol_schema}.mpcs_a1ntsalarybat to ${idl_schema};
grant select on ${iol_schema}.mpcs_a1ntsalarybat to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a1ntsalarybat is '工资表批次表';
comment on column ${iol_schema}.mpcs_a1ntsalarybat.specialaccount is '专用账户号';
comment on column ${iol_schema}.mpcs_a1ntsalarybat.wagecode is '工资表编号';
comment on column ${iol_schema}.mpcs_a1ntsalarybat.wagestate is '工资表发放状态 0-未审核 1-已审核待录入 2-已审核待发放 3-已发放';
comment on column ${iol_schema}.mpcs_a1ntsalarybat.month is '工资月份';
comment on column ${iol_schema}.mpcs_a1ntsalarybat.total is '应发总金额     以分单位';
comment on column ${iol_schema}.mpcs_a1ntsalarybat.creatime is '创建时间';
comment on column ${iol_schema}.mpcs_a1ntsalarybat.remarks is '备注';
comment on column ${iol_schema}.mpcs_a1ntsalarybat.batstatus is '批次上报状态 00-待上报 01-上报成功 02-上报失败';
comment on column ${iol_schema}.mpcs_a1ntsalarybat.updt is '更新时间';
comment on column ${iol_schema}.mpcs_a1ntsalarybat.clockstatus is '交易状态 00-工资表待锁定 01-工资表已锁定 02-工资表详情获取成功 03-批次创建成功 04-批次创建失败 05-发放处理中 06-发放完成';
comment on column ${iol_schema}.mpcs_a1ntsalarybat.projno is '签约号';
comment on column ${iol_schema}.mpcs_a1ntsalarybat.acctna is '委托单位名称';
comment on column ${iol_schema}.mpcs_a1ntsalarybat.payacc is '代发账号';
comment on column ${iol_schema}.mpcs_a1ntsalarybat.paynam is '代发账号名称';
comment on column ${iol_schema}.mpcs_a1ntsalarybat.projtp is '类型';
comment on column ${iol_schema}.mpcs_a1ntsalarybat.bachdt is '批次日期';
comment on column ${iol_schema}.mpcs_a1ntsalarybat.bachsq is '批次流水';
comment on column ${iol_schema}.mpcs_a1ntsalarybat.times is '上报次数 最大值5次';
comment on column ${iol_schema}.mpcs_a1ntsalarybat.dfinstid is '代发工资机构标识';
comment on column ${iol_schema}.mpcs_a1ntsalarybat.totalnum is '代发笔数';
comment on column ${iol_schema}.mpcs_a1ntsalarybat.totalamt is '代发总金额';
comment on column ${iol_schema}.mpcs_a1ntsalarybat.bankserialno is '银行流水号';
comment on column ${iol_schema}.mpcs_a1ntsalarybat.requestip is '请求方ip地址';
comment on column ${iol_schema}.mpcs_a1ntsalarybat.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a1ntsalarybat.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a1ntsalarybat.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a1ntsalarybat.etl_timestamp is 'ETL处理时间戳';
