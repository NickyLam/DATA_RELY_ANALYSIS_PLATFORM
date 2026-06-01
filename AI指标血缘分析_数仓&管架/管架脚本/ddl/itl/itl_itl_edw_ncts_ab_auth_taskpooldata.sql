/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_ncts_ab_auth_taskpooldata
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata(
    authdate varchar2(8) -- 授权日期
    ,authserno varchar2(30) -- 授权流水
    ,authorgno varchar2(10) -- 授权机构
    ,taskpoolid varchar2(10) -- 任务池
    ,authlevel varchar2(2) -- 授权级别
    ,entrytime varchar2(6) -- 进入任务池时间
    ,outtime varchar2(6) -- 取出任务池时间
    ,waittime number(22,0) -- 任务排队时间
    ,status varchar2(2) -- 任务状态;0,未获取;1,获取
    ,authtellerno varchar2(50) -- 授权柜员
    ,weight number(2,0) -- 权重值
    ,aboid varchar2(150) -- 客户端ID
    ,tradeid varchar2(150) -- 交易ID
    ,tradeserno varchar2(24) -- 交易流水号
    ,flag varchar2(1) -- 详细任务标志：0-退件；1-拒绝;2-后补件退件
    ,queuenum varchar2(5) -- 
    ,trademode varchar2(1) -- 交易模式（1-单交易模式，2-交易包模式）
    ,cartorder number(3,0) -- 购物车授权任务顺序，从1开始
    ,makeupsn varchar2(32) -- 购物车组合流水
    ,times number(3,0) -- 提交购物车批次数（跟购物车组合流水一起，唯一标示每一批购物车交易）
    ,replenish_status varchar2(1) -- 补件状态
    ,bj_tellerno varchar2(50) -- 补件人员
    ,fqbj_tellerno varchar2(50) -- 发起后补件人员
    ,bj_authtellerno varchar2(50) -- 后补件授权柜员
    ,fqbj_date varchar2(8) -- 发起补件日期
    ,fqbj_time varchar2(6) -- 发起补件时间
    ,bj_authdate varchar2(8) -- 补件授权日期
    ,bj_authtime varchar2(6) -- 补件授权时间
    ,bj_successtime varchar2(6) -- 补件成功时间
    ,bj_lastoptdate varchar2(8) -- 补件任务最新操作日期
    ,replenishflag varchar2(1) -- 补件标记。1-后补件;0-默认值，原授权任务，非后补件
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata to ${idl_schema};

-- comment
comment on table ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata is '授权任务池数据';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata.authdate is '授权日期';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata.authserno is '授权流水';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata.authorgno is '授权机构';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata.taskpoolid is '任务池';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata.authlevel is '授权级别';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata.entrytime is '进入任务池时间';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata.outtime is '取出任务池时间';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata.waittime is '任务排队时间';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata.status is '任务状态;0,未获取;1,获取';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata.authtellerno is '授权柜员';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata.weight is '权重值';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata.aboid is '客户端ID';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata.tradeid is '交易ID';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata.tradeserno is '交易流水号';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata.flag is '详细任务标志：0-退件；1-拒绝;2-后补件退件';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata.queuenum is '';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata.trademode is '交易模式（1-单交易模式，2-交易包模式）';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata.cartorder is '购物车授权任务顺序，从1开始';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata.makeupsn is '购物车组合流水';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata.times is '提交购物车批次数（跟购物车组合流水一起，唯一标示每一批购物车交易）';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata.replenish_status is '补件状态';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata.bj_tellerno is '补件人员';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata.fqbj_tellerno is '发起后补件人员';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata.bj_authtellerno is '后补件授权柜员';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata.fqbj_date is '发起补件日期';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata.fqbj_time is '发起补件时间';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata.bj_authdate is '补件授权日期';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata.bj_authtime is '补件授权时间';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata.bj_successtime is '补件成功时间';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata.bj_lastoptdate is '补件任务最新操作日期';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata.replenishflag is '补件标记。1-后补件;0-默认值，原授权任务，非后补件';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata.start_dt is '开始时间';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata.end_dt is '结束时间';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata.id_mark is '增删标志';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooldata.etl_timestamp is 'ETL处理时间戳';