/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_fbs_v_accentry2
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_fbs_v_accentry2
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_fbs_v_accentry2 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_fbs_v_accentry2(
    alterbalance_id number(10,0) -- 变动明细唯一识别代码
    ,cusnumber varchar2(30) -- 机构编号
    ,branch_number number -- 分支机构编号
    ,accentry2_id number(22,0) -- 分录唯一识别代码
    ,view_table varchar2(21) -- 关联原交易表表名
    ,settledate number(22,0) -- 出账日期
    ,acccode number(22,0) -- 分录定义编号
    ,acctype varchar2(3) -- 分录类型 1：交易分录 2：交割分录 3：估值分录 4：敞口损益分录 5：手工调账分录 6：计提分录
    ,keepfolder_id number(22,0) -- 账户编号
    ,accountingcode varchar2(768) -- 科目编号
    ,accountingdesc varchar2(150) -- 科目名称
    ,debitcredit varchar2(6) -- 借贷方向 D:借 C:贷
    ,crncy_code varchar2(12) -- 货币编号
    ,ald_crncy_ename varchar2(75) -- 货币
    ,inouttype varchar2(2) -- 表内表外 I：表内 O:表外
    ,accentry2_id_rev number(22,0) -- 冲回分录id
    ,lastmodified timestamp -- 修改实际
    ,amount number -- 金额
    ,dealsqno varchar2(3000) -- 交易编号
    ,rev_flag number -- 冲回标志 1:冲回 0:不冲回
    ,event_name varchar2(384) -- 会计事件名称
    ,deal_sqno varchar2(113) -- 交易编号
    ,counter_party_id number -- 交易对手编号
    ,counter_party_scname varchar2(384) -- 交易对手名称
    ,currency varchar2(30) -- 货币名称
    ,ibo_type number -- 拆借类型 0：外币拆借（拆入、拆出体现在金额的正负上）； 1：同业存款（同业存放、存放同业体现在金额的正负上）； 2：融资（融入、融出体现在金额的正负上）。
    ,product varchar2(60) -- 产品类型 1：即期； 2：远期； 3：掉期；4：期权； 5：拆借； 57：外汇拆借提前支取现金流； 58：外汇拆借/同存 变动现金流； 59：外汇拆借/同存 周期付息； 6：货币掉期； 61：利率互换； 9：贵金属拆借； -9：钆差； 98：违约罚金；11：头寸调拨。
    ,client_deal_sqno varchar2(48) -- 成交编号
    ,day_end_date number(8,0) -- 日终出账日期
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ctms_fbs_v_accentry2 to ${iml_schema};
grant select on ${iol_schema}.ctms_fbs_v_accentry2 to ${icl_schema};
grant select on ${iol_schema}.ctms_fbs_v_accentry2 to ${idl_schema};
grant select on ${iol_schema}.ctms_fbs_v_accentry2 to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_fbs_v_accentry2 is '分录出账视图';
comment on column ${iol_schema}.ctms_fbs_v_accentry2.alterbalance_id is '变动明细唯一识别代码';
comment on column ${iol_schema}.ctms_fbs_v_accentry2.cusnumber is '机构编号';
comment on column ${iol_schema}.ctms_fbs_v_accentry2.branch_number is '分支机构编号';
comment on column ${iol_schema}.ctms_fbs_v_accentry2.accentry2_id is '分录唯一识别代码';
comment on column ${iol_schema}.ctms_fbs_v_accentry2.view_table is '关联原交易表表名';
comment on column ${iol_schema}.ctms_fbs_v_accentry2.settledate is '出账日期';
comment on column ${iol_schema}.ctms_fbs_v_accentry2.acccode is '分录定义编号';
comment on column ${iol_schema}.ctms_fbs_v_accentry2.acctype is '分录类型 1：交易分录 2：交割分录 3：估值分录 4：敞口损益分录 5：手工调账分录 6：计提分录';
comment on column ${iol_schema}.ctms_fbs_v_accentry2.keepfolder_id is '账户编号';
comment on column ${iol_schema}.ctms_fbs_v_accentry2.accountingcode is '科目编号';
comment on column ${iol_schema}.ctms_fbs_v_accentry2.accountingdesc is '科目名称';
comment on column ${iol_schema}.ctms_fbs_v_accentry2.debitcredit is '借贷方向 D:借 C:贷';
comment on column ${iol_schema}.ctms_fbs_v_accentry2.crncy_code is '货币编号';
comment on column ${iol_schema}.ctms_fbs_v_accentry2.ald_crncy_ename is '货币';
comment on column ${iol_schema}.ctms_fbs_v_accentry2.inouttype is '表内表外 I：表内 O:表外';
comment on column ${iol_schema}.ctms_fbs_v_accentry2.accentry2_id_rev is '冲回分录id';
comment on column ${iol_schema}.ctms_fbs_v_accentry2.lastmodified is '修改实际';
comment on column ${iol_schema}.ctms_fbs_v_accentry2.amount is '金额';
comment on column ${iol_schema}.ctms_fbs_v_accentry2.dealsqno is '交易编号';
comment on column ${iol_schema}.ctms_fbs_v_accentry2.rev_flag is '冲回标志 1:冲回 0:不冲回';
comment on column ${iol_schema}.ctms_fbs_v_accentry2.event_name is '会计事件名称';
comment on column ${iol_schema}.ctms_fbs_v_accentry2.deal_sqno is '交易编号';
comment on column ${iol_schema}.ctms_fbs_v_accentry2.counter_party_id is '交易对手编号';
comment on column ${iol_schema}.ctms_fbs_v_accentry2.counter_party_scname is '交易对手名称';
comment on column ${iol_schema}.ctms_fbs_v_accentry2.currency is '货币名称';
comment on column ${iol_schema}.ctms_fbs_v_accentry2.ibo_type is '拆借类型 0：外币拆借（拆入、拆出体现在金额的正负上）； 1：同业存款（同业存放、存放同业体现在金额的正负上）； 2：融资（融入、融出体现在金额的正负上）。';
comment on column ${iol_schema}.ctms_fbs_v_accentry2.product is '产品类型 1：即期； 2：远期； 3：掉期；4：期权； 5：拆借； 57：外汇拆借提前支取现金流； 58：外汇拆借/同存 变动现金流； 59：外汇拆借/同存 周期付息； 6：货币掉期； 61：利率互换； 9：贵金属拆借； -9：钆差； 98：违约罚金；11：头寸调拨。';
comment on column ${iol_schema}.ctms_fbs_v_accentry2.client_deal_sqno is '成交编号';
comment on column ${iol_schema}.ctms_fbs_v_accentry2.day_end_date is '日终出账日期';
comment on column ${iol_schema}.ctms_fbs_v_accentry2.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ctms_fbs_v_accentry2.etl_timestamp is 'ETL处理时间戳';
