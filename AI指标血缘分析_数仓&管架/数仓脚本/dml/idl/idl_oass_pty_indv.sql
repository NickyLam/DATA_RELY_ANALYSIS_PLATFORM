/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_pty_indv
CreateDate: 20221106
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.oass_pty_indv drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_pty_indv add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_pty_indv (
etl_dt  --数据日期
,pbc_cust_num  --人行客户编号
,indv_en_name  --个人英文名称
,birth_dt  --出生日期
,birth_addr  --出生地址
,depositr_cate_cd  --存款人类别代码
,party_name  --当事人名称
,indv_bus_flg  --个体工商户标志
,indv_bus_cert_no  --个体工商户证件号码
,nation_cd  --国籍代码
,marriage_situ_cd  --婚姻状况代码
,nati_place_cd  --籍贯代码
,resd_status_cd  --居住状况代码
,nationty_cd  --民族代码
,taxpayer_idtfy_num  --纳税人识别号
,real_name_flg  --实名标志
,tax_resdnt_cty_cd  --税收居民国家代码组合
,tax_resdnt_idti_type_cd  --税收居民身份类型代码
,sm_bus_owner_flg  --小微企业主标志
,sm_bus_owner_cert_no  --小微企业主证件号码
,sm_bus_owner_cert_type_cd  --小微企业主证件类型代码
,gender_cd  --性别代码
,name  --姓名
,degree_cd  --学位代码
,blood_type_cd  --血型代码
,ctysd_contr_oper_acct_flg  --农村承包经营户标志
,farm_flg  --农户标志
,have_work_unit_flg  --有工作单位标志
,post_cd  --职务代码
,title_cd  --职称等级代码
,resdnt_char_cd  --居民性质代码
,rg_cd  --地区代码
,emply_flg  --行员标志
,dist_cd  --行政区划代码
,resdnt_flg  --居民标志
,nati_place  --籍贯
,age  --年龄
,owner_type_cd  --业主类型代码
,politic_status_cd  --政治面貌代码
,ghb_rela_peop_flg  --本行关系人标志
,health_status_cd  --健康状况代码
,spoken  --口语
,sys_in_cust_flg  --系统内客户标志
,cust_lev_cd  --客户级别代码
,tax_stament_flg  --税收居民取得自证声明标志
,indv_party_type_cd  --个人当事人类型代码
,hxb_post_type_cd  --在我行职务类型代码
,grad_school  --毕业院校
,crdt_cust_flg  --授信客户标志
,main_type_cd  --境内外标志
,tax_num_null_rs_descb  --纳税人识别号空值原因描述
,indv_bus_cert_type_cd  --个体工商户证件类型代码
,loan_card_no  --贷款卡号
,soci_secu_card_no  --社保卡卡号
,provi_fund_acct_num  --公积金账号
,agent_open_flg  --代理开户标志
,referrer_type_cd  --推荐人类型代码
,referrer_num  --推荐人号码
,obtain_emply_situ_cd  --从业状况代码
,open_acct_chn_cd  --开户渠道代码
,legal_en_last_name  --法定英文姓氏
,legal_en_mdl_name  --法定英文中间名
,legal_en_name  --法定英文名
,career_cd  --职业代码
,other_career_name  --其他职业名称
,share_ratio  --持股比例
,shard_type_cd  --股东类型代码
,ctrler_type_cd  --控制人类型代码
,start_dt  --开始时间
,end_dt  --结束时间
,id_mark  --增删标志
,party_id  --当事人编号
,lp_id  --法人编号

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.pbc_cust_num,chr(13),''),chr(10),'') as pbc_cust_num --人行客户编号
,replace(replace(t1.indv_en_name,chr(13),''),chr(10),'') as indv_en_name --个人英文名称
,t1.birth_dt as birth_dt --出生日期
,replace(replace(t1.birth_addr,chr(13),''),chr(10),'') as birth_addr --出生地址
,replace(replace(t1.depositr_cate_cd,chr(13),''),chr(10),'') as depositr_cate_cd --存款人类别代码
,replace(replace(substrb(t1.party_name,1,145),chr(13),''),chr(10),'') as party_name --当事人名称
,replace(replace(t1.indv_bus_flg,chr(13),''),chr(10),'') as indv_bus_flg --个体工商户标志
,replace(replace(t1.indv_bus_cert_no,chr(13),''),chr(10),'') as indv_bus_cert_no --个体工商户证件号码
,replace(replace(t1.nation_cd,chr(13),''),chr(10),'') as nation_cd --国籍代码
,replace(replace(t1.marriage_situ_cd,chr(13),''),chr(10),'') as marriage_situ_cd --婚姻状况代码
,replace(replace(t1.nati_place_cd,chr(13),''),chr(10),'') as nati_place_cd --籍贯代码
,replace(replace(t1.resd_status_cd,chr(13),''),chr(10),'') as resd_status_cd --居住状况代码
,replace(replace(t1.nationty_cd,chr(13),''),chr(10),'') as nationty_cd --民族代码
,replace(replace(t1.taxpayer_idtfy_num,chr(13),''),chr(10),'') as taxpayer_idtfy_num --纳税人识别号
,replace(replace(t1.real_name_flg,chr(13),''),chr(10),'') as real_name_flg --实名标志
,replace(replace(t1.tax_resdnt_cty_cd,chr(13),''),chr(10),'') as tax_resdnt_cty_cd --税收居民国家代码组合
,replace(replace(t1.tax_resdnt_idti_type_cd,chr(13),''),chr(10),'') as tax_resdnt_idti_type_cd --税收居民身份类型代码
,replace(replace(t1.sm_bus_owner_flg,chr(13),''),chr(10),'') as sm_bus_owner_flg --小微企业主标志
,replace(replace(t1.sm_bus_owner_cert_no,chr(13),''),chr(10),'') as sm_bus_owner_cert_no --小微企业主证件号码
,replace(replace(t1.sm_bus_owner_cert_type_cd,chr(13),''),chr(10),'') as sm_bus_owner_cert_type_cd --小微企业主证件类型代码
,replace(replace(t1.gender_cd,chr(13),''),chr(10),'') as gender_cd --性别代码
,replace(replace(t1.name,chr(13),''),chr(10),'') as name --姓名
,replace(replace(t1.degree_cd,chr(13),''),chr(10),'') as degree_cd --学位代码
,replace(replace(t1.blood_type_cd,chr(13),''),chr(10),'') as blood_type_cd --血型代码
,replace(replace(t1.ctysd_contr_oper_acct_flg,chr(13),''),chr(10),'') as ctysd_contr_oper_acct_flg --农村承包经营户标志
,replace(replace(t1.farm_flg,chr(13),''),chr(10),'') as farm_flg --农户标志
,replace(replace(t1.have_work_unit_flg,chr(13),''),chr(10),'') as have_work_unit_flg --有工作单位标志
,replace(replace(t1.post_cd,chr(13),''),chr(10),'') as post_cd --职务代码
,replace(replace(t1.title_cd,chr(13),''),chr(10),'') as title_cd --职称等级代码
,replace(replace(t1.resdnt_char_cd,chr(13),''),chr(10),'') as resdnt_char_cd --居民性质代码
,replace(replace(t1.rg_cd,chr(13),''),chr(10),'') as rg_cd --地区代码
,replace(replace(t1.emply_flg,chr(13),''),chr(10),'') as emply_flg --行员标志
,replace(replace(t1.dist_cd,chr(13),''),chr(10),'') as dist_cd --行政区划代码
,replace(replace(t1.resdnt_flg,chr(13),''),chr(10),'') as resdnt_flg --居民标志
,replace(replace(t1.nati_place,chr(13),''),chr(10),'') as nati_place --籍贯
,t1.age as age --年龄
,replace(replace(t1.owner_type_cd,chr(13),''),chr(10),'') as owner_type_cd --业主类型代码
,replace(replace(t1.politic_status_cd,chr(13),''),chr(10),'') as politic_status_cd --政治面貌代码
,replace(replace(t1.ghb_rela_peop_flg,chr(13),''),chr(10),'') as ghb_rela_peop_flg --本行关系人标志
,replace(replace(t1.health_status_cd,chr(13),''),chr(10),'') as health_status_cd --健康状况代码
,replace(replace(t1.spoken,chr(13),''),chr(10),'') as spoken --口语
,replace(replace(t1.sys_in_cust_flg,chr(13),''),chr(10),'') as sys_in_cust_flg --系统内客户标志
,replace(replace(t1.cust_lev_cd,chr(13),''),chr(10),'') as cust_lev_cd --客户级别代码
,replace(replace(t1.tax_stament_flg,chr(13),''),chr(10),'') as tax_stament_flg --税收居民取得自证声明标志
,replace(replace(t1.indv_party_type_cd,chr(13),''),chr(10),'') as indv_party_type_cd --个人当事人类型代码
,replace(replace(t1.hxb_post_type_cd,chr(13),''),chr(10),'') as hxb_post_type_cd --在我行职务类型代码
,replace(replace(t1.grad_school,chr(13),''),chr(10),'') as grad_school --毕业院校
,replace(replace(t1.crdt_cust_flg,chr(13),''),chr(10),'') as crdt_cust_flg --授信客户标志
,replace(replace(t1.main_type_cd,chr(13),''),chr(10),'') as main_type_cd --境内外标志
,replace(replace(t1.tax_num_null_rs_descb,chr(13),''),chr(10),'') as tax_num_null_rs_descb --纳税人识别号空值原因描述
,replace(replace(t1.indv_bus_cert_type_cd,chr(13),''),chr(10),'') as indv_bus_cert_type_cd --个体工商户证件类型代码
,replace(replace(t1.loan_card_no,chr(13),''),chr(10),'') as loan_card_no --贷款卡号
,replace(replace(t1.soci_secu_card_no,chr(13),''),chr(10),'') as soci_secu_card_no --社保卡卡号
,replace(replace(t1.provi_fund_acct_num,chr(13),''),chr(10),'') as provi_fund_acct_num --公积金账号
,replace(replace(t1.agent_open_flg,chr(13),''),chr(10),'') as agent_open_flg --代理开户标志
,replace(replace(t1.referrer_type_cd,chr(13),''),chr(10),'') as referrer_type_cd --推荐人类型代码
,replace(replace(t1.referrer_num,chr(13),''),chr(10),'') as referrer_num --推荐人号码
,replace(replace(t1.obtain_emply_situ_cd,chr(13),''),chr(10),'') as obtain_emply_situ_cd --从业状况代码
,replace(replace(t1.open_acct_chn_cd,chr(13),''),chr(10),'') as open_acct_chn_cd --开户渠道代码
,replace(replace(t1.legal_en_last_name,chr(13),''),chr(10),'') as legal_en_last_name --法定英文姓氏
,replace(replace(t1.legal_en_mdl_name,chr(13),''),chr(10),'') as legal_en_mdl_name --法定英文中间名
,replace(replace(t1.legal_en_name,chr(13),''),chr(10),'') as legal_en_name --法定英文名
,replace(replace(t1.career_cd,chr(13),''),chr(10),'') as career_cd --职业代码
,replace(replace(t1.other_career_name,chr(13),''),chr(10),'') as other_career_name --其他职业名称
,t1.share_ratio as share_ratio --持股比例
,replace(replace(t1.shard_type_cd,chr(13),''),chr(10),'') as shard_type_cd --股东类型代码
,replace(replace(t1.ctrler_type_cd,chr(13),''),chr(10),'') as ctrler_type_cd --控制人类型代码
,t1.start_dt as start_dt --开始时间
,t1.end_dt as end_dt --结束时间
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark --增删标志
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id --当事人编号
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id --法人编号
from ${iml_schema}.pty_indv t1    --个人当事人
where start_dt = to_date('${batch_date}','yyyymmdd') or end_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_pty_indv',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
