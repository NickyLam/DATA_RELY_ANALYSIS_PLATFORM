CREATE OR REPLACE FORCE VIEW RRP_MDL.V_RRP_TAB_DATA_TO_FDW AS
SELECT "SYS_NO","SYS_STR","ORG_NUM","ORG_NAME","UP_ORG_NUM","UP_ORG_NAME","REPORT_DATE","REPORT_ID","REPORT_NAME","REPORT_CALIBER","REPORT_FREQ","CURR_CODE","INDEX_ID","INDEX_STR","INDEX_IV","ETL_DATE","STATUS_ID" FROM RRP_MDL.RRP_TAB_DATA_TO_FDW;
comment on table RRP_MDL.V_RRP_TAB_DATA_TO_FDW is '监管报送供数给财务集市明细表';
comment on column RRP_MDL.V_RRP_TAB_DATA_TO_FDW.SYS_NO is '子系统编号';
comment on column RRP_MDL.V_RRP_TAB_DATA_TO_FDW.SYS_STR is '子系统描述';
comment on column RRP_MDL.V_RRP_TAB_DATA_TO_FDW.ORG_NUM is '机构编号';
comment on column RRP_MDL.V_RRP_TAB_DATA_TO_FDW.ORG_NAME is '机构名称';
comment on column RRP_MDL.V_RRP_TAB_DATA_TO_FDW.UP_ORG_NUM is '上级机构编号';
comment on column RRP_MDL.V_RRP_TAB_DATA_TO_FDW.UP_ORG_NAME is '上级机构名称';
comment on column RRP_MDL.V_RRP_TAB_DATA_TO_FDW.REPORT_DATE is '报表日期';
comment on column RRP_MDL.V_RRP_TAB_DATA_TO_FDW.REPORT_ID is '报表编号';
comment on column RRP_MDL.V_RRP_TAB_DATA_TO_FDW.REPORT_NAME is '报表名称';
comment on column RRP_MDL.V_RRP_TAB_DATA_TO_FDW.REPORT_CALIBER is '报表制度';
comment on column RRP_MDL.V_RRP_TAB_DATA_TO_FDW.REPORT_FREQ is '报表频率';
comment on column RRP_MDL.V_RRP_TAB_DATA_TO_FDW.CURR_CODE is '报表币种';
comment on column RRP_MDL.V_RRP_TAB_DATA_TO_FDW.INDEX_ID is '指标编号';
comment on column RRP_MDL.V_RRP_TAB_DATA_TO_FDW.INDEX_STR is '指标描述';
comment on column RRP_MDL.V_RRP_TAB_DATA_TO_FDW.INDEX_IV is '指标值';
comment on column RRP_MDL.V_RRP_TAB_DATA_TO_FDW.ETL_DATE is '供数日期';
comment on column RRP_MDL.V_RRP_TAB_DATA_TO_FDW.STATUS_ID is '报表状态 AUDITPASS-审核通过 END -完成';

