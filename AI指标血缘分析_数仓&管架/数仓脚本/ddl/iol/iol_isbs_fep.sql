/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_fep
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_fep
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_fep purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_fep(
    inr varchar2(12) -- 内部唯一id
    ,feecod varchar2(9) -- 费用代码
    ,objtyp varchar2(9) -- 对象表名称
    ,objinr varchar2(12) -- 对象表inr
    ,relobjtyp varchar2(9) -- 相关对象类型
    ,relobjinr varchar2(12) -- 相关对象的inr
    ,extkey varchar2(30) -- 外部可见名
    ,nam varchar2(90) -- 费用文本信息
    ,relcur varchar2(5) -- 相关币种
    ,relamt number(18,3) -- 相关金额
    ,dat1 date -- 费用收取起始日
    ,dat2 date -- 费用收取截止日
    ,modflg varchar2(2) -- 修改标志（费用变化状态）
    ,unt number(5,0) -- 费用收取的份数
    ,untamt number(18,3) -- 每份费用的金额
    ,ratcal number(14,6) -- 计算使用的费率
    ,rat number(14,6) -- 费率
    ,minmaxflg varchar2(2) -- 最低最高费率使用标示
    ,cur varchar2(5) -- 费用币种
    ,amt number(18,3) -- 费用金额
    ,xrfcur varchar2(5) -- 费用折算后的币种
    ,xrfamt number(18,3) -- 费用折算后的金额
    ,feeacc varchar2(51) -- 费用入账的账号
    ,infdetstm varchar2(2430) -- 费用计算细节
    ,ptyinr varchar2(12) -- 支付实体的inr
    ,srctrninr varchar2(12) -- 创建或者修改该费用的交易的trn表inr
    ,srcdat date -- 创建日期
    ,rpltrninr varchar2(12) -- 取代交易的trninr
    ,rpldat date -- 取代日期
    ,dontrninr varchar2(12) -- 结算费用交易的trn表inr
    ,dondat date -- 结算日期
    ,advtrninr varchar2(12) -- 通知费用交易的trn表inr
    ,advdat date -- 通知日期
    ,acrinr varchar2(12) -- 循环计算的inr
    ,sepinr varchar2(12) -- 对应的临时结算的inr
    ,rol varchar2(5) -- 角色
    ,ogiamt number(18,3) -- 应收金额
    ,dctamt number(18,3) -- 优惠金额
    ,amoflg varchar2(2) -- 
    ,amoref varchar2(60) -- 
    ,amosta varchar2(2) -- 
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
grant select on ${iol_schema}.isbs_fep to ${iml_schema};
grant select on ${iol_schema}.isbs_fep to ${icl_schema};
grant select on ${iol_schema}.isbs_fep to ${idl_schema};
grant select on ${iol_schema}.isbs_fep to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_fep is '费用明细';
comment on column ${iol_schema}.isbs_fep.inr is '内部唯一id';
comment on column ${iol_schema}.isbs_fep.feecod is '费用代码';
comment on column ${iol_schema}.isbs_fep.objtyp is '对象表名称';
comment on column ${iol_schema}.isbs_fep.objinr is '对象表inr';
comment on column ${iol_schema}.isbs_fep.relobjtyp is '相关对象类型';
comment on column ${iol_schema}.isbs_fep.relobjinr is '相关对象的inr';
comment on column ${iol_schema}.isbs_fep.extkey is '外部可见名';
comment on column ${iol_schema}.isbs_fep.nam is '费用文本信息';
comment on column ${iol_schema}.isbs_fep.relcur is '相关币种';
comment on column ${iol_schema}.isbs_fep.relamt is '相关金额';
comment on column ${iol_schema}.isbs_fep.dat1 is '费用收取起始日';
comment on column ${iol_schema}.isbs_fep.dat2 is '费用收取截止日';
comment on column ${iol_schema}.isbs_fep.modflg is '修改标志（费用变化状态）';
comment on column ${iol_schema}.isbs_fep.unt is '费用收取的份数';
comment on column ${iol_schema}.isbs_fep.untamt is '每份费用的金额';
comment on column ${iol_schema}.isbs_fep.ratcal is '计算使用的费率';
comment on column ${iol_schema}.isbs_fep.rat is '费率';
comment on column ${iol_schema}.isbs_fep.minmaxflg is '最低最高费率使用标示';
comment on column ${iol_schema}.isbs_fep.cur is '费用币种';
comment on column ${iol_schema}.isbs_fep.amt is '费用金额';
comment on column ${iol_schema}.isbs_fep.xrfcur is '费用折算后的币种';
comment on column ${iol_schema}.isbs_fep.xrfamt is '费用折算后的金额';
comment on column ${iol_schema}.isbs_fep.feeacc is '费用入账的账号';
comment on column ${iol_schema}.isbs_fep.infdetstm is '费用计算细节';
comment on column ${iol_schema}.isbs_fep.ptyinr is '支付实体的inr';
comment on column ${iol_schema}.isbs_fep.srctrninr is '创建或者修改该费用的交易的trn表inr';
comment on column ${iol_schema}.isbs_fep.srcdat is '创建日期';
comment on column ${iol_schema}.isbs_fep.rpltrninr is '取代交易的trninr';
comment on column ${iol_schema}.isbs_fep.rpldat is '取代日期';
comment on column ${iol_schema}.isbs_fep.dontrninr is '结算费用交易的trn表inr';
comment on column ${iol_schema}.isbs_fep.dondat is '结算日期';
comment on column ${iol_schema}.isbs_fep.advtrninr is '通知费用交易的trn表inr';
comment on column ${iol_schema}.isbs_fep.advdat is '通知日期';
comment on column ${iol_schema}.isbs_fep.acrinr is '循环计算的inr';
comment on column ${iol_schema}.isbs_fep.sepinr is '对应的临时结算的inr';
comment on column ${iol_schema}.isbs_fep.rol is '角色';
comment on column ${iol_schema}.isbs_fep.ogiamt is '应收金额';
comment on column ${iol_schema}.isbs_fep.dctamt is '优惠金额';
comment on column ${iol_schema}.isbs_fep.amoflg is '';
comment on column ${iol_schema}.isbs_fep.amoref is '';
comment on column ${iol_schema}.isbs_fep.amosta is '';
comment on column ${iol_schema}.isbs_fep.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_fep.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_fep.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_fep.etl_timestamp is 'ETL处理时间戳';
