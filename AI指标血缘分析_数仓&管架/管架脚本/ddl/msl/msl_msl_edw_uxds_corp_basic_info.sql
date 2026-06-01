/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_uxds_corp_basic_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_uxds_corp_basic_info
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_uxds_corp_basic_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_uxds_corp_basic_info(
    etl_dt date
    ,seq number(28)
    ,ctime date
    ,mtime date
    ,rtime date
    ,corp_nature varchar2(900)
    ,org_cn_introduction varchar2(4000)
    ,domestic_listing_identifier varchar2(3)
    ,currency_encode varchar2(180)
    ,accounting_firm_id varchar2(180)
    ,law_firm_id varchar2(180)
    ,org_id varchar2(33)
    ,org_name_cn varchar2(1500)
    ,org_website varchar2(3000)
    ,org_short_name_cn varchar2(1500)
    ,staff_num number(18)
    ,legal_representative varchar2(1500)
    ,reg_address_cn varchar2(3000)
    ,accounting_firm_name varchar2(900)
    ,law_firm_name varchar2(900)
    ,charged_accountant varchar2(1500)
    ,charged_lawyer varchar2(1500)
    ,district_encode varchar2(600)
    ,cn_regional_identifier number(1)
    ,org_code varchar2(1500)
    ,unified_social_credit_code varchar2(1500)
    ,office_address_cn varchar2(3000)
    ,postcode varchar2(300)
    ,reg_asset number(22,6)
    ,currency_name varchar2(900)
    ,established_date date
    ,email varchar2(1500)
    ,telephone varchar2(1500)
    ,fax varchar2(1500)
    ,main_operation_business varchar2(4000)
    ,operating_scope varchar2(4000)
    ,org_name_en varchar2(4000)
    ,general_manager varchar2(1500)
    ,org_short_name_en varchar2(1500)
    ,corp_ed date
    ,announcement_date date
    ,business_reg_num varchar2(1500)
    ,tax_reg_num varchar2(1500)
    ,secretary varchar2(1500)
    ,sec_representative varchar2(1500)
    ,org_type varchar2(900)
    ,reg_address_en varchar2(4000)
    ,office_address_en varchar2(4000)
    ,board_manage_analysis varchar2(4000)
    ,establishment_history varchar2(4000)
    ,isvalid number(1)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_uxds_corp_basic_info to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_uxds_corp_basic_info is '公司基本资料';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.seq is '记录唯一标识';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.ctime is '记录创建时间';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.mtime is '记录修改时间';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.rtime is '记录通讯到用户端时间';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.corp_nature is '企业性质';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.org_cn_introduction is '机构简介(中文)';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.domestic_listing_identifier is '境内上市标识.是否发行ab股，用于区分境内上市公司和非上市公司 0：否 1：是';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.currency_encode is '货币编码';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.accounting_firm_id is '会计师事务所id';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.law_firm_id is '律师事务所id';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.org_id is '机构id';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.org_name_cn is '机构名称(中文)';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.org_website is '机构网址';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.org_short_name_cn is '机构简称(中文)';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.staff_num is '员工人数';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.legal_representative is '法人代表';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.reg_address_cn is '注册地址(中文)';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.accounting_firm_name is '会计师事务所名称';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.law_firm_name is '律师事务所名称';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.charged_accountant is '经办会计师';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.charged_lawyer is '经办律师';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.district_encode is '地区编码';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.cn_regional_identifier is '中国地区标识';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.org_code is '组织机构代码';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.unified_social_credit_code is '统一社会信用代码';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.office_address_cn is '办公地址(中文)';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.postcode is '邮政编码';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.reg_asset is '注册资金，单位：万元';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.currency_name is '货币名称';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.established_date is '成立日期';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.email is '电子信箱';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.telephone is '联系电话';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.fax is '联系传真';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.main_operation_business is '主营业务';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.operating_scope is '经营范围';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.org_name_en is '机构名称(英文)';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.general_manager is '总经理';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.org_short_name_en is '机构简称(英文)';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.corp_ed is '公司终止日期';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.announcement_date is '公告日期';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.business_reg_num is '工商登记号';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.tax_reg_num is '税务登记号';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.secretary is '董事会秘书';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.sec_representative is '证券事务代表';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.org_type is '机构类别';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.reg_address_en is '注册地址(英文)';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.office_address_en is '办公地址(英文)';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.board_manage_analysis is '董事会经营分析';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.establishment_history is '成立情况与历史沿革';
comment on column ${msl_schema}.msl_edw_uxds_corp_basic_info.isvalid is '是否有效';
