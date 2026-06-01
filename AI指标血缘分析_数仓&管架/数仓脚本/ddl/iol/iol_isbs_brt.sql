/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_brt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_brt
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_brt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_brt(
    inr varchar2(12) -- 进口单据id号
    ,docdis varchar2(4000) -- 不符点
    ,docins varchar2(270) -- 拒付原因
    ,prsdoc varchar2(4000) -- 提示单据
    ,disdoc varchar2(162) -- 处理单据
    ,aplins varchar2(615) -- 申请者的说明
    ,matper varchar2(99) -- 效期
    ,comcon varchar2(2970) -- 注释与结论
    ,setinsbr varchar2(594) -- 付款指示
    ,roggod varchar2(2460) -- 货物的鉴定
    ,pordis varchar2(60) -- 卸货地点
    ,delplc varchar2(60) -- 传送地点
    ,vesnam varchar2(60) -- 船名
    ,relstoadr varchar2(216) -- 地址授权
    ,chaded varchar2(324) -- 扣除费用
    ,chaadd varchar2(324) -- 增加费用
    ,fldmodblk varchar2(4000) -- 修改清单
    ,nartxt77a varchar2(1080) -- 详述
    ,contag72 varchar2(4000) -- 附言
    ,contag79 varchar2(4000) -- 79域
    ,docdisdef varchar2(4000) -- 默认不符点内容
    ,docdisflg varchar2(2) -- 修改不符点标志
    ,disdocdef varchar2(162) -- 不符点内容
    ,disdocflg varchar2(2) -- 单据不符点内容
    ,porlod varchar2(60) -- 装载港口
    ,notpty varchar2(540) -- 通知人
    ,voynum varchar2(45) -- 航运号
    ,carnam varchar2(53) -- 运输商
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
grant select on ${iol_schema}.isbs_brt to ${iml_schema};
grant select on ${iol_schema}.isbs_brt to ${icl_schema};
grant select on ${iol_schema}.isbs_brt to ${idl_schema};
grant select on ${iol_schema}.isbs_brt to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_brt is '进口信用证下单据业务信息(存放长字节内容)';
comment on column ${iol_schema}.isbs_brt.inr is '进口单据id号';
comment on column ${iol_schema}.isbs_brt.docdis is '不符点';
comment on column ${iol_schema}.isbs_brt.docins is '拒付原因';
comment on column ${iol_schema}.isbs_brt.prsdoc is '提示单据';
comment on column ${iol_schema}.isbs_brt.disdoc is '处理单据';
comment on column ${iol_schema}.isbs_brt.aplins is '申请者的说明';
comment on column ${iol_schema}.isbs_brt.matper is '效期';
comment on column ${iol_schema}.isbs_brt.comcon is '注释与结论';
comment on column ${iol_schema}.isbs_brt.setinsbr is '付款指示';
comment on column ${iol_schema}.isbs_brt.roggod is '货物的鉴定';
comment on column ${iol_schema}.isbs_brt.pordis is '卸货地点';
comment on column ${iol_schema}.isbs_brt.delplc is '传送地点';
comment on column ${iol_schema}.isbs_brt.vesnam is '船名';
comment on column ${iol_schema}.isbs_brt.relstoadr is '地址授权';
comment on column ${iol_schema}.isbs_brt.chaded is '扣除费用';
comment on column ${iol_schema}.isbs_brt.chaadd is '增加费用';
comment on column ${iol_schema}.isbs_brt.fldmodblk is '修改清单';
comment on column ${iol_schema}.isbs_brt.nartxt77a is '详述';
comment on column ${iol_schema}.isbs_brt.contag72 is '附言';
comment on column ${iol_schema}.isbs_brt.contag79 is '79域';
comment on column ${iol_schema}.isbs_brt.docdisdef is '默认不符点内容';
comment on column ${iol_schema}.isbs_brt.docdisflg is '修改不符点标志';
comment on column ${iol_schema}.isbs_brt.disdocdef is '不符点内容';
comment on column ${iol_schema}.isbs_brt.disdocflg is '单据不符点内容';
comment on column ${iol_schema}.isbs_brt.porlod is '装载港口';
comment on column ${iol_schema}.isbs_brt.notpty is '通知人';
comment on column ${iol_schema}.isbs_brt.voynum is '航运号';
comment on column ${iol_schema}.isbs_brt.carnam is '运输商';
comment on column ${iol_schema}.isbs_brt.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_brt.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_brt.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_brt.etl_timestamp is 'ETL处理时间戳';
