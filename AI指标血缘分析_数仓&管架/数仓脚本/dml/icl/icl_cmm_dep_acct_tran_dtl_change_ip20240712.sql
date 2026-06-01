/*
Purpose:    共性加工层-存款账户交易明细:包括所有行内存款账户的金融交易明细，数据来源于新核心系统。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py 20220930 icl_cmm_dep_acct_tran_dtl_change
Createdate: 20200424
Logs:	      20240102 陈伟峰 新增脚本用于更新IP\MAC地址字段
*/

set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop timeout partition and add partition
whenever sqlerror continue none;

--drop table ${icl_schema}.cmm_dep_acct_tran_dtl_bak20240712;
--create table ${icl_schema}.cmm_dep_acct_tran_dtl_bak20240712
--as select * from ${icl_schema}.cmm_dep_acct_tran_dtl
--where etl_dt >=date'2023-01-01';

-- 2.0 update data to target table
whenever sqlerror exit sql.sqlcode;
update icl.cmm_dep_acct_tran_dtl set chn_cd ='901001' 
 where etl_dt >=date'2023-01-01' 
 and acct_bill_flow_num in ('33978815',
'113632764',
'188257755',
'193589726',
'125084750',
'204990704',
'204990702',
'206125730',
'206231416',
'206305375',
'206399833',
'206225000',
'206396025',
'206466322',
'206743293',
'206742429',
'206673991',
'201378869',
'200958862',
'207116264',
'207118615',
'207123547',
'207060324',
'207153819',
'207145335',
'207542566',
'207392419',
'207421191',
'207558269',
'207396349',
'207378723',
'207696659',
'207794747',
'207713216',
'207995270',
'207955450',
'208023504',
'207992254',
'208052857',
'207972968',
'207934580',
'208024402',
'207805429',
'207779197',
'207557790',
'207755805',
'207591033',
'207589954',
'207514848',
'207917819',
'207918352',
'206645555',
'206902548',
'207590555',
'207555141',
'206936676',
'207601667',
'206982509',
'206646061',
'206934408',
'206981759',
'206922084',
'206930622',
'206924022',
'206931001',
'207047197',
'207090266',
'207128390',
'209602655',
'218621798',
'221978788',
'221979072',
'221979079',
'228387311',
'228456261',
'229662704',
'229663089',
'236520021',
'236520459',
'231293247',
'240966910',
'240966909',
'242342082',
'240966739',
'237356485',
'237914619',
'237913335',
'237914080',
'237915063',
'237914222',
'237914673',
'237914450',
'237988757',
'237989388',
'237988605',
'237913960',
'237913818',
'237988687',
'237914051',
'237914271',
'237914902',
'237915129',
'246497866');
commit;

/*
-- 2.0 update data to target table
whenever sqlerror exit sql.sqlcode;
merge into ${icl_schema}.cmm_dep_acct_tran_dtl t1
using msl.osbs_pub_trade_flow_bak20240607 t2
on (t1.ova_flow_num =t2.global_flow_no
and t1.acct_bill_flow_num =t2.seq_no)
when matched then update set t1.client_ip_addr =t2.IP,t1.cust_termn_mac_addr=t2.MAC
where t1.etl_dt >=to_date('20230101','yyyymmdd');
commit;
*/