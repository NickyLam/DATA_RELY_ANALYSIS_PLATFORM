/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_fpd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_fpd
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_fpd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_fpd(
    inr varchar2(12) -- 主键
    ,perint number(5,2) -- 福费廷利率
    ,silflg varchar2(2) -- 是否关闭
    ,rdsflg varchar2(2) -- 是否可读
    ,funflg varchar2(2) -- 是否固定
    ,cnfflg varchar2(2) -- 是否资金
    ,ownref varchar2(24) -- 参考号
    ,invref varchar2(24) -- 信用证业务编号
    ,nam varchar2(60) -- 交易简述
    ,amedat date -- 修改日期
    ,amenbr number(2,0) -- 修改次数
    ,opndat date -- 开立日期
    ,clsdat date -- 关闭日期
    ,credat date -- 登记日期
    ,expdat date -- 开立到期日
    ,nomspc varchar2(2) -- 是否上浮
    ,nomtop number(2,0) -- 上浮比例
    ,nomton number(2,0) -- 下浮比例
    ,ownusr varchar2(12) -- 经办人
    ,stacty varchar2(3) -- 国家代码
    ,opndatlc date -- 父业务开立日期
    ,expdatlc date -- 父业务结束日期
    ,selnam varchar2(60) -- 交单角色名称
    ,invnam varchar2(60) -- nv角色名称
    ,selref varchar2(24) -- 交单编号
    ,grcdys number(4,0) -- 承诺天数
    ,selopnnbr number(2,0) -- 卖出数量
    ,selnegnbr number(2,0) -- 协议卖出数量
    ,valdat date -- 起息日
    ,irtcod varchar2(9) -- 浮动类型
    ,ratcal number(14,6) -- 计算费率
    ,ver varchar2(6) -- 版本号
    ,pntref varchar2(24) -- 父类参考号
    ,pnttyp varchar2(5) -- 父类交易类型
    ,pntinr varchar2(12) -- 父类交易inr号
    ,pntnam varchar2(60) -- 父类交易名称
    ,etyextkey varchar2(12) -- 实体关键字
    ,bmhlst varchar2(4000) -- 包买行集合
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
grant select on ${iol_schema}.isbs_fpd to ${iml_schema};
grant select on ${iol_schema}.isbs_fpd to ${icl_schema};
grant select on ${iol_schema}.isbs_fpd to ${idl_schema};
grant select on ${iol_schema}.isbs_fpd to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_fpd is '福费廷大字段信息表';
comment on column ${iol_schema}.isbs_fpd.inr is '主键';
comment on column ${iol_schema}.isbs_fpd.perint is '福费廷利率';
comment on column ${iol_schema}.isbs_fpd.silflg is '是否关闭';
comment on column ${iol_schema}.isbs_fpd.rdsflg is '是否可读';
comment on column ${iol_schema}.isbs_fpd.funflg is '是否固定';
comment on column ${iol_schema}.isbs_fpd.cnfflg is '是否资金';
comment on column ${iol_schema}.isbs_fpd.ownref is '参考号';
comment on column ${iol_schema}.isbs_fpd.invref is '信用证业务编号';
comment on column ${iol_schema}.isbs_fpd.nam is '交易简述';
comment on column ${iol_schema}.isbs_fpd.amedat is '修改日期';
comment on column ${iol_schema}.isbs_fpd.amenbr is '修改次数';
comment on column ${iol_schema}.isbs_fpd.opndat is '开立日期';
comment on column ${iol_schema}.isbs_fpd.clsdat is '关闭日期';
comment on column ${iol_schema}.isbs_fpd.credat is '登记日期';
comment on column ${iol_schema}.isbs_fpd.expdat is '开立到期日';
comment on column ${iol_schema}.isbs_fpd.nomspc is '是否上浮';
comment on column ${iol_schema}.isbs_fpd.nomtop is '上浮比例';
comment on column ${iol_schema}.isbs_fpd.nomton is '下浮比例';
comment on column ${iol_schema}.isbs_fpd.ownusr is '经办人';
comment on column ${iol_schema}.isbs_fpd.stacty is '国家代码';
comment on column ${iol_schema}.isbs_fpd.opndatlc is '父业务开立日期';
comment on column ${iol_schema}.isbs_fpd.expdatlc is '父业务结束日期';
comment on column ${iol_schema}.isbs_fpd.selnam is '交单角色名称';
comment on column ${iol_schema}.isbs_fpd.invnam is 'nv角色名称';
comment on column ${iol_schema}.isbs_fpd.selref is '交单编号';
comment on column ${iol_schema}.isbs_fpd.grcdys is '承诺天数';
comment on column ${iol_schema}.isbs_fpd.selopnnbr is '卖出数量';
comment on column ${iol_schema}.isbs_fpd.selnegnbr is '协议卖出数量';
comment on column ${iol_schema}.isbs_fpd.valdat is '起息日';
comment on column ${iol_schema}.isbs_fpd.irtcod is '浮动类型';
comment on column ${iol_schema}.isbs_fpd.ratcal is '计算费率';
comment on column ${iol_schema}.isbs_fpd.ver is '版本号';
comment on column ${iol_schema}.isbs_fpd.pntref is '父类参考号';
comment on column ${iol_schema}.isbs_fpd.pnttyp is '父类交易类型';
comment on column ${iol_schema}.isbs_fpd.pntinr is '父类交易inr号';
comment on column ${iol_schema}.isbs_fpd.pntnam is '父类交易名称';
comment on column ${iol_schema}.isbs_fpd.etyextkey is '实体关键字';
comment on column ${iol_schema}.isbs_fpd.bmhlst is '包买行集合';
comment on column ${iol_schema}.isbs_fpd.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_fpd.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_fpd.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_fpd.etl_timestamp is 'ETL处理时间戳';
