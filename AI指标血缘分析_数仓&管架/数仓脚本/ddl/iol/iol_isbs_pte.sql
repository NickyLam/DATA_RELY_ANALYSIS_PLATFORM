/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_pte
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_pte
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_pte purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_pte(
    inr varchar2(12) -- 内部唯一id号
    ,objtyp varchar2(9) -- 关联pts的类型
    ,objinr varchar2(12) -- 关联pts的inr
    ,subid varchar2(6) -- 标识pts的多个pte
    ,cbtpfx varchar2(5) -- 表外风险类型
    ,grpkey varchar2(9) -- 责任组
    ,extid varchar2(24) -- 关联实体cbs
    ,liaptyinr varchar2(12) -- 记账用户的pty的唯一inr
    ,liaptainr varchar2(12) -- 记账用户的pta的唯一inr
    ,cdtptsinr varchar2(12) -- 贷方inr
    ,ownref varchar2(30) -- 参考号
    ,nam varchar2(60) -- 帐务信息
    ,feeinr varchar2(12) -- 费用inr
    ,begdat date -- 开始日期
    ,clsdat date -- 关闭日期
    ,setdat date -- 结束日期
    ,nxtcomdat date -- 下次费用计算时间
    ,rolpay varchar2(5) -- 付费角色
    ,matdat date -- 到期日
    ,covtyp varchar2(2) -- 结帐类型
    ,prc number(3,0) -- 分配百分比
    ,amtflg varchar2(2) -- 记账方式
    ,ver varchar2(6) -- 版本号
    ,asgtxt varchar2(615) -- 代理人信息
    ,asbtxt varchar2(615) -- 代理银行信息
    ,tenday number(3,0) -- 最大到期日
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
grant select on ${iol_schema}.isbs_pte to ${iml_schema};
grant select on ${iol_schema}.isbs_pte to ${icl_schema};
grant select on ${iol_schema}.isbs_pte to ${idl_schema};
grant select on ${iol_schema}.isbs_pte to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_pte is '表外信息';
comment on column ${iol_schema}.isbs_pte.inr is '内部唯一id号';
comment on column ${iol_schema}.isbs_pte.objtyp is '关联pts的类型';
comment on column ${iol_schema}.isbs_pte.objinr is '关联pts的inr';
comment on column ${iol_schema}.isbs_pte.subid is '标识pts的多个pte';
comment on column ${iol_schema}.isbs_pte.cbtpfx is '表外风险类型';
comment on column ${iol_schema}.isbs_pte.grpkey is '责任组';
comment on column ${iol_schema}.isbs_pte.extid is '关联实体cbs';
comment on column ${iol_schema}.isbs_pte.liaptyinr is '记账用户的pty的唯一inr';
comment on column ${iol_schema}.isbs_pte.liaptainr is '记账用户的pta的唯一inr';
comment on column ${iol_schema}.isbs_pte.cdtptsinr is '贷方inr';
comment on column ${iol_schema}.isbs_pte.ownref is '参考号';
comment on column ${iol_schema}.isbs_pte.nam is '帐务信息';
comment on column ${iol_schema}.isbs_pte.feeinr is '费用inr';
comment on column ${iol_schema}.isbs_pte.begdat is '开始日期';
comment on column ${iol_schema}.isbs_pte.clsdat is '关闭日期';
comment on column ${iol_schema}.isbs_pte.setdat is '结束日期';
comment on column ${iol_schema}.isbs_pte.nxtcomdat is '下次费用计算时间';
comment on column ${iol_schema}.isbs_pte.rolpay is '付费角色';
comment on column ${iol_schema}.isbs_pte.matdat is '到期日';
comment on column ${iol_schema}.isbs_pte.covtyp is '结帐类型';
comment on column ${iol_schema}.isbs_pte.prc is '分配百分比';
comment on column ${iol_schema}.isbs_pte.amtflg is '记账方式';
comment on column ${iol_schema}.isbs_pte.ver is '版本号';
comment on column ${iol_schema}.isbs_pte.asgtxt is '代理人信息';
comment on column ${iol_schema}.isbs_pte.asbtxt is '代理银行信息';
comment on column ${iol_schema}.isbs_pte.tenday is '最大到期日';
comment on column ${iol_schema}.isbs_pte.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_pte.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_pte.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_pte.etl_timestamp is 'ETL处理时间戳';
