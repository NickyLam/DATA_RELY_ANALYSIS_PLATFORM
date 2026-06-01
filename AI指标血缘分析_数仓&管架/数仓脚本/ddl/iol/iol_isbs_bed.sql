/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_bed
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_bed
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_bed purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_bed(
    inr varchar2(12) -- 出口单据id
    ,ownref varchar2(24) -- 参考号
    ,nam varchar2(60) -- 交易名称
    ,pnttyp varchar2(9) -- 父类交易类型
    ,pntinr varchar2(12) -- 父交易
    ,predat date -- 提示日期
    ,rcvdat date -- 到单日期
    ,shpdat date -- 装船日期
    ,advdat date -- 通知日期
    ,matdat date -- 效期终止日期
    ,doctypcod varchar2(2) -- 单据类型
    ,opndat date -- 开始日期
    ,clsdat date -- 结束日期
    ,credat date -- 开证日期
    ,ownusr varchar2(12) -- 负责人
    ,ver varchar2(6) -- 版本号
    ,approvcod varchar2(2) -- 凭保议付标志
    ,frepayflg varchar2(2) -- 无偿放单标志
    ,docprbrol varchar2(5) -- 出单人
    ,payrol varchar2(5) -- 付款人
    ,orddat date -- 保证金信件收到日
    ,mattxtflg varchar2(2) -- 混合付款标志
    ,dscinsflg varchar2(2) -- 不符点标志
    ,acpnowflg varchar2(2) -- 现在承兑标志
    ,advtyp varchar2(5) -- 收到通知类型
    ,disdat date -- 不符点通知时间
    ,totcur varchar2(5) -- 付款货币
    ,totamt number(18,3) -- 付款总金额
    ,totdat date -- 付款时间
    ,docsta varchar2(60) -- 单据状态
    ,docrol varchar2(5) -- 单据接受者
    ,docrolflg varchar2(2) -- 送单到其他地址标志
    ,dta770snd date -- 回执信息发送时间
    ,advdocflg varchar2(2) -- 返还单据标志
    ,etyextkey varchar2(12) -- 用户所在组的关键字
    ,rmbrol varchar2(5) -- 偿付行
    ,lescom number(18,3) -- 国外扣费
    ,bchkeyinr varchar2(12) -- 经办机构号
    ,branchinr varchar2(12) -- 所属机构号
    ,nraflg varchar2(2) -- nra付款标志
    ,trpdocnum varchar2(60) -- 船运单号
    ,trpdoctyp varchar2(9) -- 船运类型
    ,tradat date -- 船单据日期
    ,tramod varchar2(9) -- 运单方式
    ,blnum varchar2(30) -- 单据编号
    ,connum varchar2(53) -- 合同号
    ,invnum varchar2(45) -- 发票号
    ,porlod varchar2(60) -- 装运港
    ,portrs varchar2(60) -- 转运港
    ,pordis varchar2(60) -- 卸货港
    ,delplc varchar2(60) -- 传送地
    ,vesnam varchar2(60) -- 船名
    ,voynum varchar2(45) -- 船次
    ,carnam varchar2(53) -- 提单者
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
grant select on ${iol_schema}.isbs_bed to ${iml_schema};
grant select on ${iol_schema}.isbs_bed to ${icl_schema};
grant select on ${iol_schema}.isbs_bed to ${idl_schema};
grant select on ${iol_schema}.isbs_bed to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_bed is '出口信用证下单据信息(存放短字节内容)';
comment on column ${iol_schema}.isbs_bed.inr is '出口单据id';
comment on column ${iol_schema}.isbs_bed.ownref is '参考号';
comment on column ${iol_schema}.isbs_bed.nam is '交易名称';
comment on column ${iol_schema}.isbs_bed.pnttyp is '父类交易类型';
comment on column ${iol_schema}.isbs_bed.pntinr is '父交易';
comment on column ${iol_schema}.isbs_bed.predat is '提示日期';
comment on column ${iol_schema}.isbs_bed.rcvdat is '到单日期';
comment on column ${iol_schema}.isbs_bed.shpdat is '装船日期';
comment on column ${iol_schema}.isbs_bed.advdat is '通知日期';
comment on column ${iol_schema}.isbs_bed.matdat is '效期终止日期';
comment on column ${iol_schema}.isbs_bed.doctypcod is '单据类型';
comment on column ${iol_schema}.isbs_bed.opndat is '开始日期';
comment on column ${iol_schema}.isbs_bed.clsdat is '结束日期';
comment on column ${iol_schema}.isbs_bed.credat is '开证日期';
comment on column ${iol_schema}.isbs_bed.ownusr is '负责人';
comment on column ${iol_schema}.isbs_bed.ver is '版本号';
comment on column ${iol_schema}.isbs_bed.approvcod is '凭保议付标志';
comment on column ${iol_schema}.isbs_bed.frepayflg is '无偿放单标志';
comment on column ${iol_schema}.isbs_bed.docprbrol is '出单人';
comment on column ${iol_schema}.isbs_bed.payrol is '付款人';
comment on column ${iol_schema}.isbs_bed.orddat is '保证金信件收到日';
comment on column ${iol_schema}.isbs_bed.mattxtflg is '混合付款标志';
comment on column ${iol_schema}.isbs_bed.dscinsflg is '不符点标志';
comment on column ${iol_schema}.isbs_bed.acpnowflg is '现在承兑标志';
comment on column ${iol_schema}.isbs_bed.advtyp is '收到通知类型';
comment on column ${iol_schema}.isbs_bed.disdat is '不符点通知时间';
comment on column ${iol_schema}.isbs_bed.totcur is '付款货币';
comment on column ${iol_schema}.isbs_bed.totamt is '付款总金额';
comment on column ${iol_schema}.isbs_bed.totdat is '付款时间';
comment on column ${iol_schema}.isbs_bed.docsta is '单据状态';
comment on column ${iol_schema}.isbs_bed.docrol is '单据接受者';
comment on column ${iol_schema}.isbs_bed.docrolflg is '送单到其他地址标志';
comment on column ${iol_schema}.isbs_bed.dta770snd is '回执信息发送时间';
comment on column ${iol_schema}.isbs_bed.advdocflg is '返还单据标志';
comment on column ${iol_schema}.isbs_bed.etyextkey is '用户所在组的关键字';
comment on column ${iol_schema}.isbs_bed.rmbrol is '偿付行';
comment on column ${iol_schema}.isbs_bed.lescom is '国外扣费';
comment on column ${iol_schema}.isbs_bed.bchkeyinr is '经办机构号';
comment on column ${iol_schema}.isbs_bed.branchinr is '所属机构号';
comment on column ${iol_schema}.isbs_bed.nraflg is 'nra付款标志';
comment on column ${iol_schema}.isbs_bed.trpdocnum is '船运单号';
comment on column ${iol_schema}.isbs_bed.trpdoctyp is '船运类型';
comment on column ${iol_schema}.isbs_bed.tradat is '船单据日期';
comment on column ${iol_schema}.isbs_bed.tramod is '运单方式';
comment on column ${iol_schema}.isbs_bed.blnum is '单据编号';
comment on column ${iol_schema}.isbs_bed.connum is '合同号';
comment on column ${iol_schema}.isbs_bed.invnum is '发票号';
comment on column ${iol_schema}.isbs_bed.porlod is '装运港';
comment on column ${iol_schema}.isbs_bed.portrs is '转运港';
comment on column ${iol_schema}.isbs_bed.pordis is '卸货港';
comment on column ${iol_schema}.isbs_bed.delplc is '传送地';
comment on column ${iol_schema}.isbs_bed.vesnam is '船名';
comment on column ${iol_schema}.isbs_bed.voynum is '船次';
comment on column ${iol_schema}.isbs_bed.carnam is '提单者';
comment on column ${iol_schema}.isbs_bed.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_bed.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_bed.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_bed.etl_timestamp is 'ETL处理时间戳';
