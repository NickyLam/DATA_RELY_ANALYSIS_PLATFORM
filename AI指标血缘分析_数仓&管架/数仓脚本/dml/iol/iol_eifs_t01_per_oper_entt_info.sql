/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_eifs_t01_per_oper_entt_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.eifs_t01_per_oper_entt_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.eifs_t01_per_oper_entt_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t01_per_oper_entt_info_op purge;
drop table ${iol_schema}.eifs_t01_per_oper_entt_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t01_per_oper_entt_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t01_per_oper_entt_info where 0=1;

create table ${iol_schema}.eifs_t01_per_oper_entt_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t01_per_oper_entt_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t01_per_oper_entt_info_cl(
            oper_entt_id -- 经营实体ID:信息ID
            ,party_id -- 参与人ID:ECIF内部使用的记录ID。
            ,oper_pers_pty_name -- 经营者客户名称:
            ,oper_pers_cert_typ -- 经营者证件类型:个人证件类型
            ,oper_pers_cert_num -- 经营者证件号:个人证件号
            ,brwer_and_oper_entt_rela -- 借款人与经营实体的关系:
            ,oper_entt_pty_id -- 经营实体客户号:
            ,oper_entt_pty_name -- 经营实体客户名称:
            ,oper_entt_doc_typ -- 经营实体证件类型:
            ,oper_entt_doc_num -- 经营实体证件号码:
            ,oper_entt_doc_due_date -- 经营实体证件到期日:YYYYMMDD
            ,corp_loc -- 企业地址:
            ,legal_rep_name -- 法定代表人姓名:
            ,corp_found_dt -- 成立日期:YYYYMMDD
            ,corp_emply_person_cnt -- 职工人数(人):
            ,corp_year_in -- 营业收入(年):请按字符串格式传输，如”RATE”:”0.56987”
            ,corp_totl_asset -- 资产总额:请按字符串格式传输，如”RATE”:”0.56987”
            ,belong_indus_cd -- 所属行业类型:
            ,blng_indus_name -- 所属行业中文名称:
            ,corp_size_cd -- 企业规模:
            ,create_te -- 开户柜员编号:描述客户开户的柜员编号。
            ,create_org -- 创建机构号:描述客户开户的机构。
            ,last_updated_te -- 最新更新柜员:描述最新更新客户信息的银行柜员、经理编号。
            ,last_updated_org -- 最新更新机构号:描述最新更新客户信息的银行机构编号。
            ,created_ts -- 进入ECIF的时间:记录进入ECIF的创建时间，保持不变。
            ,updated_ts -- 在ECIF中失效的时间:99991231，逻辑删除，则置为当前日期，否则不变。
            ,init_system_id -- 创建渠道编号:200100-ECIF，记录首次创建源系统号，保持不变。
            ,init_created_ts -- 源系统创建时间:记录首次在源系统的创建时间，保持不变。
            ,last_system_id -- 最新更新渠道编号:200100-ECIF，记录更新系统号，每次更新修改为最新的系统号。
            ,last_updated_ts -- 最新更新时间:记录最后更新时间，每次更新为最新的系统时间。
            ,src_sys_num -- 来源系统编号:
            ,last_updated_src_sys_num -- 最新更新源系统编号:
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t01_per_oper_entt_info_op(
            oper_entt_id -- 经营实体ID:信息ID
            ,party_id -- 参与人ID:ECIF内部使用的记录ID。
            ,oper_pers_pty_name -- 经营者客户名称:
            ,oper_pers_cert_typ -- 经营者证件类型:个人证件类型
            ,oper_pers_cert_num -- 经营者证件号:个人证件号
            ,brwer_and_oper_entt_rela -- 借款人与经营实体的关系:
            ,oper_entt_pty_id -- 经营实体客户号:
            ,oper_entt_pty_name -- 经营实体客户名称:
            ,oper_entt_doc_typ -- 经营实体证件类型:
            ,oper_entt_doc_num -- 经营实体证件号码:
            ,oper_entt_doc_due_date -- 经营实体证件到期日:YYYYMMDD
            ,corp_loc -- 企业地址:
            ,legal_rep_name -- 法定代表人姓名:
            ,corp_found_dt -- 成立日期:YYYYMMDD
            ,corp_emply_person_cnt -- 职工人数(人):
            ,corp_year_in -- 营业收入(年):请按字符串格式传输，如”RATE”:”0.56987”
            ,corp_totl_asset -- 资产总额:请按字符串格式传输，如”RATE”:”0.56987”
            ,belong_indus_cd -- 所属行业类型:
            ,blng_indus_name -- 所属行业中文名称:
            ,corp_size_cd -- 企业规模:
            ,create_te -- 开户柜员编号:描述客户开户的柜员编号。
            ,create_org -- 创建机构号:描述客户开户的机构。
            ,last_updated_te -- 最新更新柜员:描述最新更新客户信息的银行柜员、经理编号。
            ,last_updated_org -- 最新更新机构号:描述最新更新客户信息的银行机构编号。
            ,created_ts -- 进入ECIF的时间:记录进入ECIF的创建时间，保持不变。
            ,updated_ts -- 在ECIF中失效的时间:99991231，逻辑删除，则置为当前日期，否则不变。
            ,init_system_id -- 创建渠道编号:200100-ECIF，记录首次创建源系统号，保持不变。
            ,init_created_ts -- 源系统创建时间:记录首次在源系统的创建时间，保持不变。
            ,last_system_id -- 最新更新渠道编号:200100-ECIF，记录更新系统号，每次更新修改为最新的系统号。
            ,last_updated_ts -- 最新更新时间:记录最后更新时间，每次更新为最新的系统时间。
            ,src_sys_num -- 来源系统编号:
            ,last_updated_src_sys_num -- 最新更新源系统编号:
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.oper_entt_id, o.oper_entt_id) as oper_entt_id -- 经营实体ID:信息ID
    ,nvl(n.party_id, o.party_id) as party_id -- 参与人ID:ECIF内部使用的记录ID。
    ,nvl(n.oper_pers_pty_name, o.oper_pers_pty_name) as oper_pers_pty_name -- 经营者客户名称:
    ,nvl(n.oper_pers_cert_typ, o.oper_pers_cert_typ) as oper_pers_cert_typ -- 经营者证件类型:个人证件类型
    ,nvl(n.oper_pers_cert_num, o.oper_pers_cert_num) as oper_pers_cert_num -- 经营者证件号:个人证件号
    ,nvl(n.brwer_and_oper_entt_rela, o.brwer_and_oper_entt_rela) as brwer_and_oper_entt_rela -- 借款人与经营实体的关系:
    ,nvl(n.oper_entt_pty_id, o.oper_entt_pty_id) as oper_entt_pty_id -- 经营实体客户号:
    ,nvl(n.oper_entt_pty_name, o.oper_entt_pty_name) as oper_entt_pty_name -- 经营实体客户名称:
    ,nvl(n.oper_entt_doc_typ, o.oper_entt_doc_typ) as oper_entt_doc_typ -- 经营实体证件类型:
    ,nvl(n.oper_entt_doc_num, o.oper_entt_doc_num) as oper_entt_doc_num -- 经营实体证件号码:
    ,nvl(n.oper_entt_doc_due_date, o.oper_entt_doc_due_date) as oper_entt_doc_due_date -- 经营实体证件到期日:YYYYMMDD
    ,nvl(n.corp_loc, o.corp_loc) as corp_loc -- 企业地址:
    ,nvl(n.legal_rep_name, o.legal_rep_name) as legal_rep_name -- 法定代表人姓名:
    ,nvl(n.corp_found_dt, o.corp_found_dt) as corp_found_dt -- 成立日期:YYYYMMDD
    ,nvl(n.corp_emply_person_cnt, o.corp_emply_person_cnt) as corp_emply_person_cnt -- 职工人数(人):
    ,nvl(n.corp_year_in, o.corp_year_in) as corp_year_in -- 营业收入(年):请按字符串格式传输，如”RATE”:”0.56987”
    ,nvl(n.corp_totl_asset, o.corp_totl_asset) as corp_totl_asset -- 资产总额:请按字符串格式传输，如”RATE”:”0.56987”
    ,nvl(n.belong_indus_cd, o.belong_indus_cd) as belong_indus_cd -- 所属行业类型:
    ,nvl(n.blng_indus_name, o.blng_indus_name) as blng_indus_name -- 所属行业中文名称:
    ,nvl(n.corp_size_cd, o.corp_size_cd) as corp_size_cd -- 企业规模:
    ,nvl(n.create_te, o.create_te) as create_te -- 开户柜员编号:描述客户开户的柜员编号。
    ,nvl(n.create_org, o.create_org) as create_org -- 创建机构号:描述客户开户的机构。
    ,nvl(n.last_updated_te, o.last_updated_te) as last_updated_te -- 最新更新柜员:描述最新更新客户信息的银行柜员、经理编号。
    ,nvl(n.last_updated_org, o.last_updated_org) as last_updated_org -- 最新更新机构号:描述最新更新客户信息的银行机构编号。
    ,nvl(n.created_ts, o.created_ts) as created_ts -- 进入ECIF的时间:记录进入ECIF的创建时间，保持不变。
    ,nvl(n.updated_ts, o.updated_ts) as updated_ts -- 在ECIF中失效的时间:99991231，逻辑删除，则置为当前日期，否则不变。
    ,nvl(n.init_system_id, o.init_system_id) as init_system_id -- 创建渠道编号:200100-ECIF，记录首次创建源系统号，保持不变。
    ,nvl(n.init_created_ts, o.init_created_ts) as init_created_ts -- 源系统创建时间:记录首次在源系统的创建时间，保持不变。
    ,nvl(n.last_system_id, o.last_system_id) as last_system_id -- 最新更新渠道编号:200100-ECIF，记录更新系统号，每次更新修改为最新的系统号。
    ,nvl(n.last_updated_ts, o.last_updated_ts) as last_updated_ts -- 最新更新时间:记录最后更新时间，每次更新为最新的系统时间。
    ,nvl(n.src_sys_num, o.src_sys_num) as src_sys_num -- 来源系统编号:
    ,nvl(n.last_updated_src_sys_num, o.last_updated_src_sys_num) as last_updated_src_sys_num -- 最新更新源系统编号:
    ,case when
            n.oper_entt_id is null
            and n.updated_ts is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.oper_entt_id is null
            and n.updated_ts is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.oper_entt_id is null
            and n.updated_ts is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.eifs_t01_per_oper_entt_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.eifs_t01_per_oper_entt_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.oper_entt_id = n.oper_entt_id
            and o.updated_ts = n.updated_ts
where (
        o.oper_entt_id is null
        and o.updated_ts is null
    )
    or (
        n.oper_entt_id is null
        and n.updated_ts is null
    )
    or (
        o.party_id <> n.party_id
        or o.oper_pers_pty_name <> n.oper_pers_pty_name
        or o.oper_pers_cert_typ <> n.oper_pers_cert_typ
        or o.oper_pers_cert_num <> n.oper_pers_cert_num
        or o.brwer_and_oper_entt_rela <> n.brwer_and_oper_entt_rela
        or o.oper_entt_pty_id <> n.oper_entt_pty_id
        or o.oper_entt_pty_name <> n.oper_entt_pty_name
        or o.oper_entt_doc_typ <> n.oper_entt_doc_typ
        or o.oper_entt_doc_num <> n.oper_entt_doc_num
        or o.oper_entt_doc_due_date <> n.oper_entt_doc_due_date
        or o.corp_loc <> n.corp_loc
        or o.legal_rep_name <> n.legal_rep_name
        or o.corp_found_dt <> n.corp_found_dt
        or o.corp_emply_person_cnt <> n.corp_emply_person_cnt
        or o.corp_year_in <> n.corp_year_in
        or o.corp_totl_asset <> n.corp_totl_asset
        or o.belong_indus_cd <> n.belong_indus_cd
        or o.blng_indus_name <> n.blng_indus_name
        or o.corp_size_cd <> n.corp_size_cd
        or o.create_te <> n.create_te
        or o.create_org <> n.create_org
        or o.last_updated_te <> n.last_updated_te
        or o.last_updated_org <> n.last_updated_org
        or o.created_ts <> n.created_ts
        or o.init_system_id <> n.init_system_id
        or o.init_created_ts <> n.init_created_ts
        or o.last_system_id <> n.last_system_id
        or o.last_updated_ts <> n.last_updated_ts
        or o.src_sys_num <> n.src_sys_num
        or o.last_updated_src_sys_num <> n.last_updated_src_sys_num
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t01_per_oper_entt_info_cl(
            oper_entt_id -- 经营实体ID:信息ID
            ,party_id -- 参与人ID:ECIF内部使用的记录ID。
            ,oper_pers_pty_name -- 经营者客户名称:
            ,oper_pers_cert_typ -- 经营者证件类型:个人证件类型
            ,oper_pers_cert_num -- 经营者证件号:个人证件号
            ,brwer_and_oper_entt_rela -- 借款人与经营实体的关系:
            ,oper_entt_pty_id -- 经营实体客户号:
            ,oper_entt_pty_name -- 经营实体客户名称:
            ,oper_entt_doc_typ -- 经营实体证件类型:
            ,oper_entt_doc_num -- 经营实体证件号码:
            ,oper_entt_doc_due_date -- 经营实体证件到期日:YYYYMMDD
            ,corp_loc -- 企业地址:
            ,legal_rep_name -- 法定代表人姓名:
            ,corp_found_dt -- 成立日期:YYYYMMDD
            ,corp_emply_person_cnt -- 职工人数(人):
            ,corp_year_in -- 营业收入(年):请按字符串格式传输，如”RATE”:”0.56987”
            ,corp_totl_asset -- 资产总额:请按字符串格式传输，如”RATE”:”0.56987”
            ,belong_indus_cd -- 所属行业类型:
            ,blng_indus_name -- 所属行业中文名称:
            ,corp_size_cd -- 企业规模:
            ,create_te -- 开户柜员编号:描述客户开户的柜员编号。
            ,create_org -- 创建机构号:描述客户开户的机构。
            ,last_updated_te -- 最新更新柜员:描述最新更新客户信息的银行柜员、经理编号。
            ,last_updated_org -- 最新更新机构号:描述最新更新客户信息的银行机构编号。
            ,created_ts -- 进入ECIF的时间:记录进入ECIF的创建时间，保持不变。
            ,updated_ts -- 在ECIF中失效的时间:99991231，逻辑删除，则置为当前日期，否则不变。
            ,init_system_id -- 创建渠道编号:200100-ECIF，记录首次创建源系统号，保持不变。
            ,init_created_ts -- 源系统创建时间:记录首次在源系统的创建时间，保持不变。
            ,last_system_id -- 最新更新渠道编号:200100-ECIF，记录更新系统号，每次更新修改为最新的系统号。
            ,last_updated_ts -- 最新更新时间:记录最后更新时间，每次更新为最新的系统时间。
            ,src_sys_num -- 来源系统编号:
            ,last_updated_src_sys_num -- 最新更新源系统编号:
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t01_per_oper_entt_info_op(
            oper_entt_id -- 经营实体ID:信息ID
            ,party_id -- 参与人ID:ECIF内部使用的记录ID。
            ,oper_pers_pty_name -- 经营者客户名称:
            ,oper_pers_cert_typ -- 经营者证件类型:个人证件类型
            ,oper_pers_cert_num -- 经营者证件号:个人证件号
            ,brwer_and_oper_entt_rela -- 借款人与经营实体的关系:
            ,oper_entt_pty_id -- 经营实体客户号:
            ,oper_entt_pty_name -- 经营实体客户名称:
            ,oper_entt_doc_typ -- 经营实体证件类型:
            ,oper_entt_doc_num -- 经营实体证件号码:
            ,oper_entt_doc_due_date -- 经营实体证件到期日:YYYYMMDD
            ,corp_loc -- 企业地址:
            ,legal_rep_name -- 法定代表人姓名:
            ,corp_found_dt -- 成立日期:YYYYMMDD
            ,corp_emply_person_cnt -- 职工人数(人):
            ,corp_year_in -- 营业收入(年):请按字符串格式传输，如”RATE”:”0.56987”
            ,corp_totl_asset -- 资产总额:请按字符串格式传输，如”RATE”:”0.56987”
            ,belong_indus_cd -- 所属行业类型:
            ,blng_indus_name -- 所属行业中文名称:
            ,corp_size_cd -- 企业规模:
            ,create_te -- 开户柜员编号:描述客户开户的柜员编号。
            ,create_org -- 创建机构号:描述客户开户的机构。
            ,last_updated_te -- 最新更新柜员:描述最新更新客户信息的银行柜员、经理编号。
            ,last_updated_org -- 最新更新机构号:描述最新更新客户信息的银行机构编号。
            ,created_ts -- 进入ECIF的时间:记录进入ECIF的创建时间，保持不变。
            ,updated_ts -- 在ECIF中失效的时间:99991231，逻辑删除，则置为当前日期，否则不变。
            ,init_system_id -- 创建渠道编号:200100-ECIF，记录首次创建源系统号，保持不变。
            ,init_created_ts -- 源系统创建时间:记录首次在源系统的创建时间，保持不变。
            ,last_system_id -- 最新更新渠道编号:200100-ECIF，记录更新系统号，每次更新修改为最新的系统号。
            ,last_updated_ts -- 最新更新时间:记录最后更新时间，每次更新为最新的系统时间。
            ,src_sys_num -- 来源系统编号:
            ,last_updated_src_sys_num -- 最新更新源系统编号:
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.oper_entt_id -- 经营实体ID:信息ID
    ,o.party_id -- 参与人ID:ECIF内部使用的记录ID。
    ,o.oper_pers_pty_name -- 经营者客户名称:
    ,o.oper_pers_cert_typ -- 经营者证件类型:个人证件类型
    ,o.oper_pers_cert_num -- 经营者证件号:个人证件号
    ,o.brwer_and_oper_entt_rela -- 借款人与经营实体的关系:
    ,o.oper_entt_pty_id -- 经营实体客户号:
    ,o.oper_entt_pty_name -- 经营实体客户名称:
    ,o.oper_entt_doc_typ -- 经营实体证件类型:
    ,o.oper_entt_doc_num -- 经营实体证件号码:
    ,o.oper_entt_doc_due_date -- 经营实体证件到期日:YYYYMMDD
    ,o.corp_loc -- 企业地址:
    ,o.legal_rep_name -- 法定代表人姓名:
    ,o.corp_found_dt -- 成立日期:YYYYMMDD
    ,o.corp_emply_person_cnt -- 职工人数(人):
    ,o.corp_year_in -- 营业收入(年):请按字符串格式传输，如”RATE”:”0.56987”
    ,o.corp_totl_asset -- 资产总额:请按字符串格式传输，如”RATE”:”0.56987”
    ,o.belong_indus_cd -- 所属行业类型:
    ,o.blng_indus_name -- 所属行业中文名称:
    ,o.corp_size_cd -- 企业规模:
    ,o.create_te -- 开户柜员编号:描述客户开户的柜员编号。
    ,o.create_org -- 创建机构号:描述客户开户的机构。
    ,o.last_updated_te -- 最新更新柜员:描述最新更新客户信息的银行柜员、经理编号。
    ,o.last_updated_org -- 最新更新机构号:描述最新更新客户信息的银行机构编号。
    ,o.created_ts -- 进入ECIF的时间:记录进入ECIF的创建时间，保持不变。
    ,o.updated_ts -- 在ECIF中失效的时间:99991231，逻辑删除，则置为当前日期，否则不变。
    ,o.init_system_id -- 创建渠道编号:200100-ECIF，记录首次创建源系统号，保持不变。
    ,o.init_created_ts -- 源系统创建时间:记录首次在源系统的创建时间，保持不变。
    ,o.last_system_id -- 最新更新渠道编号:200100-ECIF，记录更新系统号，每次更新修改为最新的系统号。
    ,o.last_updated_ts -- 最新更新时间:记录最后更新时间，每次更新为最新的系统时间。
    ,o.src_sys_num -- 来源系统编号:
    ,o.last_updated_src_sys_num -- 最新更新源系统编号:
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.eifs_t01_per_oper_entt_info_bk o
    left join ${iol_schema}.eifs_t01_per_oper_entt_info_op n
        on
            o.oper_entt_id = n.oper_entt_id
            and o.updated_ts = n.updated_ts
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.eifs_t01_per_oper_entt_info_cl d
        on
            o.oper_entt_id = d.oper_entt_id
            and o.updated_ts = d.updated_ts
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.eifs_t01_per_oper_entt_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('eifs_t01_per_oper_entt_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.eifs_t01_per_oper_entt_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.eifs_t01_per_oper_entt_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.eifs_t01_per_oper_entt_info exchange partition p_${batch_date} with table ${iol_schema}.eifs_t01_per_oper_entt_info_cl;
alter table ${iol_schema}.eifs_t01_per_oper_entt_info exchange partition p_20991231 with table ${iol_schema}.eifs_t01_per_oper_entt_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.eifs_t01_per_oper_entt_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t01_per_oper_entt_info_op purge;
drop table ${iol_schema}.eifs_t01_per_oper_entt_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.eifs_t01_per_oper_entt_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'eifs_t01_per_oper_entt_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
