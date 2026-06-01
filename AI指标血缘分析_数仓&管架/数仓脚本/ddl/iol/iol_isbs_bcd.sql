/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_bcd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_bcd
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_bcd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_bcd(
    inr varchar2(12) -- 唯一id号
    ,ownref varchar2(24) -- 参考号
    ,nam varchar2(60) -- 交易名称
    ,relgodflg varchar2(2) -- 货物授权标志
    ,relgoddat date -- 货物到达日期
    ,rcvdat date -- 收货日期
    ,predat date -- 提示日期
    ,shpdat date -- 发船日期
    ,credat date -- 进口代收产生日期
    ,advdat date -- 单据已到的通知日期
    ,clsdat date -- 到期日期
    ,matdat date -- 效期到期日
    ,opndat date -- 开证日期
    ,doctypcod varchar2(2) -- 拒付/收货的代码
    ,matperbeg varchar2(3) -- 效期起始日
    ,matpercnt number(3,0) -- 效期天数
    ,matpertyp varchar2(2) -- 日期的类型
    ,ownusr varchar2(12) -- 负责人
    ,ver varchar2(6) -- 版本号
    ,trpdoctyp varchar2(9) -- 传送单据类型
    ,trpdocnum varchar2(60) -- 单据编号
    ,tradat date -- 发单日期
    ,tramod varchar2(9) -- 发单方式
    ,shpfro varchar2(60) -- 发货地点
    ,shpto varchar2(60) -- 到货地点
    ,chato varchar2(2) -- 付款方向
    ,othins varchar2(5) -- 延期付款
    ,stacty varchar2(3) -- 国家代码
    ,stagod varchar2(9) -- 货物代码
    ,accdat date -- 承兑日期
    ,amenbr number(2,0) -- 修改次数
    ,dftgarflg varchar2(2) -- 担保标志
    ,reltyp varchar2(3) -- release类型
    ,expdat date -- 运输担保到期日
    ,rtodreflg varchar2(2) -- 放货标志
    ,mattxtflg varchar2(2) -- 混合付款标志
    ,focflg varchar2(2) -- 免付款交单标志
    ,waicolcod varchar2(2) -- 代收行费用遭拒付时是否放弃
    ,wairmtcod varchar2(2) -- 我方费用遭拒付时是否放弃
    ,oridre varchar2(2) -- 发送面函标志
    ,docsta varchar2(2) -- 单据状态
    ,resflg varchar2(2) -- 预留标志
    ,agtdat date -- 提货日期
    ,etyextkey varchar2(12) -- 用户组别关键字
    ,proins varchar2(6) -- 拒付说明
    ,branchinr varchar2(12) -- 所属机构号
    ,bchkeyinr varchar2(12) -- 经办机构号
    ,nraflg varchar2(2) -- nra收款标志
    ,qsqdbh varchar2(5) -- 清算渠道
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
grant select on ${iol_schema}.isbs_bcd to ${iml_schema};
grant select on ${iol_schema}.isbs_bcd to ${icl_schema};
grant select on ${iol_schema}.isbs_bcd to ${idl_schema};
grant select on ${iol_schema}.isbs_bcd to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_bcd is '进口代收业务信息表  存放进口代收业务信息短字节内容';
comment on column ${iol_schema}.isbs_bcd.inr is '唯一id号';
comment on column ${iol_schema}.isbs_bcd.ownref is '参考号';
comment on column ${iol_schema}.isbs_bcd.nam is '交易名称';
comment on column ${iol_schema}.isbs_bcd.relgodflg is '货物授权标志';
comment on column ${iol_schema}.isbs_bcd.relgoddat is '货物到达日期';
comment on column ${iol_schema}.isbs_bcd.rcvdat is '收货日期';
comment on column ${iol_schema}.isbs_bcd.predat is '提示日期';
comment on column ${iol_schema}.isbs_bcd.shpdat is '发船日期';
comment on column ${iol_schema}.isbs_bcd.credat is '进口代收产生日期';
comment on column ${iol_schema}.isbs_bcd.advdat is '单据已到的通知日期';
comment on column ${iol_schema}.isbs_bcd.clsdat is '到期日期';
comment on column ${iol_schema}.isbs_bcd.matdat is '效期到期日';
comment on column ${iol_schema}.isbs_bcd.opndat is '开证日期';
comment on column ${iol_schema}.isbs_bcd.doctypcod is '拒付/收货的代码';
comment on column ${iol_schema}.isbs_bcd.matperbeg is '效期起始日';
comment on column ${iol_schema}.isbs_bcd.matpercnt is '效期天数';
comment on column ${iol_schema}.isbs_bcd.matpertyp is '日期的类型';
comment on column ${iol_schema}.isbs_bcd.ownusr is '负责人';
comment on column ${iol_schema}.isbs_bcd.ver is '版本号';
comment on column ${iol_schema}.isbs_bcd.trpdoctyp is '传送单据类型';
comment on column ${iol_schema}.isbs_bcd.trpdocnum is '单据编号';
comment on column ${iol_schema}.isbs_bcd.tradat is '发单日期';
comment on column ${iol_schema}.isbs_bcd.tramod is '发单方式';
comment on column ${iol_schema}.isbs_bcd.shpfro is '发货地点';
comment on column ${iol_schema}.isbs_bcd.shpto is '到货地点';
comment on column ${iol_schema}.isbs_bcd.chato is '付款方向';
comment on column ${iol_schema}.isbs_bcd.othins is '延期付款';
comment on column ${iol_schema}.isbs_bcd.stacty is '国家代码';
comment on column ${iol_schema}.isbs_bcd.stagod is '货物代码';
comment on column ${iol_schema}.isbs_bcd.accdat is '承兑日期';
comment on column ${iol_schema}.isbs_bcd.amenbr is '修改次数';
comment on column ${iol_schema}.isbs_bcd.dftgarflg is '担保标志';
comment on column ${iol_schema}.isbs_bcd.reltyp is 'release类型';
comment on column ${iol_schema}.isbs_bcd.expdat is '运输担保到期日';
comment on column ${iol_schema}.isbs_bcd.rtodreflg is '放货标志';
comment on column ${iol_schema}.isbs_bcd.mattxtflg is '混合付款标志';
comment on column ${iol_schema}.isbs_bcd.focflg is '免付款交单标志';
comment on column ${iol_schema}.isbs_bcd.waicolcod is '代收行费用遭拒付时是否放弃';
comment on column ${iol_schema}.isbs_bcd.wairmtcod is '我方费用遭拒付时是否放弃';
comment on column ${iol_schema}.isbs_bcd.oridre is '发送面函标志';
comment on column ${iol_schema}.isbs_bcd.docsta is '单据状态';
comment on column ${iol_schema}.isbs_bcd.resflg is '预留标志';
comment on column ${iol_schema}.isbs_bcd.agtdat is '提货日期';
comment on column ${iol_schema}.isbs_bcd.etyextkey is '用户组别关键字';
comment on column ${iol_schema}.isbs_bcd.proins is '拒付说明';
comment on column ${iol_schema}.isbs_bcd.branchinr is '所属机构号';
comment on column ${iol_schema}.isbs_bcd.bchkeyinr is '经办机构号';
comment on column ${iol_schema}.isbs_bcd.nraflg is 'nra收款标志';
comment on column ${iol_schema}.isbs_bcd.qsqdbh is '清算渠道';
comment on column ${iol_schema}.isbs_bcd.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_bcd.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_bcd.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_bcd.etl_timestamp is 'ETL处理时间戳';
