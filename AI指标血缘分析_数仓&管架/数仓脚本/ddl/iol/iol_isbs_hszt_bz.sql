/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_hszt_bz
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_hszt_bz
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_hszt_bz purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_hszt_bz(
    inr varchar2(12) -- 主键
    ,trninr varchar2(12) -- trn表inr
    ,credattim timestamp -- 创建时间
    ,systid varchar2(15) -- 修改域的列表
    ,trandt varchar2(12) -- 核心日期
    ,bsnssq varchar2(50) -- 利息说明
    ,transq varchar2(96) -- 核心流水
    ,serino varchar2(12) -- 头寸货物
    ,tranbr varchar2(14) -- 交易机构
    ,acctbr varchar2(14) -- 账户机构
    ,prcscd varchar2(24) -- 自由文本信息
    ,evetdn varchar2(8) -- 提示单据
    ,trprcd varchar2(24) -- 代收细节
    ,crcycd varchar2(5) -- 币种
    ,tranam number(20,2) -- 交易金额
    ,acctno varchar2(45) -- 交易账号
    ,assis0 varchar2(15) -- 收货说明
    ,assis1 varchar2(45) -- 费用文本
    ,chrex0 varchar2(15) -- 票据说明
    ,chrex1 varchar2(15) -- 其他指示
    ,chrex2 varchar2(2) -- 放货地址
    ,bzsta varchar2(2) -- 船名
    ,times number(2,0) -- 次数
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
grant select on ${iol_schema}.isbs_hszt_bz to ${iml_schema};
grant select on ${iol_schema}.isbs_hszt_bz to ${icl_schema};
grant select on ${iol_schema}.isbs_hszt_bz to ${idl_schema};
grant select on ${iol_schema}.isbs_hszt_bz to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_hszt_bz is '核算中台对账表';
comment on column ${iol_schema}.isbs_hszt_bz.inr is '主键';
comment on column ${iol_schema}.isbs_hszt_bz.trninr is 'trn表inr';
comment on column ${iol_schema}.isbs_hszt_bz.credattim is '创建时间';
comment on column ${iol_schema}.isbs_hszt_bz.systid is '修改域的列表';
comment on column ${iol_schema}.isbs_hszt_bz.trandt is '核心日期';
comment on column ${iol_schema}.isbs_hszt_bz.bsnssq is '利息说明';
comment on column ${iol_schema}.isbs_hszt_bz.transq is '核心流水';
comment on column ${iol_schema}.isbs_hszt_bz.serino is '头寸货物';
comment on column ${iol_schema}.isbs_hszt_bz.tranbr is '交易机构';
comment on column ${iol_schema}.isbs_hszt_bz.acctbr is '账户机构';
comment on column ${iol_schema}.isbs_hszt_bz.prcscd is '自由文本信息';
comment on column ${iol_schema}.isbs_hszt_bz.evetdn is '提示单据';
comment on column ${iol_schema}.isbs_hszt_bz.trprcd is '代收细节';
comment on column ${iol_schema}.isbs_hszt_bz.crcycd is '币种';
comment on column ${iol_schema}.isbs_hszt_bz.tranam is '交易金额';
comment on column ${iol_schema}.isbs_hszt_bz.acctno is '交易账号';
comment on column ${iol_schema}.isbs_hszt_bz.assis0 is '收货说明';
comment on column ${iol_schema}.isbs_hszt_bz.assis1 is '费用文本';
comment on column ${iol_schema}.isbs_hszt_bz.chrex0 is '票据说明';
comment on column ${iol_schema}.isbs_hszt_bz.chrex1 is '其他指示';
comment on column ${iol_schema}.isbs_hszt_bz.chrex2 is '放货地址';
comment on column ${iol_schema}.isbs_hszt_bz.bzsta is '船名';
comment on column ${iol_schema}.isbs_hszt_bz.times is '次数';
comment on column ${iol_schema}.isbs_hszt_bz.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_hszt_bz.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_hszt_bz.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_hszt_bz.etl_timestamp is 'ETL处理时间戳';
