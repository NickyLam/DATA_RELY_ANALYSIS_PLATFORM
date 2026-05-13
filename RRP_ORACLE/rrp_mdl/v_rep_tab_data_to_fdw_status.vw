create or replace force view rrp_mdl.v_rep_tab_data_to_fdw_status as
select report_id,report_name,report_date,status,etl_date from rep_tab_data_to_fdw_status;
comment on table RRP_MDL.V_REP_TAB_DATA_TO_FDW_STATUS is '监管报送供数给财务集市状态表';
comment on column RRP_MDL.V_REP_TAB_DATA_TO_FDW_STATUS.REPORT_ID is '报告ID';
comment on column RRP_MDL.V_REP_TAB_DATA_TO_FDW_STATUS.REPORT_NAME is '报文名';
comment on column RRP_MDL.V_REP_TAB_DATA_TO_FDW_STATUS.REPORT_DATE is '报表日期';
comment on column RRP_MDL.V_REP_TAB_DATA_TO_FDW_STATUS.STATUS is '状态;1草稿2审核中3审核完成4退回';
comment on column RRP_MDL.V_REP_TAB_DATA_TO_FDW_STATUS.ETL_DATE is '数据标志。01,FCR数据,02,ICS数据；为空则为前台添加的数据，某一栏为00则为未知（开发时没有填这2位，直接填00）--20130103由date改为varchar(10)';

