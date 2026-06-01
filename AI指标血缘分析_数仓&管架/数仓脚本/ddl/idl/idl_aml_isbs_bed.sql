/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_isbs_bed
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_isbs_bed
whenever sqlerror continue none;
drop table ${idl_schema}.aml_isbs_bed purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_isbs_bed(
    etl_dt date -- 数据日期
    ,inr varchar2(8) -- 出口单据ID
    ,ownref varchar2(16) -- 参考号
    ,nam varchar2(40) -- 交易名称
    ,pnttyp varchar2(6) -- 父类交易类型
    ,pntinr varchar2(8) -- 父交易
    ,predat date -- 提示日期
    ,rcvdat date -- 到单日期
    ,shpdat date -- 装船日期
    ,advdat date -- 通知日期
    ,matdat date -- 效期终止日期
    ,doctypcod varchar2(1) -- 单据类型
    ,opndat date -- 开始日期
    ,clsdat date -- 结束日期
    ,credat date -- 开证日期
    ,ownusr varchar2(8) -- 负责人
    ,ver varchar2(4) -- 版本号
    ,approvcod varchar2(1) -- 凭保议付标志
    ,frepayflg varchar2(1) -- 无偿放单标志
    ,docprbrol varchar2(3) -- 出单人
    ,payrol varchar2(3) -- 付款人
    ,orddat date -- 保证金信件收到日
    ,mattxtflg varchar2(1) -- 混合付款标志
    ,dscinsflg varchar2(1) -- 不符点标志
    ,acpnowflg varchar2(1) -- 现在承兑标志
    ,advtyp varchar2(3) -- 收到通知类型
    ,disdat date -- 不符点通知时间
    ,totcur varchar2(3) -- 付款货币
    ,totamt number(18,3) -- 付款总金额
    ,totdat date -- 付款时间
    ,docsta varchar2(40) -- 单据状态
    ,docrol varchar2(3) -- 单据接受者
    ,docrolflg varchar2(1) -- 送单到其他地址标志
    ,dta770snd date -- 回执信息发送时间
    ,advdocflg varchar2(1) -- 返还单据标志
    ,etyextkey varchar2(8) -- 用户所在组的关键字
    ,rmbrol varchar2(3) -- 偿付行
    ,lescom number(18,3) -- 国外扣费
    ,bchkeyinr varchar2(8) -- 经办机构号
    ,branchinr varchar2(8) -- 所属机构号
    ,nraflg varchar2(1) -- NRA付款标志
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.aml_isbs_bed to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_isbs_bed is '出口信用证下单据信息(存放短字节内容)';
comment on column ${idl_schema}.aml_isbs_bed.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_isbs_bed.inr is '出口单据ID';
comment on column ${idl_schema}.aml_isbs_bed.ownref is '参考号';
comment on column ${idl_schema}.aml_isbs_bed.nam is '交易名称';
comment on column ${idl_schema}.aml_isbs_bed.pnttyp is '父类交易类型';
comment on column ${idl_schema}.aml_isbs_bed.pntinr is '父交易';
comment on column ${idl_schema}.aml_isbs_bed.predat is '提示日期';
comment on column ${idl_schema}.aml_isbs_bed.rcvdat is '到单日期';
comment on column ${idl_schema}.aml_isbs_bed.shpdat is '装船日期';
comment on column ${idl_schema}.aml_isbs_bed.advdat is '通知日期';
comment on column ${idl_schema}.aml_isbs_bed.matdat is '效期终止日期';
comment on column ${idl_schema}.aml_isbs_bed.doctypcod is '单据类型';
comment on column ${idl_schema}.aml_isbs_bed.opndat is '开始日期';
comment on column ${idl_schema}.aml_isbs_bed.clsdat is '结束日期';
comment on column ${idl_schema}.aml_isbs_bed.credat is '开证日期';
comment on column ${idl_schema}.aml_isbs_bed.ownusr is '负责人';
comment on column ${idl_schema}.aml_isbs_bed.ver is '版本号';
comment on column ${idl_schema}.aml_isbs_bed.approvcod is '凭保议付标志';
comment on column ${idl_schema}.aml_isbs_bed.frepayflg is '无偿放单标志';
comment on column ${idl_schema}.aml_isbs_bed.docprbrol is '出单人';
comment on column ${idl_schema}.aml_isbs_bed.payrol is '付款人';
comment on column ${idl_schema}.aml_isbs_bed.orddat is '保证金信件收到日';
comment on column ${idl_schema}.aml_isbs_bed.mattxtflg is '混合付款标志';
comment on column ${idl_schema}.aml_isbs_bed.dscinsflg is '不符点标志';
comment on column ${idl_schema}.aml_isbs_bed.acpnowflg is '现在承兑标志';
comment on column ${idl_schema}.aml_isbs_bed.advtyp is '收到通知类型';
comment on column ${idl_schema}.aml_isbs_bed.disdat is '不符点通知时间';
comment on column ${idl_schema}.aml_isbs_bed.totcur is '付款货币';
comment on column ${idl_schema}.aml_isbs_bed.totamt is '付款总金额';
comment on column ${idl_schema}.aml_isbs_bed.totdat is '付款时间';
comment on column ${idl_schema}.aml_isbs_bed.docsta is '单据状态';
comment on column ${idl_schema}.aml_isbs_bed.docrol is '单据接受者';
comment on column ${idl_schema}.aml_isbs_bed.docrolflg is '送单到其他地址标志';
comment on column ${idl_schema}.aml_isbs_bed.dta770snd is '回执信息发送时间';
comment on column ${idl_schema}.aml_isbs_bed.advdocflg is '返还单据标志';
comment on column ${idl_schema}.aml_isbs_bed.etyextkey is '用户所在组的关键字';
comment on column ${idl_schema}.aml_isbs_bed.rmbrol is '偿付行';
comment on column ${idl_schema}.aml_isbs_bed.lescom is '国外扣费';
comment on column ${idl_schema}.aml_isbs_bed.bchkeyinr is '经办机构号';
comment on column ${idl_schema}.aml_isbs_bed.branchinr is '所属机构号';
comment on column ${idl_schema}.aml_isbs_bed.nraflg is 'NRA付款标志';
comment on column ${idl_schema}.aml_isbs_bed.etl_timestamp is '数据处理时间';
