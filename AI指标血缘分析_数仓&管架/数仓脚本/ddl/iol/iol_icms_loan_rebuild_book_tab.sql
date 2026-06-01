/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_loan_rebuild_book_tab
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_loan_rebuild_book_tab
whenever sqlerror continue none;
drop table ${iol_schema}.icms_loan_rebuild_book_tab purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_loan_rebuild_book_tab(
    duebillserialno varchar2(64) -- 借据号(主键)
    ,loanrebuildtype varchar2(20) -- 重组贷款类型
    ,inbusinesssum number(24,6) -- 加入重组时借据余额
    ,infiveclass varchar2(10) -- 加入重组时五级分类
    ,restructuretheloandate varchar2(10) -- 实施重组日期（年月日）
    ,exbusinesssum number(24,6) -- 退出重组时借据余额
    ,exfiveclass varchar2(10) -- 退出重组时五级分类
    ,exstructuretheloandate varchar2(10) -- 退出重组日期（年月日）
    ,exreason varchar2(1000) -- 退出重组原因
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记时间
    ,updatedate date -- 更新时间
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
grant select on ${iol_schema}.icms_loan_rebuild_book_tab to ${iml_schema};
grant select on ${iol_schema}.icms_loan_rebuild_book_tab to ${icl_schema};
grant select on ${iol_schema}.icms_loan_rebuild_book_tab to ${idl_schema};
grant select on ${iol_schema}.icms_loan_rebuild_book_tab to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_loan_rebuild_book_tab is '贷款重组新台账';
comment on column ${iol_schema}.icms_loan_rebuild_book_tab.duebillserialno is '借据号(主键)';
comment on column ${iol_schema}.icms_loan_rebuild_book_tab.loanrebuildtype is '重组贷款类型';
comment on column ${iol_schema}.icms_loan_rebuild_book_tab.inbusinesssum is '加入重组时借据余额';
comment on column ${iol_schema}.icms_loan_rebuild_book_tab.infiveclass is '加入重组时五级分类';
comment on column ${iol_schema}.icms_loan_rebuild_book_tab.restructuretheloandate is '实施重组日期（年月日）';
comment on column ${iol_schema}.icms_loan_rebuild_book_tab.exbusinesssum is '退出重组时借据余额';
comment on column ${iol_schema}.icms_loan_rebuild_book_tab.exfiveclass is '退出重组时五级分类';
comment on column ${iol_schema}.icms_loan_rebuild_book_tab.exstructuretheloandate is '退出重组日期（年月日）';
comment on column ${iol_schema}.icms_loan_rebuild_book_tab.exreason is '退出重组原因';
comment on column ${iol_schema}.icms_loan_rebuild_book_tab.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_loan_rebuild_book_tab.inputdate is '登记时间';
comment on column ${iol_schema}.icms_loan_rebuild_book_tab.updatedate is '更新时间';
comment on column ${iol_schema}.icms_loan_rebuild_book_tab.start_dt is '开始时间';
comment on column ${iol_schema}.icms_loan_rebuild_book_tab.end_dt is '结束时间';
comment on column ${iol_schema}.icms_loan_rebuild_book_tab.id_mark is '增删标志';
comment on column ${iol_schema}.icms_loan_rebuild_book_tab.etl_timestamp is 'ETL处理时间戳';
