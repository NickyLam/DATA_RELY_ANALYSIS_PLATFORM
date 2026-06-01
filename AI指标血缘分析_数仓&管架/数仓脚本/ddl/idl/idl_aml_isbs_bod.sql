/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_isbs_bod
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_isbs_bod
whenever sqlerror continue none;
drop table ${idl_schema}.aml_isbs_bod purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_isbs_bod(
    etl_dt date -- 数据日期
    ,inr varchar2(8) -- 出口托收INR号
    ,ownref varchar2(16) -- 参考号
    ,nam varchar2(40) -- 交易名
    ,agtref varchar2(16) -- 代理商参考号
    ,agtact varchar2(35) -- 代理帐号
    ,agtcom varchar2(40) -- 代理委托
    ,shpdat date -- 装船日期
    ,predat date -- 提示日期
    ,rcvdat date -- 到单日期
    ,opndat date -- 寄单日期
    ,advdat date -- 通知日期
    ,matdat date -- 效期
    ,clsdat date -- 到期日
    ,doctypcod varchar2(1) -- 拒单/收单
    ,matperbeg varchar2(2) -- 完备期起始日
    ,matpercnt number(3) -- 效期天数
    ,matpertyp varchar2(1) -- 效期类型
    ,trpdoctyp varchar2(6) -- 传送类型
    ,trpdocnum varchar2(40) -- 运输单据编号
    ,tradat date -- 传送日期
    ,tramod varchar2(6) -- 传送类型
    ,shpfro varchar2(40) -- 发货地点
    ,shpto varchar2(40) -- 到货地点
    ,waicolcod varchar2(1) -- 代收行费用遭拒付时是否放弃
    ,wairmtcod varchar2(1) -- 我方费用遭拒付时是否放弃
    ,chato varchar2(1) -- 付款方向
    ,stacty varchar2(2) -- 国家代码
    ,stagod varchar2(6) -- 货物类型
    ,credat date -- 创建日期
    ,ownusr varchar2(8) -- 负责人
    ,ver varchar2(4) -- 版本号
    ,focflg varchar2(1) -- 免付款交单标志
    ,dircolflg varchar2(1) -- 直接托收标志
    ,ccdpurflg varchar2(1) -- 是否低于预留金额付款
    ,ccdndrflg varchar2(1) -- 是否托收行保管单据
    ,issdat date -- 开立日期
    ,paydocnum varchar2(16) -- 单据数量
    ,paydoctyp varchar2(6) -- 单据类型
    ,mattxtflg varchar2(1) -- 混合付款标志
    ,othins varchar2(3) -- 延期时间
    ,docsta varchar2(40) -- 单据状态
    ,resflg varchar2(1) -- 预留标志
    ,amenbr number(2) -- 修改次数
    ,msgrol varchar2(3) -- 第二接收行
    ,etyextkey varchar2(8) -- 实体
    ,lescom number(18,3) -- 海外扣费
    ,branchinr varchar2(8) -- 所属机构号
    ,bchkeyinr varchar2(8) -- 经办机构号
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
grant select on ${idl_schema}.aml_isbs_bod to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_isbs_bod is '出口托收业务信息(存放短字节内容)';
comment on column ${idl_schema}.aml_isbs_bod.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_isbs_bod.inr is '出口托收INR号';
comment on column ${idl_schema}.aml_isbs_bod.ownref is '参考号';
comment on column ${idl_schema}.aml_isbs_bod.nam is '交易名';
comment on column ${idl_schema}.aml_isbs_bod.agtref is '代理商参考号';
comment on column ${idl_schema}.aml_isbs_bod.agtact is '代理帐号';
comment on column ${idl_schema}.aml_isbs_bod.agtcom is '代理委托';
comment on column ${idl_schema}.aml_isbs_bod.shpdat is '装船日期';
comment on column ${idl_schema}.aml_isbs_bod.predat is '提示日期';
comment on column ${idl_schema}.aml_isbs_bod.rcvdat is '到单日期';
comment on column ${idl_schema}.aml_isbs_bod.opndat is '寄单日期';
comment on column ${idl_schema}.aml_isbs_bod.advdat is '通知日期';
comment on column ${idl_schema}.aml_isbs_bod.matdat is '效期';
comment on column ${idl_schema}.aml_isbs_bod.clsdat is '到期日';
comment on column ${idl_schema}.aml_isbs_bod.doctypcod is '拒单/收单';
comment on column ${idl_schema}.aml_isbs_bod.matperbeg is '完备期起始日';
comment on column ${idl_schema}.aml_isbs_bod.matpercnt is '效期天数';
comment on column ${idl_schema}.aml_isbs_bod.matpertyp is '效期类型';
comment on column ${idl_schema}.aml_isbs_bod.trpdoctyp is '传送类型';
comment on column ${idl_schema}.aml_isbs_bod.trpdocnum is '运输单据编号';
comment on column ${idl_schema}.aml_isbs_bod.tradat is '传送日期';
comment on column ${idl_schema}.aml_isbs_bod.tramod is '传送类型';
comment on column ${idl_schema}.aml_isbs_bod.shpfro is '发货地点';
comment on column ${idl_schema}.aml_isbs_bod.shpto is '到货地点';
comment on column ${idl_schema}.aml_isbs_bod.waicolcod is '代收行费用遭拒付时是否放弃';
comment on column ${idl_schema}.aml_isbs_bod.wairmtcod is '我方费用遭拒付时是否放弃';
comment on column ${idl_schema}.aml_isbs_bod.chato is '付款方向';
comment on column ${idl_schema}.aml_isbs_bod.stacty is '国家代码';
comment on column ${idl_schema}.aml_isbs_bod.stagod is '货物类型';
comment on column ${idl_schema}.aml_isbs_bod.credat is '创建日期';
comment on column ${idl_schema}.aml_isbs_bod.ownusr is '负责人';
comment on column ${idl_schema}.aml_isbs_bod.ver is '版本号';
comment on column ${idl_schema}.aml_isbs_bod.focflg is '免付款交单标志';
comment on column ${idl_schema}.aml_isbs_bod.dircolflg is '直接托收标志';
comment on column ${idl_schema}.aml_isbs_bod.ccdpurflg is '是否低于预留金额付款';
comment on column ${idl_schema}.aml_isbs_bod.ccdndrflg is '是否托收行保管单据';
comment on column ${idl_schema}.aml_isbs_bod.issdat is '开立日期';
comment on column ${idl_schema}.aml_isbs_bod.paydocnum is '单据数量';
comment on column ${idl_schema}.aml_isbs_bod.paydoctyp is '单据类型';
comment on column ${idl_schema}.aml_isbs_bod.mattxtflg is '混合付款标志';
comment on column ${idl_schema}.aml_isbs_bod.othins is '延期时间';
comment on column ${idl_schema}.aml_isbs_bod.docsta is '单据状态';
comment on column ${idl_schema}.aml_isbs_bod.resflg is '预留标志';
comment on column ${idl_schema}.aml_isbs_bod.amenbr is '修改次数';
comment on column ${idl_schema}.aml_isbs_bod.msgrol is '第二接收行';
comment on column ${idl_schema}.aml_isbs_bod.etyextkey is '实体';
comment on column ${idl_schema}.aml_isbs_bod.lescom is '海外扣费';
comment on column ${idl_schema}.aml_isbs_bod.branchinr is '所属机构号';
comment on column ${idl_schema}.aml_isbs_bod.bchkeyinr is '经办机构号';
comment on column ${idl_schema}.aml_isbs_bod.nraflg is 'NRA付款标志';
comment on column ${idl_schema}.aml_isbs_bod.etl_timestamp is '数据处理时间';
