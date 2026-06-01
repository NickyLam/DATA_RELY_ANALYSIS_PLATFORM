/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_chn_pos_termn_info_mrmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.chn_pos_termn_info_mrmsf1_tm purge;
drop table ${iml_schema}.chn_pos_termn_info_mrmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.chn_pos_termn_info add partition p_mrmsf1 values ('mrmsf1')(
        subpartition p_mrmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.chn_pos_termn_info modify partition p_mrmsf1
    add subpartition p_mrmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.chn_pos_termn_info_mrmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.chn_pos_termn_info partition for ('mrmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.chn_pos_termn_info_mrmsf1_tm
compress ${option_switch} for query high
as
select
    chn_id -- 渠道商终端设备编号
    ,lp_id -- 法人编号
    ,mercht_id -- 商户编号
    ,termn_id -- 终端编号
    ,uniq_mark_id -- 唯一标示编号
    ,status_cd -- 状态代码
    ,sign_status_cd -- 签到状态代码
    ,check_status_cd -- 审核状态代码
    ,stl_curr_cd -- 结算币种代码
    ,termn_mcc_code -- 终端MCC码
    ,manuf_name -- 厂商名称
    ,termn_model -- 终端型号
    ,termn_type_cd -- 终端类型代码
    ,termn_para_dload_flg -- 终端参数下载标志
    ,ic_card_para_dload_flg -- IC卡参数下载标志
    ,capk_dload_flg -- CA公钥下载标志
    ,prop_belong_cd -- 产权归属代码
    ,prop_belong_org_name -- 产权所属机构名称
    ,supt_forgn_card_flg -- 支持外卡标志
    ,forgn_card_org_brand_name -- 外卡组织品牌名称
    ,supt_ic_card_flg -- 支持IC卡标志
    ,access_way_cd -- 接入方式代码
    ,termn_belong_org_id -- 终端所属机构编号
    ,termn_belong_bank_num -- 终端所属行号
    ,termn_batch_id -- 终端批次编号
    ,termn_end_dt -- 终端批结日期
    ,termn_para -- 终端参数
    ,bind_tel_num -- 绑定电话号码
    ,dist_cd -- 行政区划代码
    ,termn_install_addr -- 终端安装地址
    ,phone -- 联系电话
    ,open_acct_teller -- 开户柜员
    ,rec_dt -- 记录日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.chn_pos_termn_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.chn_pos_termn_info_mrmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.chn_pos_termn_info partition for ('mrmsf1') where 0=1;

-- 2.1 insert data to tm table
-- mrms_tbl_term_inf-
insert into ${iml_schema}.chn_pos_termn_info_mrmsf1_tm(
    chn_id -- 渠道商终端设备编号
    ,lp_id -- 法人编号
    ,mercht_id -- 商户编号
    ,termn_id -- 终端编号
    ,uniq_mark_id -- 唯一标示编号
    ,status_cd -- 状态代码
    ,sign_status_cd -- 签到状态代码
    ,check_status_cd -- 审核状态代码
    ,stl_curr_cd -- 结算币种代码
    ,termn_mcc_code -- 终端MCC码
    ,manuf_name -- 厂商名称
    ,termn_model -- 终端型号
    ,termn_type_cd -- 终端类型代码
    ,termn_para_dload_flg -- 终端参数下载标志
    ,ic_card_para_dload_flg -- IC卡参数下载标志
    ,capk_dload_flg -- CA公钥下载标志
    ,prop_belong_cd -- 产权归属代码
    ,prop_belong_org_name -- 产权所属机构名称
    ,supt_forgn_card_flg -- 支持外卡标志
    ,forgn_card_org_brand_name -- 外卡组织品牌名称
    ,supt_ic_card_flg -- 支持IC卡标志
    ,access_way_cd -- 接入方式代码
    ,termn_belong_org_id -- 终端所属机构编号
    ,termn_belong_bank_num -- 终端所属行号
    ,termn_batch_id -- 终端批次编号
    ,termn_end_dt -- 终端批结日期
    ,termn_para -- 终端参数
    ,bind_tel_num -- 绑定电话号码
    ,dist_cd -- 行政区划代码
    ,termn_install_addr -- 终端安装地址
    ,phone -- 联系电话
    ,open_acct_teller -- 开户柜员
    ,rec_dt -- 记录日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '103001'||p1.mcht_cd||p1.term_id -- 渠道商终端设备编号
    ,'9999' -- 法人编号
    ,p1.mcht_cd -- 商户编号
    ,p1.term_id -- 终端编号
    ,p1.term_id_id -- 唯一标示编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.term_sta END -- 状态代码
    ,nvl(trim(p1.term_sign_sta),'-') -- 签到状态代码
    ,p1.chk_sta -- 审核状态代码
    ,nvl(trim(p1.term_set_cur),'CNY') -- 结算币种代码
    ,p1.term_mcc -- 终端MCC码
    ,p1.term_factory -- 厂商名称
    ,p1.term_mach_tp -- 终端型号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.term_tp END -- 终端类型代码
    ,nvl(trim(p1.param_down_sign),'-') -- 终端参数下载标志
    ,nvl(trim(p1.ic_down_sign),'-') -- IC卡参数下载标志
    ,nvl(trim(p1.key_down_sign),'-') -- CA公钥下载标志
    ,nvl(trim(p1.prop_tp),'-') -- 产权归属代码
    ,p1.prop_ins_nm -- 产权所属机构名称
    ,nvl(trim(p1.f_card_sup_flag),'-') -- 支持外卡标志
    ,p1.f_card_company -- 外卡组织品牌名称
    ,nvl(trim(p1.support_ic),'-') -- 支持IC卡标志
    ,nvl(trim(p1.connect_mode),'-') -- 接入方式代码
    ,p1.term_ins -- 终端所属机构编号
    ,p1.term_branch -- 终端所属行号
    ,p1.term_batch_nm -- 终端批次编号
    ,${iml_schema}.DATEFORMAT_MAX(p1.term_stlm_dt) -- 终端批结日期
    ,p1.term_para -- 终端参数
    ,p1.bind_tel1 -- 绑定电话号码
    ,p1.zone_num -- 行政区划代码
    ,p1.term_addr -- 终端安装地址
    ,p1.cont_tel -- 联系电话
    ,p1.rec_crt_opr -- 开户柜员
    ,${iml_schema}.DATEFORMAT_MAX(p1.rec_crt_ts) -- 记录日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mrms_tbl_term_inf' -- 源表名称
    ,'mrmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mrms_tbl_term_inf p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.term_sta = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MRMS'
        AND R1.SRC_TAB_EN_NAME= 'MRMS_TBL_TERM_INF'
        AND R1.SRC_FIELD_EN_NAME= 'term_sta'
        AND R1.TARGET_TAB_EN_NAME= 'CHN_POS_TERMN_INFO'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.term_tp = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MRMS'
        AND R1.SRC_TAB_EN_NAME= 'MRMS_TBL_TERM_INF'
        AND R1.SRC_FIELD_EN_NAME= 'term_tp'
        AND R1.TARGET_TAB_EN_NAME= 'CHN_POS_TERMN_INFO'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'TERMN_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.chn_pos_termn_info_mrmsf1_tm 
  	                                group by 
  	                                        chn_id
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.chn_pos_termn_info_mrmsf1_ex(
    chn_id -- 渠道商终端设备编号
    ,lp_id -- 法人编号
    ,mercht_id -- 商户编号
    ,termn_id -- 终端编号
    ,uniq_mark_id -- 唯一标示编号
    ,status_cd -- 状态代码
    ,sign_status_cd -- 签到状态代码
    ,check_status_cd -- 审核状态代码
    ,stl_curr_cd -- 结算币种代码
    ,termn_mcc_code -- 终端MCC码
    ,manuf_name -- 厂商名称
    ,termn_model -- 终端型号
    ,termn_type_cd -- 终端类型代码
    ,termn_para_dload_flg -- 终端参数下载标志
    ,ic_card_para_dload_flg -- IC卡参数下载标志
    ,capk_dload_flg -- CA公钥下载标志
    ,prop_belong_cd -- 产权归属代码
    ,prop_belong_org_name -- 产权所属机构名称
    ,supt_forgn_card_flg -- 支持外卡标志
    ,forgn_card_org_brand_name -- 外卡组织品牌名称
    ,supt_ic_card_flg -- 支持IC卡标志
    ,access_way_cd -- 接入方式代码
    ,termn_belong_org_id -- 终端所属机构编号
    ,termn_belong_bank_num -- 终端所属行号
    ,termn_batch_id -- 终端批次编号
    ,termn_end_dt -- 终端批结日期
    ,termn_para -- 终端参数
    ,bind_tel_num -- 绑定电话号码
    ,dist_cd -- 行政区划代码
    ,termn_install_addr -- 终端安装地址
    ,phone -- 联系电话
    ,open_acct_teller -- 开户柜员
    ,rec_dt -- 记录日期
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.chn_id, o.chn_id) as chn_id -- 渠道商终端设备编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.mercht_id, o.mercht_id) as mercht_id -- 商户编号
    ,nvl(n.termn_id, o.termn_id) as termn_id -- 终端编号
    ,nvl(n.uniq_mark_id, o.uniq_mark_id) as uniq_mark_id -- 唯一标示编号
    ,nvl(n.status_cd, o.status_cd) as status_cd -- 状态代码
    ,nvl(n.sign_status_cd, o.sign_status_cd) as sign_status_cd -- 签到状态代码
    ,nvl(n.check_status_cd, o.check_status_cd) as check_status_cd -- 审核状态代码
    ,nvl(n.stl_curr_cd, o.stl_curr_cd) as stl_curr_cd -- 结算币种代码
    ,nvl(n.termn_mcc_code, o.termn_mcc_code) as termn_mcc_code -- 终端MCC码
    ,nvl(n.manuf_name, o.manuf_name) as manuf_name -- 厂商名称
    ,nvl(n.termn_model, o.termn_model) as termn_model -- 终端型号
    ,nvl(n.termn_type_cd, o.termn_type_cd) as termn_type_cd -- 终端类型代码
    ,nvl(n.termn_para_dload_flg, o.termn_para_dload_flg) as termn_para_dload_flg -- 终端参数下载标志
    ,nvl(n.ic_card_para_dload_flg, o.ic_card_para_dload_flg) as ic_card_para_dload_flg -- IC卡参数下载标志
    ,nvl(n.capk_dload_flg, o.capk_dload_flg) as capk_dload_flg -- CA公钥下载标志
    ,nvl(n.prop_belong_cd, o.prop_belong_cd) as prop_belong_cd -- 产权归属代码
    ,nvl(n.prop_belong_org_name, o.prop_belong_org_name) as prop_belong_org_name -- 产权所属机构名称
    ,nvl(n.supt_forgn_card_flg, o.supt_forgn_card_flg) as supt_forgn_card_flg -- 支持外卡标志
    ,nvl(n.forgn_card_org_brand_name, o.forgn_card_org_brand_name) as forgn_card_org_brand_name -- 外卡组织品牌名称
    ,nvl(n.supt_ic_card_flg, o.supt_ic_card_flg) as supt_ic_card_flg -- 支持IC卡标志
    ,nvl(n.access_way_cd, o.access_way_cd) as access_way_cd -- 接入方式代码
    ,nvl(n.termn_belong_org_id, o.termn_belong_org_id) as termn_belong_org_id -- 终端所属机构编号
    ,nvl(n.termn_belong_bank_num, o.termn_belong_bank_num) as termn_belong_bank_num -- 终端所属行号
    ,nvl(n.termn_batch_id, o.termn_batch_id) as termn_batch_id -- 终端批次编号
    ,nvl(n.termn_end_dt, o.termn_end_dt) as termn_end_dt -- 终端批结日期
    ,nvl(n.termn_para, o.termn_para) as termn_para -- 终端参数
    ,nvl(n.bind_tel_num, o.bind_tel_num) as bind_tel_num -- 绑定电话号码
    ,nvl(n.dist_cd, o.dist_cd) as dist_cd -- 行政区划代码
    ,nvl(n.termn_install_addr, o.termn_install_addr) as termn_install_addr -- 终端安装地址
    ,nvl(n.phone, o.phone) as phone -- 联系电话
    ,nvl(n.open_acct_teller, o.open_acct_teller) as open_acct_teller -- 开户柜员
    ,nvl(n.rec_dt, o.rec_dt) as rec_dt -- 记录日期
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.chn_id is null
                and o.lp_id is null
            ) or (
                o.mercht_id <> n.mercht_id
                or o.termn_id <> n.termn_id
                or o.uniq_mark_id <> n.uniq_mark_id
                or o.status_cd <> n.status_cd
                or o.sign_status_cd <> n.sign_status_cd
                or o.check_status_cd <> n.check_status_cd
                or o.stl_curr_cd <> n.stl_curr_cd
                or o.termn_mcc_code <> n.termn_mcc_code
                or o.manuf_name <> n.manuf_name
                or o.termn_model <> n.termn_model
                or o.termn_type_cd <> n.termn_type_cd
                or o.termn_para_dload_flg <> n.termn_para_dload_flg
                or o.ic_card_para_dload_flg <> n.ic_card_para_dload_flg
                or o.capk_dload_flg <> n.capk_dload_flg
                or o.prop_belong_cd <> n.prop_belong_cd
                or o.prop_belong_org_name <> n.prop_belong_org_name
                or o.supt_forgn_card_flg <> n.supt_forgn_card_flg
                or o.forgn_card_org_brand_name <> n.forgn_card_org_brand_name
                or o.supt_ic_card_flg <> n.supt_ic_card_flg
                or o.access_way_cd <> n.access_way_cd
                or o.termn_belong_org_id <> n.termn_belong_org_id
                or o.termn_belong_bank_num <> n.termn_belong_bank_num
                or o.termn_batch_id <> n.termn_batch_id
                or o.termn_end_dt <> n.termn_end_dt
                or o.termn_para <> n.termn_para
                or o.bind_tel_num <> n.bind_tel_num
                or o.dist_cd <> n.dist_cd
                or o.termn_install_addr <> n.termn_install_addr
                or o.phone <> n.phone
                or o.open_acct_teller <> n.open_acct_teller
                or o.rec_dt <> n.rec_dt
            ) or (
                 case when (
                           n.chn_id is null
                           and n.lp_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.chn_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.chn_pos_termn_info_mrmsf1_tm n
    full join ${iml_schema}.chn_pos_termn_info_mrmsf1_bk o
        on
            o.chn_id = n.chn_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.chn_pos_termn_info truncate partition for ('mrmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.chn_pos_termn_info exchange subpartition p_mrmsf1_${batch_date} with table ${iml_schema}.chn_pos_termn_info_mrmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.chn_pos_termn_info drop subpartition p_mrmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.chn_pos_termn_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.chn_pos_termn_info_mrmsf1_tm purge;
drop table ${iml_schema}.chn_pos_termn_info_mrmsf1_ex purge;
drop table ${iml_schema}.chn_pos_termn_info_mrmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'chn_pos_termn_info', partname => 'p_mrmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);